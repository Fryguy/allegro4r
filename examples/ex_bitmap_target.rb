# Ruby port of ex_bitmap_target.c from the Allegro examples.

# An example comparing FPS when drawing to a bitmap with the
# ALLEGRO_FORCE_LOCKING flag and without. Mainly meant as a test how much
# speedup direct drawing can give over the slow locking.

require 'allegro4r'

include Allegro4r::API
include Allegro4r::API::Font
include Allegro4r::API::Image
include Allegro4r::API::Primitives

require_relative "common"

W = 300 # Size of target bitmap.
H = 300
RW = 50 # Size of rectangle we draw to it.
RH = 50
$display = nil
$target = nil # The target bitmap.
$x = $y = $dx = $dy = 0.0 # Position and velocity of moving rectangle.
$last_time = 0.0 # For controling speed.
$quit = false # Flag to record Esc key or X button.
$myfont = nil # Our font.
$queue = nil # Our events queue.

# Print some text with a shadow.
def print(x, y, format, *args)
  message = format % args

  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)

  al_draw_text($myfont, al_map_rgb(0, 0, 0), x + 2, y + 2, 0, message)
  al_draw_text($myfont, al_map_rgb(255, 255, 255), x, y, 0, message)
end

# Draw our example scene.
def draw
  dt = 0.0
  t = al_get_time
  dt = t - $last_time if $last_time > 0
  $last_time = t

  al_set_target_bitmap($target)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA)

  al_draw_filled_rectangle($x, $y, $x + RW, $y + RH, al_map_rgba_f(1, 0, 0, 1))
  al_draw_filled_rectangle(0, 0, W, H, al_map_rgba_f(1, 1, 0, 0.1))

  $x += $dx * dt
  if $x < 0
    $x = 0.0
    $dx = -$dx
  end
  if $x + RW > W
    $x = (W - RW).to_f
    $dx = -$dx
  end
  $y += $dy * dt
  if $y < 0
    $y = 0.0
    $dy = -$dy
  end
  if $y + RH > H
    $y = (H - RH).to_f
    $dy = -$dy
  end

  al_set_target_backbuffer($display)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  al_clear_to_color(al_map_rgba_f(0, 0, 1, 1))
  xs = 1 + 0.2 * Math.sin(t * ALLEGRO_PI * 2)
  ys = 1 + 0.2 * Math.sin(t * ALLEGRO_PI * 2)
  a = t * ALLEGRO_PI * 2 / 3
  al_draw_scaled_rotated_bitmap($target, W / 2, H / 2, 320, 240, xs, ys, a, 0)
end

# Run the FPS test.
def run
  event = ALLEGROEVENT.new
  frames = 0

  $target = al_create_bitmap(W, H)
  al_set_target_bitmap($target)
  al_clear_to_color(al_map_rgba_f(1, 1, 0, 1))

  al_set_target_backbuffer($display)

  $dx = 81.0
  $dy = 63.0

  start = al_get_time
  catch :done do
    loop do
      # Check for ESC key or close button event and quit in either case.
      unless al_is_event_queue_empty($queue)
        while al_get_next_event($queue, event)
          case event[:type]
          when ALLEGRO_EVENT_DISPLAY_CLOSE
            $quit = true
            throw :done

          when ALLEGRO_EVENT_KEY_DOWN
            if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
              $quit = true
              throw :done
            end
            if event[:keyboard][:keycode] == ALLEGRO_KEY_SPACE
              throw :done
            end
          end
        end
      end
      draw
      print(0, 0, "FPS: %.1f", frames / (al_get_time - start))
      if al_get_new_bitmap_flags & ALLEGRO_FORCE_LOCKING != 0
        print(0, al_get_font_line_height($myfont), "using forced bitmap locking")
      else
        print(0, al_get_font_line_height($myfont), "drawing directly to bitmap")
      end
      print(0, al_get_font_line_height($myfont) * 2,
        "Press SPACE to toggle drawing method.")
      al_flip_display
      frames += 1
    end
  end

  al_destroy_bitmap($target)
end

def main
  abort_example("Could not init Allegro.\n") unless al_init

  al_init_primitives_addon
  al_install_keyboard
  al_init_image_addon
  al_init_font_addon

  $display = al_create_display(640, 480)
  abort_example("Error creating display\n") if $display.null?

  $queue = al_create_event_queue
  al_register_event_source($queue, al_get_keyboard_event_source)
  al_register_event_source($queue, al_get_display_event_source($display))

  $myfont = al_load_font("data/font.tga", 0, 0)
  abort_example("font.tga not found\n") if $myfont.null?

  until $quit
    if al_get_new_bitmap_flags & ALLEGRO_FORCE_LOCKING != 0
      al_set_new_bitmap_flags(ALLEGRO_VIDEO_BITMAP)
    else
      al_set_new_bitmap_flags(ALLEGRO_FORCE_LOCKING)
    end
    run
  end

  al_destroy_event_queue($queue)
end

run_main(method(:main))
