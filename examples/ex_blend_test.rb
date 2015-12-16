# Ruby port of ex_blend_test.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

$test_only_index = nil
$test_index = 0
$test_display = false
$display = nil

def print_color(c)
  r, g, b, a = al_unmap_rgba_f(c)
  log_printf("%.2f, %.2f, %.2f, %.2f", r, g, b, a)
end

def test(src_col, dst_col, src_format, dst_format,
  src, dst, src_a, dst_a, operation, verbose)

  al_set_new_bitmap_format(dst_format)
  al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  dst_bmp = al_create_bitmap(1, 1)
  al_set_target_bitmap(dst_bmp)
  al_clear_to_color(dst_col)
  if operation == 0
    al_set_new_bitmap_format(src_format)
    src_bmp = al_create_bitmap(1, 1)
    al_set_target_bitmap(src_bmp)
    al_clear_to_color(src_col)
    al_set_target_bitmap(dst_bmp)
    al_set_separate_blender(ALLEGRO_ADD, src, dst, ALLEGRO_ADD, src_a, dst_a)
    al_draw_bitmap(src_bmp, 0, 0, 0)
    al_destroy_bitmap(src_bmp)
  elsif operation == 1
    al_set_separate_blender(ALLEGRO_ADD, src, dst, ALLEGRO_ADD, src_a, dst_a)
    al_draw_pixel(0, 0, src_col)
  elsif operation == 2
    al_set_separate_blender(ALLEGRO_ADD, src, dst, ALLEGRO_ADD, src_a, dst_a)
    al_draw_line(0, 0, 1, 1, src_col, 0)
  end

  result = al_get_pixel(dst_bmp, 0, 0)

  al_set_target_backbuffer($display)

  if $test_display
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
    al_draw_bitmap(dst_bmp, 0, 0, 0)
  end

  al_destroy_bitmap(dst_bmp)

  return result unless verbose

  log_printf("---\n")
  log_printf("test id: %d\n", $test_index)

  log_printf("source     : ")
  print_color(src_col)
  log_printf(" %s format=%d mode=%d alpha=%d\n",
    operation == 0 ? "bitmap" : operation == 1 ? "pixel" : "prim",
    Allegro4r::API.enum_value(src_format), src, src_a)

  log_printf("destination: ")
  print_color(dst_col)
  log_printf(" format=%d mode=%d alpha=%d\n",
    Allegro4r::API.enum_value(dst_format), dst, dst_a)

  log_printf("result     : ")
  print_color(result)
  log_printf("\n")

  result
end

def same_color(c1, c2)
  r1, g1, b1, a1 = al_unmap_rgba_f(c1)
  r2, g2, b2, a2 = al_unmap_rgba_f(c2)
  dr = r1 - r2
  dg = g1 - g2
  db = b1 - b2
  da = a1 - a2
  d = Math.sqrt(dr * dr + dg * dg + db * db + da * da)
  d < 0.01
end

def get_factor(operation, alpha)
  case operation
  when ALLEGRO_ZERO then return 0
  when ALLEGRO_ONE then return 1
  when ALLEGRO_ALPHA then return alpha
  when ALLEGRO_INVERSE_ALPHA then return 1 - alpha
  end
  0
end

def has_alpha(format)
  return false if format == :pixel_format_rgb_888
  return false if format == :pixel_format_bgr_888
  true
end

def clamp(x)
  x > 1 ? 1 : x
end

def reference_implementation(src_col, dst_col, src_format, dst_format,
  src_mode, dst_mode, src_alpha, dst_alpha, operation)
  sr, sg, sb, sa = al_unmap_rgba_f(src_col)
  dr, dg, db, da = al_unmap_rgba_f(dst_col)

  # Do we even have source alpha?
  sa = 1 if operation == 0 && !has_alpha(src_format)

  r = sr
  g = sg
  b = sb
  a = sa

  src = get_factor(src_mode, a)
  dst = get_factor(dst_mode, a)
  asrc = get_factor(src_alpha, a)
  adst = get_factor(dst_alpha, a)

  r = r * src + dr * dst
  g = g * src + dg * dst
  b = b * src + db * dst
  a = a * asrc + da * adst

  r = clamp(r)
  g = clamp(g)
  b = clamp(b)
  a = clamp(a)

  # Do we even have destination alpha?
  a = 1 unless has_alpha(dst_format)

  al_map_rgba_f(r, g, b, a)
