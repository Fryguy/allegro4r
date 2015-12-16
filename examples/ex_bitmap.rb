# Ruby port of ex_bitmap.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

def main(argc, argv)
  redraw = true
  zoom = 1.0

  if argc > 1
    filename = argv[1]
  else
    filename = "data/mysha.pcx"
  end

  abort_example("Could not init Allegro.\n") unless al_init

  open_log

  al_set_new_display_adapter(argv[2].to_i) if argc > 2

  al_install_mouse
  al_install_keyboard

  al_init_image_addon

  display = al_create_display(640, 480)
  abort_example("Error creating display\n") if display.null?

  al_set_window_title(display, filename)

  # We load the bitmap into a memory bitmap, because creating a
  # display bitmap could fail if the bitmap is too big to fit into a
  # single texture.
  # FIXME: Or should A5 automatically created multiple display bitmaps?
  al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP)
  t0 = al_get_time
  membitmap = al_load_bitmap(filename)
  t1 = al_get_time
  abort_example("%s not found or failed to load\n", filename) if membitmap.null?
  al_set_new_bitmap_flags(ALLEGRO_VIDEO_BITMAP)

  log_printf("Loading took %.4f seconds\n", t1 - t0)

  # FIXME:
  # Now try to split the memory bitmap into display bitmaps?
  bitmap = al_clone_bitmap(membitmap)
  bitmap = membitmap unless bitmap.null?

  timer = al_create_timer(1.0 / 30)
  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))
  al_register_event_source(queue, al_get_timer_event_source(timer))
  al_start_timer(timer)

  event = ALLEGROEVENT.new
  loop do
    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_DISPLAY_ORIENTATION
      o = event[:display][:orientation]
      case o
      when ALLEGRO_DISPLAY_ORIENTATION_0_DEGREES   then log_printf("0 degrees\n")
      when ALLEGRO_DISPLAY_ORIENTATION_90_DEGREES  then log_printf("90 degrees\n")
      when ALLEGRO_DISPLAY_ORIENTATION_180_DEGREES then log_printf("180 degrees\n")
      when ALLEGRO_DISPLAY_ORIENTATION_270_DEGREES then log_printf("270 degrees\n")
      when ALLEGRO_DISPLAY_ORIENTATION_FACE_UP     then log_printf("Face up\n")
      when ALLEGRO_DISPLAY_ORIENTATION_FACE_DOWN   then log_printf("Face down\n")
      end
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      break
    when ALLEGRO_EVENT_KEY_CHAR
      break if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
      case event[:keyboard][:unichar].chr
      when '1' then zoom = 1.0
      when '+' then zoom *= 1.1
      when '-' then zoom /= 1.1
      when 'f' then zoom = al_get_display_width(display).to_f / al_get_bitmap_width(bitmap)
      end
    when ALLEGRO_EVENT_TIMER
      redraw = true
    end

    if redraw && al_is_event_queue_empty(queue)
      redraw = false
      al_clear_to_color(al_map_rgb_f(0, 0, 0))
      if zoom == 1
        al_draw_bitmap(bitmap, 0, 0, 0)
      else
        al_draw_scaled_rotated_bitmap(bitmap,
          0, 0, 0, 0, zoom, zoom, 0, 0)
      end
      al_flip_display
    end
  end

  al_destroy_bitmap(bitmap)

  close_log(false)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
