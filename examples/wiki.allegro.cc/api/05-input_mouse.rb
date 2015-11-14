# https://wiki.allegro.cc/index.php?title=Allegro_5_Tutorial/Input
require 'allegro4r'
include Allegro4r::API

FPS = 60.0
SCREEN_W = 640
SCREEN_H = 480
BOUNCER_SIZE = 32

def main
  bouncer_x = SCREEN_W / 2.0 - BOUNCER_SIZE / 2.0
  bouncer_y = SCREEN_H / 2.0 - BOUNCER_SIZE / 2.0
  redraw = true

  raise "failed to initialize allegro!" unless al_init

  raise "failed to initialize the mouse!" unless al_install_mouse

  timer = al_create_timer(1.0 / FPS)
  raise "failed to create timer!" if timer.null?

  display = al_create_display(SCREEN_W, SCREEN_H)
  if display.null?
    al_destroy_timer(timer)
    raise "failed to create display!"
  end

  bouncer = al_create_bitmap(BOUNCER_SIZE, BOUNCER_SIZE)
  if bouncer.null?
    al_destroy_display(display)
    al_destroy_timer(timer)
    raise "failed to create bouncer bitmap!"
  end

  al_set_target_bitmap(bouncer)

  al_clear_to_color(al_map_rgb(255, 0, 255))

  al_set_target_bitmap(al_get_backbuffer(display))

  event_queue = al_create_event_queue
  if event_queue.null?
    al_destroy_bitmap(bouncer)
    al_destroy_display(display)
    al_destroy_timer(timer)
    raise "failed to create event_queue!"
  end

  al_register_event_source(event_queue, al_get_display_event_source(display))

  al_register_event_source(event_queue, al_get_timer_event_source(timer))

  al_register_event_source(event_queue, al_get_mouse_event_source)

  al_clear_to_color(al_map_rgb(0, 0, 0))

  al_flip_display

  al_start_timer(timer)

  ev = ALLEGROEVENT.new
  loop do
    al_wait_for_event(event_queue, ev)

    case ev[:type]
    when ALLEGRO_EVENT_TIMER
      redraw = true
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      break
    when ALLEGRO_EVENT_MOUSE_AXES, ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY
      bouncer_x = ev[:mouse][:x]
      bouncer_y = ev[:mouse][:y]
    when ALLEGRO_EVENT_MOUSE_BUTTON_UP
      break
    end

    if redraw && al_is_event_queue_empty(event_queue)
      redraw = false

      al_clear_to_color(al_map_rgb(0, 0, 0))

      al_draw_bitmap(bouncer, bouncer_x, bouncer_y, 0)

      al_flip_display
    end
  end

  al_destroy_bitmap(bouncer)
  al_destroy_timer(timer)
  al_destroy_display(display)
  al_destroy_event_queue(event_queue)
end

run_main(method(:main))
