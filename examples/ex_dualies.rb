# Ruby port of ex_dualies.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

def go
  event = AllegroEvent.new

  al_set_new_display_flags(ALLEGRO_FULLSCREEN)

  al_set_new_display_adapter(0)
  d1 = al_create_display(640, 480)
  abort_example("Error creating first display\n") if d1.null?
  b1 = al_load_bitmap("data/mysha.pcx")
  abort_example("Error loading mysha.pcx\n") if b1.null?

  al_set_new_display_adapter(1)
  d2 = al_create_display(640, 480)
  abort_example("Error creating second display\n") if d2.null?
  b2 = al_load_bitmap("data/allegro.pcx")
  abort_example("Error loading allegro.pcx\n") if b2.null?

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)

  loop do
    unless al_is_event_queue_empty(queue)
      al_get_next_event(queue, event)
      if event[:type] == ALLEGRO_EVENT_KEY_DOWN
        if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
          break
        end
      end
    end

    al_set_target_backbuffer(d1)
    al_draw_scaled_bitmap(b1, 0, 0, 320, 200, 0, 0, 640, 480, 0)
    al_flip_display

    al_set_target_backbuffer(d2)
    al_draw_scaled_bitmap(b2, 0, 0, 320, 200, 0, 0, 640, 480, 0)
    al_flip_display

    al_rest(0.1)
  end

  al_destroy_bitmap(b1)
  al_destroy_bitmap(b2)
  al_destroy_display(d1)
  al_destroy_display(d2)
end

def main
  abort_example("Could not init Allegro.\n") unless al_init

  al_install_keyboard

  al_init_image_addon

  abort_example("You need 2 or more adapters/monitors for this example.\n") if al_get_num_video_adapters < 2

  go
end

run_main(method(:main))
