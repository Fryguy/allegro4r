# Ruby port of ex_draw_pixels.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

WIDTH = 640
HEIGHT = 480
NUM_STARS = 300
TARGET_FPS = 9999


class Point
  attr_accessor :x, :y
end


def main
  key_state = AllegroKeyboardState.new
  stars = Array.new(3) { Array.new(NUM_STARS / 3) { Point.new } }
  speeds = [0.0001, 0.05, 0.15]
  colors = []
  total_frames = 0

  abort_example("Could not init Allegro.\n") unless al_init

  open_log

  al_install_keyboard

  display = al_create_display(WIDTH, HEIGHT)
  abort_example("Could not create display.\n") if display.null?

  colors[0] = al_map_rgba(255, 100, 255, 128)
  colors[1] = al_map_rgba(255, 100, 100, 255)
  colors[2] = al_map_rgba(100, 100, 255, 255)

  3.times do |layer|
    (NUM_STARS / 3).times do |star|
      p = stars[layer][star]
      p.x = rand(WIDTH)
      p.y = rand(HEIGHT)
    end
  end


  start = (al_get_time * 1000).to_i
  now = start
  elapsed = 0
  frame_count = 0
  program_start = al_get_time


  loop do
    if frame_count < (1000 / TARGET_FPS)
      frame_count += elapsed
    else
      frame_count -= (1000 / TARGET_FPS)
      al_clear_to_color(al_map_rgb(0, 0, 0))
      (NUM_STARS / 3).times do |star|
        p = stars[0][star]
        al_draw_pixel(p.x, p.y, colors[0])
      end
      al_lock_bitmap(al_get_backbuffer(display), :allegro_pixel_format_any, 0)

      3.times do |layer|
        (NUM_STARS / 3).times do |star|
          p = stars[layer][star]
          # put_pixel ignores blending
          al_put_pixel(p.x, p.y, colors[layer])
        end
      end

      # Check that dots appear at the window extremes.
      x = WIDTH - 1
      y = HEIGHT - 1
      al_put_pixel(0, 0, al_map_rgb_f(1, 1, 1))
      al_put_pixel(x, 0, al_map_rgb_f(1, 1, 1))
      al_put_pixel(0, y, al_map_rgb_f(1, 1, 1))
      al_put_pixel(x, y, al_map_rgb_f(1, 1, 1))

      al_unlock_bitmap(al_get_backbuffer(display))
      al_flip_display
      total_frames += 1
    end

    now = (al_get_time * 1000).to_i
    elapsed = now - start
    start = now

    3.times do |layer|
      (NUM_STARS / 3).times do |star|
        p = stars[layer][star]
        p.y -= speeds[layer] * elapsed
        if p.y < 0
          p.x = rand(WIDTH)
          p.y = HEIGHT
        end
      end
    end

    al_rest(0.001)

    al_get_keyboard_state(key_state)
    break if al_key_down(key_state, ALLEGRO_KEY_ESCAPE)
  end

  length = al_get_time - program_start

  if length != 0
    log_printf("%d FPS\n", (total_frames / length).to_i)
  end

  al_destroy_display(display)

  close_log(true)
end

run_main(method(:main))
