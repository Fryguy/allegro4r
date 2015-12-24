# Ruby port of ex_display_events.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

MAX_EVENTS = 23

$events = []

def add_event(format, *args)
  $events.pop if $events.length == MAX_EVENTS
  $events.unshift(format % args)
end

def main
  event = AllegroEvent.new

  abort_example("Could not init Allegro.\n") unless al_init

  al_init_primitives_addon
  al_install_mouse
  al_install_keyboard
  al_init_image_addon
  al_init_font_addon

  al_set_new_display_flags(ALLEGRO_RESIZABLE)
  display = al_create_display(640, 480)
  abort_example("Error creating display\n") if display.null?

  font = al_load_font("data/fixed_font.tga", 1, 0)
  abort_example("data/fixed_font.tga not found\n") if font.null?

  black = al_map_rgb_f(0, 0, 0)
  red = al_map_rgb_f(1, 0, 0)
  blue = al_map_rgb_f(0, 0, 1)

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_mouse_event_source)
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))

  loop do
    if al_is_event_queue_empty(queue)
      x = 8
      y = 28
      al_clear_to_color(al_map_rgb(0xff, 0xff, 0xc0))

      al_draw_textf(font, blue, 8, 8, 0, "Display events (newest on top)")

      color = red
      $events.each do |event|
        al_draw_textf(font, color, x, y, 0, "%s" % event)
        color = black
        y += 20
      end
      al_flip_display
    end

    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY
      add_event("ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY")

    when ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY
      add_event("ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY")

    when ALLEGRO_EVENT_KEY_DOWN
      break if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE

    when ALLEGRO_EVENT_DISPLAY_RESIZE
      add_event("ALLEGRO_EVENT_DISPLAY_RESIZE x=%d, y=%d, " \
        "width=%d, height=%d",
        event[:display][:x], event[:display][:y], event[:display][:width],
        event[:display][:height])
      al_acknowledge_resize(event[:display][:source])

    when ALLEGRO_EVENT_DISPLAY_CLOSE
      add_event("ALLEGRO_EVENT_DISPLAY_CLOSE")

    when ALLEGRO_EVENT_DISPLAY_LOST
      add_event("ALLEGRO_EVENT_DISPLAY_LOST")

    when ALLEGRO_EVENT_DISPLAY_FOUND
      add_event("ALLEGRO_EVENT_DISPLAY_FOUND")

    when ALLEGRO_EVENT_DISPLAY_SWITCH_OUT
      add_event("ALLEGRO_EVENT_DISPLAY_SWITCH_OUT")

    when ALLEGRO_EVENT_DISPLAY_SWITCH_IN
      add_event("ALLEGRO_EVENT_DISPLAY_SWITCH_IN")

    end
  end

  al_destroy_event_queue(queue)
end

run_main(method(:main))
