# Ruby port of ex_bitmap_flip.c from the Allegro examples.

# An example showing bitmap flipping flags, by Steven Wallace.

require 'allegro4r'

include Allegro4r::API
include Allegro4r::API::Image
include Allegro4r::API::Font

require_relative 'common'

INTERVAL = 0.01


class << self
  attr_accessor :bmp_x, :bmp_y, :bmp_dx, :bmp_dy, :bmp_flag
end
@bmp_x = 200.0
@bmp_y = 200.0
@bmp_dx = 96.0
@bmp_dy = 96.0
@bmp_flag = 0

def update(bmp)
  target = al_get_target_bitmap
  display_w = al_get_bitmap_width(target)
  display_h = al_get_bitmap_height(target)
  bitmap_w = al_get_bitmap_width(bmp)
  bitmap_h = al_get_bitmap_height(bmp)

  self.bmp_x += bmp_dx * INTERVAL
  self.bmp_y += bmp_dy * INTERVAL

  # Make sure bitmap is still on the screen.
  if bmp_y < 0
    self.bmp_y = 0
    self.bmp_dy *= -1
    self.bmp_flag &= ~ALLEGRO_FLIP_VERTICAL
  end

  if bmp_x < 0
    self.bmp_x = 0
    self.bmp_dx *= -1
    self.bmp_flag &= ~ALLEGRO_FLIP_HORIZONTAL
  end

  if bmp_y > display_h - bitmap_h
    self.bmp_y = display_h - bitmap_h
    self.bmp_dy *= -1
    self.bmp_flag |= ALLEGRO_FLIP_VERTICAL
  end

  if bmp_x > display_w - bitmap_w
    self.bmp_x = display_w - bitmap_w
    self.bmp_dx *= -1
    self.bmp_flag |= ALLEGRO_FLIP_HORIZONTAL
  end
end


def main
  done = false
  redraw = true

  abort_example("Failed to init Allegro.\n") unless al_init

  abort_example("Failed to init IIO addon.\n") unless al_init_image_addon

  al_init_font_addon

  display = al_create_display(640, 480)
  abort_example("Error creating display.\n") if display.null?

  abort_example("Error installing keyboard.\n") unless al_install_keyboard

  font = al_load_font("data/fixed_font.tga", 0, 0)
  abort_example("Error loading data/fixed_font.tga\n") if font.null?

  bmp = disp_bmp = al_load_bitmap("data/mysha.pcx")
  abort_example("Error loading data/mysha.pcx\n") if bmp.null?
  text = "Display bitmap (space to change)"

  al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP)
  mem_bmp = al_load_bitmap("data/mysha.pcx")
  abort_example("Error loading data/mysha.pcx\n") if mem_bmp.null?


  timer = al_create_timer(INTERVAL)

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_timer_event_source(timer))
  al_register_event_source(queue, al_get_display_event_source(display))

  al_start_timer(timer)

  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)

  event = ALLEGROEVENT.new
  until done
    if redraw && al_is_event_queue_empty(queue)
      update(bmp)
      al_clear_to_color(al_map_rgb_f(0, 0, 0))
      al_draw_tinted_bitmap(bmp, al_map_rgba_f(1, 1, 1, 0.5),
        bmp_x, bmp_y, bmp_flag)
      al_draw_text(font, al_map_rgba_f(1, 1, 1, 0.5), 0, 0, 0, text)
      al_flip_display
      redraw = false
    end

    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_KEY_DOWN
      if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE
        done = true
      elsif event[:keyboard][:keycode] == ALLEGRO_KEY_SPACE
        if bmp == mem_bmp
          bmp = disp_bmp
          text = "Display bitmap (space to change)"
        else
          bmp = mem_bmp
          text = "Memory bitmap (space to change)"
        end
      end

    when ALLEGRO_EVENT_DISPLAY_CLOSE
      done = true

    when ALLEGRO_EVENT_TIMER
      redraw = true
    end
  end

  al_destroy_bitmap(bmp)
end

run_main(method(:main))
