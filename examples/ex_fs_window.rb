# Ruby port of ex_fs_window.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

def redraw
  w = al_get_display_width($display)
  h = al_get_display_height($display)
  pw = al_get_bitmap_width($picture)
  ph = al_get_bitmap_height($picture)
  th = al_get_font_line_height($font)
  cx = (w - pw) * 0.5
  cy = (h - ph) * 0.5
  white = al_map_rgb_f(1, 1, 1)

  color = al_map_rgb_f(0.8, 0.7, 0.9)
  al_clear_to_color(color)

  color = al_map_rgb(255, 0, 0)
  al_draw_line(0, 0, w, h, color, 0)
  al_draw_line(0, h, w, 0, color, 0)

  al_draw_bitmap($picture, cx, cy, 0)

  al_draw_textf($font, white, w / 2, cy + ph, ALLEGRO_ALIGN_CENTRE,
    "Press Space to toggle fullscreen")
  al_draw_textf($font, white, w / 2, cy + ph + th, ALLEGRO_ALIGN_CENTRE,
    "Press Enter to toggle window size")
  al_draw_textf($font, white, w / 2, cy + ph + th * 2, ALLEGRO_ALIGN_CENTRE,
    "Window: %dx%d (%s)" % [
    al_get_display_width($display), al_get_display_height($display),
    (al_get_display_flags($display) & ALLEGRO_FULLSCREEN_WINDOW != 0) ?
    "fullscreen" : "not fullscreen"])

  al_flip_display
end

def run
  event = AllegroEvent.new
  quit = false
  until quit do
    while al_get_next_event($queue, event) do
      case event[:type]
      when ALLEGRO_EVENT_DISPLAY_CLOSE
        quit = true
      when ALLEGRO_EVENT_KEY_DOWN
        case event[:keyboard][:keycode]
        when ALLEGRO_KEY_ESCAPE
          quit = true
        when ALLEGRO_KEY_SPACE
          opp = al_get_display_flags($display) & ALLEGRO_FULLSCREEN_WINDOW == 0
          al_set_display_flag($display, ALLEGRO_FULLSCREEN_WINDOW, opp)
          redraw
        when ALLEGRO_KEY_ENTER
          $big = !$big
          if $big
            al_resize_display($display, 800, 600)
          else
            al_resize_display($display, 640, 480)
          end
          redraw
        end
      end
    end
    # FIXME: Lazy timing
    al_rest(0.02)
    redraw
  end
end

def main
  abort_example("Could not init Allegro.\n") unless al_init

  al_init_primitives_addon
  al_install_keyboard
  al_init_image_addon
  al_init_font_addon

  al_set_new_display_flags(ALLEGRO_FULLSCREEN_WINDOW)
  $display = al_create_display(640, 480)
  abort_example("Error creating display\n") if $display.null?

  $queue = al_create_event_queue
  al_register_event_source($queue, al_get_keyboard_event_source)
  al_register_event_source($queue, al_get_display_event_source($display))

  $picture = al_load_bitmap("data/mysha.pcx")
  abort_example("mysha.pcx not found\n") if $picture.null?

  $font = al_load_font("data/fixed_font.tga", 0, 0)
  abort_example("data/fixed_font.tga not found.\n") if $font.null?

  redraw
  run

  al_destroy_display($display)

  al_destroy_event_queue($queue)
end

run_main(method(:main))
