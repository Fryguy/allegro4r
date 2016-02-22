# Ruby port of ex_filter.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

FPS = 60

class Example
  attr_accessor :display, :font, :bitmaps, :bg, :fg, :info
  attr_accessor :bitmap, :ticks

  def initialize
    @bitmaps = Array.new(2) { Array.new(9) }
    @bitmap = @ticks = 0
  end
end
$example = Example.new

FILTER_FLAGS = [
  0,
  ALLEGRO_MIN_LINEAR,
  ALLEGRO_MIPMAP,
  ALLEGRO_MIN_LINEAR | ALLEGRO_MIPMAP,
  0,
  ALLEGRO_MAG_LINEAR
]

FILTER_TEXT = [
  "nearest", "linear",
  "nearest mipmap", "linear mipmap"
]

def update
  $example.ticks += 1
end

def redraw
  w = al_get_display_width($example.display)
  h = al_get_display_height($example.display)

  al_clear_to_color($example.bg)

  6.times do |i|
    x = (i / 2) * w / 3 + w / 6
    y = (i % 2) * h / 2 + h / 4
    bmp = $example.bitmaps[$example.bitmap][i]
    bw = al_get_bitmap_width(bmp)
    bh = al_get_bitmap_height(bmp)
    t = 1 - 2 * (($example.ticks % (FPS * 16)) / 16.0 / FPS - 0.5).abs
    angle = $example.ticks * ALLEGRO_PI * 2 / FPS / 8

    if (i < 4)
      scale = 1 - t * 0.9
    else
      scale = 1 + t * 9
    end

    al_draw_textf($example.font, $example.fg, x, y - 64 - 14,
      ALLEGRO_ALIGN_CENTRE, "%s" % FILTER_TEXT[i % 4])

    al_set_clipping_rectangle(x - 64, y - 64, 128, 128)
    al_draw_scaled_rotated_bitmap(bmp, bw / 2, bh / 2,
      x, y, scale, scale, angle, 0)
    al_set_clipping_rectangle(0, 0, w, h)
  end
  al_draw_textf($example.font, $example.info, w / 2, h - 14,
      ALLEGRO_ALIGN_CENTRE, "press space to change")
end

def main
  w = 640
  h = 480
  done = false
  need_redraw = true

  abort_example("Failed to init Allegro.\n") unless al_init

  abort_example("Failed to init IIO addon.\n") unless al_init_image_addon

  al_init_font_addon

  $example.display = al_create_display(w, h)

  abort_example("Error creating display.\n") if $example.display.null?

  abort_example("Error installing keyboard.\n") unless al_install_keyboard

  abort_example("Error installing mouse.\n") unless al_install_mouse

  $example.font = al_load_font("data/fixed_font.tga", 0, 0)
  abort_example("Error loading data/fixed_font.tga\n") if $example.font.null?

  mysha = al_load_bitmap("data/mysha256x256.png")
  abort_example("Error loading data/mysha256x256.png\n") if mysha.null?

  6.times do |i|
    # Only power-of-two bitmaps can have mipmaps.
    al_set_new_bitmap_flags(FILTER_FLAGS[i])
    $example.bitmaps[0][i] = al_create_bitmap(1024, 1024)
    $example.bitmaps[1][i] = al_clone_bitmap(mysha)
    lock = al_lock_bitmap($example.bitmaps[0][i],
      :allegro_pixel_format_abgr_8888_le, ALLEGRO_LOCK_WRITEONLY)
    1024.times do |y|
      row = FFI::Pointer.new(:uchar, lock[:data].address + lock[:pitch] * y)
      chars = 1024.times.flat_map do |x|
        c = 0
        c = 255 if (((x >> 2) & 1) ^ ((y >> 2) & 1)) != 0
        [c, c, c, 255]
      end
      row.write_array_of_uchar(chars)
    end
    al_unlock_bitmap($example.bitmaps[0][i])
  end

  $example.bg = al_map_rgb_f(0, 0, 0)
  $example.fg = al_map_rgb_f(1, 1, 1)
  $example.info = al_map_rgb_f(0.5, 0.5, 1)

  timer = al_create_timer(1.0 / FPS)

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_mouse_event_source)
  al_register_event_source(queue, al_get_timer_event_source(timer))
  al_register_event_source(queue, al_get_display_event_source($example.display))

  al_start_timer(timer)

  event = AllegroEvent.new
  until done do
    if need_redraw && al_is_event_queue_empty(queue)
      redraw
      al_flip_display
      need_redraw = false
    end

    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_KEY_DOWN
      case event[:keyboard][:keycode]
      when ALLEGRO_KEY_ESCAPE
        done = true
      when ALLEGRO_KEY_SPACE
        $example.bitmap = ($example.bitmap + 1) % 2
      end

    when ALLEGRO_EVENT_DISPLAY_CLOSE
      done = true

    when ALLEGRO_EVENT_TIMER
      update
      need_redraw = true

    when ALLEGRO_EVENT_MOUSE_BUTTON_DOWN
      $example.bitmap = ($example.bitmap + 1) % 2
    end
  end

  6.times do |i|
    al_destroy_bitmap($example.bitmaps[0][i])
    al_destroy_bitmap($example.bitmaps[1][i])
  end
end

run_main(method(:main))
