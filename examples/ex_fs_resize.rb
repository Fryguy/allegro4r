# Ruby port of ex_fs_resize.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

NUM_RESOLUTIONS = 4

Resolution = Struct.new(:w, :h)
RES = [
  [640, 480],
  [800, 600],
  [1024, 768],
  [1280, 1024]
].map { |w, h| Resolution.new(w, h) }

$cur_res = 0

def redraw(picture)
  puts "redraw"
  target = al_get_target_bitmap
  w = al_get_bitmap_width(target)
  h = al_get_bitmap_height(target)

  color = al_map_rgb(
     128 + rand(128),
     128 + rand(128),
     128 + rand(128))
  al_clear_to_color(color)

  color = al_map_rgb(255, 0, 0)
  al_draw_line(0, 0, w, h, color, 0)
  al_draw_line(0, h, w, 0, color, 0)

  al_draw_bitmap(picture, 0, 0, 0)
  al_flip_display
end

def main_loop(display, picture)
  event = AllegroEvent.new

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))

  can_draw = true

  loop do
    redraw(picture) if al_is_event_queue_empty(queue) && can_draw
    al_wait_for_event(queue, event)

    if event[:type] == ALLEGRO_EVENT_DISPLAY_LOST
      log_printf("Display lost\n")
      can_draw = false
      next
    end
    if event[:type] == ALLEGRO_EVENT_DISPLAY_FOUND
      log_printf("Display found\n")
      can_draw = true
      next
    end
    next if event[:type] != ALLEGRO_EVENT_KEY_CHAR

    break if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE

    new_res = $cur_res

    if event[:keyboard][:unichar] == '+'.ord ||
        event[:keyboard][:unichar] == ' '.ord ||
        event[:keyboard][:keycode] == ALLEGRO_KEY_ENTER
      new_res += 1
      new_res = 0 if new_res >= NUM_RESOLUTIONS
    elsif event[:keyboard][:unichar] == '-'.ord
      new_res -= 1
      new_res = NUM_RESOLUTIONS - 1 if new_res < 0
    end

    if new_res != $cur_res
      $cur_res = new_res
      log_printf("Switching to %dx%d... ", RES[$cur_res].w, RES[$cur_res].h)
      if al_resize_display(display, RES[$cur_res].w, RES[$cur_res].h)
        log_printf("Succeeded.\n")
      else
        log_printf("Failed. current resolution: %dx%d\n",
          al_get_display_width(display), al_get_display_height(display))
      end
    end
  end

  al_destroy_event_queue(queue)
end

def main(argc, argv)
  abort_example("Could not init Allegro.\n") unless al_init
  al_init_primitives_addon
  al_install_keyboard
  al_init_image_addon

  open_log_monospace

  al_set_new_display_adapter(argv[1].to_i) if argc == 2

  al_set_new_display_flags(ALLEGRO_FULLSCREEN |
     ALLEGRO_GENERATE_EXPOSE_EVENTS)
  display = al_create_display(RES[$cur_res].w, RES[$cur_res].h)
  abort_example("Error creating display\n") if display.null?

  picture = al_load_bitmap("data/mysha.pcx")
  abort_example("mysha.pcx not found\n") if picture.null?

  main_loop(display, picture)

  al_destroy_bitmap(picture)

  # Destroying the fullscreen display restores the original screen
  # resolution.  Shutting down Allegro would automatically destroy the
  # display, too.
  al_destroy_display(display)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
