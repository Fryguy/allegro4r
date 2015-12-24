# https://wiki.allegro.cc/index.php?title=Allegro_5_Tutorial/Timers
require 'allegro4r'
include Allegro4r::API

FPS = 60.0

def main
  redraw = true

  raise "failed to initialize allegro!" unless al_init

  timer = al_create_timer(1.0 / FPS)
  raise "failed to create timer!" if timer.null?

  display = al_create_display(640, 480)
  if display.null?
    al_destroy_timer(timer)
    raise "failed to create display!"
  end

  event_queue = al_create_event_queue
  if event_queue.null?
    al_destroy_display(display)
    al_destroy_timer(timer)
    raise "failed to create event_queue!"
  end

  al_register_event_source(event_queue, al_get_display_event_source(display))

  al_register_event_source(event_queue, al_get_timer_event_source(timer))

  al_clear_to_color(al_map_rgb(0, 0, 0))

  al_flip_display

  al_start_timer(timer)

  ev = AllegroEvent.new
  loop do
    al_wait_for_event(event_queue, ev)

    case ev[:type]
    when ALLEGRO_EVENT_TIMER         then redraw = true
    when ALLEGRO_EVENT_DISPLAY_CLOSE then break
    end

    if redraw && al_is_event_queue_empty(event_queue)
      redraw = false
      al_clear_to_color(al_map_rgb(0, 0, 0))
      al_flip_display
    end
  end

  al_destroy_timer(timer)
  al_destroy_display(display)
  al_destroy_event_queue(event_queue)
end

run_main(method(:main))
