# Ruby port of ex_expose.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

def main
  abort_example("Could not init Allegro.\n") unless al_init

  al_init_primitives_addon
  al_init_image_addon
  al_install_keyboard
  al_install_mouse

  al_set_new_display_flags(ALLEGRO_RESIZABLE |
    ALLEGRO_GENERATE_EXPOSE_EVENTS)
  al_set_new_display_option(:allegro_single_buffer, 1, ALLEGRO_REQUIRE)
  display = al_create_display(320, 200)
  abort_example("Error creating display\n") if display.null?

  bitmap = al_load_bitmap("data/mysha.pcx")
  abort_example("mysha.pcx not found or failed to load\n") if bitmap.null?
  al_draw_bitmap(bitmap, 0, 0, 0)
  al_flip_display

  timer = al_create_timer(0.1)

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_mouse_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))
  al_register_event_source(queue, al_get_timer_event_source(timer))
  al_start_timer(timer)

  event = AllegroEvent.new
  loop do
    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      break
    when ALLEGRO_EVENT_KEY_DOWN
      break if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
    when ALLEGRO_EVENT_DISPLAY_RESIZE
      al_acknowledge_resize(event[:display][:source])
    when ALLEGRO_EVENT_DISPLAY_EXPOSE
      x = event[:display][:x]
      y = event[:display][:y]
      w = event[:display][:width]
      h = event[:display][:height]
      puts x, y, w, h
      # Draw a red rectangle over the damaged area.
      al_set_blender(:allegro_add, :allegro_one, :allegro_zero)
      al_draw_filled_rectangle(x, y, x + w, y + h, al_map_rgba_f(1, 0, 0, 1))
      al_flip_display
    when ALLEGRO_EVENT_TIMER
      # Slowly restore the original bitmap.
      al_set_blender(:allegro_add, :allegro_alpha, :allegro_inverse_alpha)
      (0...al_get_display_height(display)).step(200) do |y|
        (0...al_get_display_width(display)).step(320) do |x|
          al_draw_tinted_bitmap(bitmap, al_map_rgba_f(1, 1, 1, 0.1), x, y, 0)
        end
      end
      al_flip_display
    end
  end

  al_destroy_event_queue(queue)
  al_destroy_bitmap(bitmap)
end

run_main(method(:main))
