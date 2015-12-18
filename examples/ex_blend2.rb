# Ruby port of ex_blend2.cpp from the Allegro examples.

# Example program for the Allegro library, by Peter Wang.
#
# Compare software blending routines with hardware blending.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

require_relative "nihgui"

$allegro = nil
$mysha = nil
$allegro_bmp = nil
$mysha_bmp = nil
$target = nil
$target_bmp = nil

class Prog
  private

  attr_accessor :d, :memory_label, :texture_label, :source_label,
                :destination_label, :source_image, :destination_image,
                :draw_mode, :operation_label, :operations, :rgba_label, :r, :g,
                :b, :a

  public

  def initialize(theme, display)
    self.d = Dialog.new(theme, display, 20, 40)
    self.memory_label = Label.new("Memory")
    self.texture_label = Label.new("Texture")
    self.source_label = Label.new
    self.source_label = Label.new("Source", false)
    self.destination_label = Label.new("Destination", false)
    self.source_image = List.new(0)
    self.destination_image = List.new(1)
    self.draw_mode = List.new(0)
    self.operation_label = []
    self.operations = []
    self.rgba_label = []
    self.r = []
    self.g = []
    self.b = []
    self.a = []

    d.add(memory_label, 9, 0, 10, 2)
    d.add(texture_label, 0, 0, 10, 2)
    d.add(source_label, 1, 15, 6, 2)
    d.add(destination_label, 7, 15, 6, 2)

    images = [source_image, destination_image, draw_mode]
    images.each_with_index do |image, i|
      if (i < 2)
        image.append_item("Mysha")
        image.append_item("Allegro")
        image.append_item("Mysha (tinted)")
        image.append_item("Allegro (tinted)")
        image.append_item("Color")
      else
        image.append_item("original")
        image.append_item("scaled")
        image.append_item("rotated")
      end
      d.add(image, 1 + i * 6, 17, 4, 6)
    end

    4.times do |i|
      operation_label[i] = Label.new(i % 2 == 0 ? "Color" : "Alpha", false)
      d.add(operation_label[i], 1 + i * 3, 24, 3, 2)
      l = operations[i] = List.new
      l.append_item("ONE")
      l.append_item("ZERO")
      l.append_item("ALPHA")
      l.append_item("INVERSE")
      l.append_item("SRC_COLOR")
      l.append_item("DEST_COLOR")
      l.append_item("INV_SRC_COLOR")
      l.append_item("INV_DEST_COLOR")
      d.add(l, 1 + i * 3, 25, 3, 9)
    end

    (4...6).each do |i|
      operation_label[i] = Label.new(i == 4 ? "Blend op" : "Alpha op", false)
      d.add(operation_label[i], 1 + i * 3, 24, 3, 2)
      l = operations[i] = List.new
      l.append_item("ADD")
      l.append_item("SRC_MINUS_DEST")
      l.append_item("DEST_MINUS_SRC")
      d.add(l, 1 + i * 3, 25, 3, 6)
    end

    rgba_label[0] = Label.new("Source tint/color RGBA")
    rgba_label[1] = Label.new("Dest tint/color RGBA")
    d.add(rgba_label[0], 1, 34, 5, 1)
    d.add(rgba_label[1], 7, 34, 5, 1)

    2.times do |i|
      r[i] = HSlider.new(255, 255)
      g[i] = HSlider.new(255, 255)
      b[i] = HSlider.new(255, 255)
      a[i] = HSlider.new(255, 255)
      d.add(r[i], 1 + i * 6, 35, 5, 1)
      d.add(g[i], 1 + i * 6, 36, 5, 1)
      d.add(b[i], 1 + i * 6, 37, 5, 1)
      d.add(a[i], 1 + i * 6, 38, 5, 1)
    end
  end

  def run
    d.prepare

    until d.quit_requested?
      if d.draw_requested?
        al_clear_to_color(al_map_rgb(128, 128, 128))
        draw_samples
        d.draw
        al_flip_display
      end

      d.run_step(true)
    end
  end

  private

  def str_to_blend_mode(str)
    return :allegro_zero               if str == "ZERO"
    return :allegro_one                if str == "ONE"
    return :allegro_src_color          if str == "SRC_COLOR"
    return :allegro_dest_color         if str == "DEST_COLOR"
    return :allegro_inverse_src_color  if str == "INV_SRC_COLOR"
    return :allegro_inverse_dest_color if str == "INV_DEST_COLOR"
    return :allegro_alpha              if str == "ALPHA"
    return :allegro_inverse_alpha      if str == "INVERSE"
    return :allegro_add                if str == "ADD"
    return :allegro_src_minus_dest     if str == "SRC_MINUS_DEST"
    return :allegro_dest_minus_src     if str == "DEST_MINUS_SRC"

    ALLEGRO_ASSERT(false)
    :allegro_one
  end

  def draw_background(x, y)
    c = [
      al_map_rgba(0x66, 0x66, 0x66, 0xff),
      al_map_rgba(0x99, 0x99, 0x99, 0xff)
    ]

    (320 / 16).times do |i|
      (200 / 16).times do |j|
        al_draw_filled_rectangle(x + i * 16, y + j * 16,
          x + i * 16 + 16, y + j * 16 + 16,
          c[(i + j) & 1])
      end
    end
  end

  def makecol(r, g, b, a)
    # Premultiply alpha
    rf = r / 255.0
    gf = g / 255.0
    bf = b / 255.0
    af = a / 255.0
    al_map_rgba_f(rf * af, gf * af, bf * af, af)
  end

  def contains(haystack, needle)
    haystack.include?(needle)
  end

  def draw_bitmap(str, how, memory, destination)
    i = destination ? 1 : 0
    rv = r[i].get_cur_value
    gv = g[i].get_cur_value
    bv = b[i].get_cur_value
    av = a[i].get_cur_value
    color = makecol(rv, gv, bv, av)

    if (contains(str, "Mysha"))
      bmp = memory ? $mysha_bmp : $mysha
    else
      bmp = memory ? $allegro_bmp : $allegro
    end

    if how == "original"
      if str == "Color"
        al_draw_filled_rectangle(0, 0, 320, 200, color)
      elsif contains(str, "tint")
        al_draw_tinted_bitmap(bmp, color, 0, 0, 0)
      else
        al_draw_bitmap(bmp, 0, 0, 0)
      end
    elsif how == "scaled"
      w = al_get_bitmap_width(bmp)
      h = al_get_bitmap_height(bmp)
      s = 200.0 / h * 0.9
      if str == "Color"
        al_draw_filled_rectangle(10, 10, 300, 180, color)
      elsif contains(str, "tint")
        al_draw_tinted_scaled_bitmap(bmp, color, 0, 0, w, h,
          160 - w * s / 2, 100 - h * s / 2, w * s, h * s, 0)
      else
        al_draw_scaled_bitmap(bmp, 0, 0, w, h,
          160 - w * s / 2, 100 - h * s / 2, w * s, h * s, 0)
      end
    elsif how == "rotated"
      if str == "Color"
        al_draw_filled_circle(160, 100, 100, color)
      elsif contains(str, "tint")
        al_draw_tinted_rotated_bitmap(bmp, color, 160, 100,
          160, 100, ALLEGRO_PI / 8, 0)
      else
        al_draw_rotated_bitmap(bmp, 160, 100,
          160, 100, ALLEGRO_PI / 8, 0)
      end
    end
  end

  def blending_test(memory)
    transparency = al_map_rgba_f(0, 0, 0, 0)
    op = str_to_blend_mode(operations[4].get_selected_item_text)
    aop = str_to_blend_mode(operations[5].get_selected_item_text)
    src = str_to_blend_mode(operations[0].get_selected_item_text)
    asrc = str_to_blend_mode(operations[1].get_selected_item_text)
    dst = str_to_blend_mode(operations[2].get_selected_item_text)
    adst = str_to_blend_mode(operations[3].get_selected_item_text)

    # Initialize with destination.
    al_clear_to_color(transparency) # Just in case.
    al_set_blender(:allegro_add, :allegro_one, :allegro_zero)
    draw_bitmap(destination_image.get_selected_item_text,
      "original", memory, true)

    # Now draw the blended source over it.
    al_set_separate_blender(op, src, dst, aop, asrc, adst)
    draw_bitmap(source_image.get_selected_item_text,
      draw_mode.get_selected_item_text, memory, false)
  end

  def draw_samples
    state = ALLEGROSTATE.new
    al_store_state(state, Allegro4r::API.enum_value(:allegro_state_target_bitmap) |
      Allegro4r::API.enum_value(:allegro_state_blender))

    # Draw a background, in case our target bitmap will end up with
    # alpha in it.
    draw_background(40, 20)
    draw_background(400, 20)

    # Test standard blending.
    al_set_target_bitmap($target)
    blending_test(false)

    # Test memory blending.
    al_set_target_bitmap($target_bmp)
    blending_test(true)

    # Display results.
    al_restore_state(state)
    al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)
    al_draw_bitmap($target, 40, 20, 0)
    al_draw_bitmap($target_bmp, 400, 20, 0)

    al_restore_state(state)
  end