end

def do_test2(src_col, dst_col, src_format, dst_format,
  src_mode, dst_mode, src_alpha, dst_alpha, operation)
  $test_index += 1

  return if $test_only_index && $test_index != $test_only_index

  reference = reference_implementation(
    src_col, dst_col, src_format, dst_format,
    src_mode, dst_mode, src_alpha, dst_alpha, operation)

  result = test(src_col, dst_col, src_format,
    dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
    operation, false)

  if !same_color(reference, result)
    test(src_col, dst_col, src_format,
      dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
      operation, true)
    log_printf("expected   : ")
    print_color(reference)
    log_printf("\n")
    log_printf("FAILED\n")
  else
    log_printf(" OK")
  end

  if $test_display
    dst_format = al_get_display_format($display)
    from_display = al_get_pixel(al_get_backbuffer($display), 0, 0)
    reference = reference_implementation(
      src_col, dst_col, src_format, dst_format,
      src_mode, dst_mode, src_alpha, dst_alpha, operation)

    unless same_color(reference, from_display)
      test(src_col, dst_col, src_format,
        dst_format, src_mode, dst_mode, src_alpha, dst_alpha,
        operation, true)
      log_printf("displayed  : ")
      print_color(from_display)
      log_printf("\n")
      log_printf("expected   : ")
      print_color(reference)
      log_printf("\n")
      log_printf("(FAILED on display)\n")
    end
  end
end

def do_test1(src_col, dst_col, src_format, dst_format)
  smodes = [ALLEGRO_ALPHA, ALLEGRO_ZERO, ALLEGRO_ONE,
    ALLEGRO_INVERSE_ALPHA]
  dmodes = [ALLEGRO_INVERSE_ALPHA, ALLEGRO_ZERO, ALLEGRO_ONE,
    ALLEGRO_ALPHA]
  4.times do |i|
    4.times do |j|
      4.times do |k|
        4.times do |l|
          3.times do |m|
            do_test2(src_col, dst_col,
              src_format, dst_format,
              smodes[i], dmodes[j], smodes[k], dmodes[l],
              m)
          end
        end
      end
    end
  end
end

def c(*args)
  al_map_rgba_f(*args)
end

def main(argc, argv)
  src_colors = []
  dst_colors = []
  src_formats = [
    :pixel_format_abgr_8888,
    :pixel_format_bgr_888
  ]
  dst_formats = [
    :pixel_format_abgr_8888,
    :pixel_format_bgr_888
  ]
  src_colors[0] = c(0, 0, 0, 1)
  src_colors[1] = c(1, 1, 1, 1)
  dst_colors[0] = c(1, 1, 1, 1)
  dst_colors[1] = c(0, 0, 0, 0)

  (1...argc).each do |i|
    if argv[i] == "-d"
      $test_display = 1
    else
      $test_only_index = argv[i].to_i
    end
  end

  abort_example("Could not initialise Allegro\n") unless al_init

  open_log

  al_init_primitives_addon
  if $test_display
    $display = al_create_display(100, 100)
    abort_example("Unable to create display\n") if $display.null?
  end

  2.times do |i|
    2.times do |j|
      2.times do |l|
        2.times do |m|
          do_test1(
            src_colors[i],
            dst_colors[j],
            src_formats[l],
            dst_formats[m])
        end
      end
    end
  end
  log_printf("\nDone\n")

  if $test_only_index && $test_display
    event = ALLEGROEVENT.new
    al_flip_display
    al_install_keyboard
    queue = al_create_event_queue
    al_register_event_source(queue, al_get_keyboard_event_source)
    al_wait_for_event(queue, event)
  end

  close_log(true)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
