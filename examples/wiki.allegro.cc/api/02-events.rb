# https://wiki.allegro.cc/index.php?title=Allegro_5_Tutorial/Events
require 'allegro4r'
include Allegro4r::API

def main
  raise "failed to initialize allegro!" unless al_init

  display = al_create_display(640, 480)
  raise "failed to create display!" if display.null?

  event_queue = al_create_event_queue
  if event_queue.null?
    al_destroy_display(display)
    raise "failed to create event_queue!"
  end

  al_register_event_source(event_queue, al_get_display_event_source(display))

  al_clear_to_color(al_map_rgb(0, 0, 0))

  al_flip_display

  ev = AllegroEvent.new
  timeout = AllegroTimeout.new
  loop do
    al_init_timeout(timeout, 0.06)

    get_event = al_wait_for_event_until(event_queue, ev, timeout)

    break if get_event && ev[:type] == ALLEGRO_EVENT_DISPLAY_CLOSE

    al_clear_to_color(al_map_rgb(0, 0, 0))
    al_flip_display
  end

  al_destroy_display(display)
  al_destroy_event_queue(event_queue)
end

run_main(method(:main))