end

def main
  abort_example("Could not init Allegro\n") unless al_init
  al_init_primitives_addon
  al_install_keyboard
  al_install_mouse

  al_init_font_addon
  al_init_image_addon

  al_set_new_display_flags(ALLEGRO_GENERATE_EXPOSE_EVENTS)
  display = al_create_display(800, 600)
  abort_example("Unable to create display\n") if display.null?

  font = al_load_font("data/fixed_font.tga", 0, 0)
  abort_example("Failed to load data/fixed_font.tga\n") if font.null?
  $allegro = al_load_bitmap("data/allegro.pcx")
  abort_example("Failed to load data/allegro.pcx\n") if $allegro.null?
  $mysha = al_load_bitmap("data/mysha256x256.png")
  abort_example("Failed to load data/mysha256x256.png\n") if $mysha.null?

  $target = al_create_bitmap(320, 200)

  al_add_new_bitmap_flag(ALLEGRO_MEMORY_BITMAP)
  $allegro_bmp = al_clone_bitmap($allegro)
  $mysha_bmp = al_clone_bitmap($mysha)
  $target_bmp = al_clone_bitmap($target)

  theme = Theme.new(font)
  prog = Prog.new(theme, display)
  prog.run

  al_destroy_bitmap($allegro)
  al_destroy_bitmap($allegro_bmp)
  al_destroy_bitmap($mysha)
  al_destroy_bitmap($mysha_bmp)
  al_destroy_bitmap($target)
  al_destroy_bitmap($target_bmp)

  al_destroy_font(font)
end

run_main(method(:main))
