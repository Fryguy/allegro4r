# Ruby port of ex_disable_screensaver.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

def main(argc, argv)
  event = ALLEGROEVENT.new
  done = false
  active = true
  fullscreen = false

  fullscreen = true if argc == 2 && argv[1] == "-fullscreen"

  abort_example("Could not init Allegro.\n") unless al_init

  al_install_keyboard
  al_init_image_addon
  al_init_font_addon

  al_set_new_display_flags(ALLEGRO_GENERATE_EXPOSE_EVENTS |
    (fullscreen ? ALLEGRO_FULLSCREEN : 0))

  display = al_create_display(640, 480)
  abort_example("Could not create display.\n") if display.null?

  font = al_load_font("data/font.tga", 0, 0)
  abort_example("Error loading font\n") if font.null?

  events = al_create_event_queue
  al_register_event_source(events, al_get_keyboard_event_source)
  # For expose events
  al_register_event_source(events, al_get_display_event_source(display))

  until done
    al_clear_to_color(al_map_rgb(0, 0, 0))
    al_draw_textf(font, al_map_rgb_f(1, 1, 1), 0, 0, 0,
      "Screen saver: %s" % (active ? "Normal" : "Inhibited"))
    al_flip_display
    al_wait_for_event(events, event)
    case event[:type]
    when ALLEGRO_EVENT_KEY_DOWN
      if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
        done = true
      elsif event[:keyboard][:keycode] == ALLEGRO_KEY_SPACE
        if al_inhibit_screensaver(active)
          active = !active
        end
      end
    end
  end

  al_destroy_font(font)
  al_destroy_event_queue(events)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
