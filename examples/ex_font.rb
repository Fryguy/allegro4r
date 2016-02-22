# Ruby port of ex_font.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

EURO = "\xe2\x82\xac"

def wait_for_esc(display)
  al_install_keyboard
  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))
  screen_clone = al_clone_bitmap(al_get_target_bitmap)
  event = AllegroEvent.new
  loop do
    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      break
    when ALLEGRO_EVENT_KEY_DOWN
      break if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
    when ALLEGRO_EVENT_DISPLAY_EXPOSE
      x = event[:display][:x]
      y = event[:display][:y]
      w = event[:display][:width]
      h = event[:display][:height]

      al_draw_bitmap_region(screen_clone, x, y, w, h,
        x, y, 0)
      al_update_display_region(x, y, w, h)
    end
  end
  al_destroy_bitmap(screen_clone)
  al_destroy_event_queue(queue)
end

def main
  ranges = [
    0x0020, 0x007F,  # ASCII
    0x00A1, 0x00FF,  # Latin 1
    0x0100, 0x017F,  # Extended-A
    0x20AC, 0x20AC   # Euro
  ]

  abort_example("Could not init Allegro.\n") unless al_init

  al_init_image_addon
  al_init_font_addon

  al_set_new_display_option(:allegro_single_buffer, 1, ALLEGRO_SUGGEST)
  al_set_new_display_flags(ALLEGRO_GENERATE_EXPOSE_EVENTS)
  display = al_create_display(320, 200)
  abort_example("Failed to create display\n") if display.null?
  bitmap = al_load_bitmap("data/mysha.pcx")
  abort_example("Failed to load mysha.pcx\n") if bitmap.null?

  f1 = al_load_font("data/bmpfont.tga", 0, 0)
  abort_example("Failed to load bmpfont.tga\n") if f1.null?

  font_bitmap = al_load_bitmap("data/a4_font.tga")
  abort_example("Failed to load a4_font.tga\n") if font_bitmap.null?
  f2 = al_grab_font_from_bitmap(font_bitmap, 4, ranges)

  f3 = al_create_builtin_font
  abort_example("Failed to create builtin font.\n") if f3.null?

  # Draw background
  al_draw_bitmap(bitmap, 0, 0, 0)

  # Draw red text
  al_draw_textf(f1, al_map_rgb(255, 0, 0), 10, 10, 0, "red")

  # Draw green text
  al_draw_textf(f1, al_map_rgb(0, 255, 0), 120, 10, 0, "green")

  # Draw a unicode symbol
  al_draw_textf(f2, al_map_rgb(0, 0, 255), 60, 60, 0, "Mysha's 0.02#{EURO}")

  # Draw a yellow text with the builtin font
  al_draw_textf(f3, al_map_rgb(255, 255, 0), 160, 160, ALLEGRO_ALIGN_CENTER,
    "a string from builtin font data")

  al_flip_display

  wait_for_esc(display)

  al_destroy_bitmap(bitmap)
  al_destroy_bitmap(font_bitmap)
  al_destroy_font(f1)
  al_destroy_font(f2)
  al_destroy_font(f3)
end

run_main(method(:main))
