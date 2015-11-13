# Ruby port of ex_draw_bitmap.c from the Allegro examples.

require 'allegro4r'

include Allegro4r::API
include Allegro4r::API::Image
include Allegro4r::API::Font

FPS = 60
MAX_SPRITES = 1024

class Sprite
  attr_accessor :x, :y, :dx, :dy

  def initialize
    @x = @y = @dx = @dy = 0.0
  end
end

TEXT = [
  "Space - toggle use of textures",
  "B - toggle alpha blending",
  "Left/Right - change bitmap size",
  "Up/Down - change bitmap count",
  "F1 - toggle help text"
]

class Example
  attr_accessor :sprites, :use_memory_bitmaps, :blending, :display,
                :mysha, :bitmap, :bitmap_size, :sprite_count, :show_help,
                :font,

                :mouse_down, :last_x, :last_y,

                :white, :half_white, :dark, :red,

                :direct_speed_measure, :ftpos, :frame_times

  def initialize
    @sprites = MAX_SPRITES.times.map { Sprite.new }
    @blending = @bitmap_size = @sprite_count = @ftpos = 0
    @direct_speed_measure = 0.0
    @frame_times = [0.0] * FPS
  end
end

def example
  @example ||= Example.new
end

def add_time
  example.frame_times[example.ftpos] = al_get_time
  example.ftpos += 1
  example.ftpos = 0 if example.ftpos >= FPS
end

def get_fps
  prev   = FPS - 1
  min_dt = 1.0
  max_dt = 1 / 1000000.0
  av     = 0.0
  FPS.times do |i|
    if i != example.ftpos
      dt = example.frame_times[i] - example.frame_times[prev]
      min_dt = dt if dt < min_dt
      max_dt = dt if dt > max_dt
      av += dt
    end
    prev = i
  end
  av /= (FPS - 1)
  av = 1 / av
  average = av.finite? ? av.ceil : -1
  d = 1 / min_dt - 1 / max_dt
  minmax = d.finite? ? (d / 2).floor : -1
  return average, minmax
end

def add_sprite
  if example.sprite_count < MAX_SPRITES
    w = al_get_display_width(example.display)
    h = al_get_display_height(example.display)
    i = example.sprite_count
    example.sprite_count += 1
    s = example.sprites[i]
    a = rand(360).to_f
    s.x = rand(w - example.bitmap_size).to_f
    s.y = rand(h - example.bitmap_size).to_f
    s.dx = Math.cos(a) * FPS * 2
    s.dy = Math.sin(a) * FPS * 2
  end
end

def add_sprites(n)
  n.times { add_sprite }
end

def remove_sprites(n)
  example.sprite_count -= n
  example.sprite_count = 0 if example.sprite_count < 0
end

def change_size(size)
  size = 1 if size < 1
  size = 1024 if size > 1024

  al_destroy_bitmap(example.bitmap) if example.bitmap
  al_set_new_bitmap_flags(
    example.use_memory_bitmaps ? ALLEGRO_MEMORY_BITMAP : ALLEGRO_VIDEO_BITMAP)
  example.bitmap = al_create_bitmap(size, size)
  example.bitmap_size = size
  al_set_target_bitmap(example.bitmap)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  al_clear_to_color(al_map_rgba_f(0, 0, 0, 0))
  bw = al_get_bitmap_width(example.mysha)
  bh = al_get_bitmap_height(example.mysha)
  al_draw_scaled_bitmap(example.mysha, 0, 0, bw, bh, 0, 0,
    size, size, 0)
  al_set_target_backbuffer(example.display)
end

def sprite_update(s)
  w = al_get_display_width(example.display)
  h = al_get_display_height(example.display)

  s.x += s.dx / FPS
  s.y += s.dy / FPS

  if s.x < 0
    s.x = -s.x
    s.dx = -s.dx
  end
  if s.x + example.bitmap_size > w
    s.x = -s.x + 2 * (w - example.bitmap_size)
    s.dx = -s.dx
  end
  if s.y < 0
    s.y = -s.y
    s.dy = -s.dy
  end
  if s.y + example.bitmap_size > h
    s.y = -s.y + 2 * (h - example.bitmap_size)
    s.dy = -s.dy
  end

  s.x = w / 2 - example.bitmap_size / 2 if example.bitmap_size > w
  s.y = h / 2 - example.bitmap_size / 2 if example.bitmap_size > h
end

def update
  example.sprite_count.times do |i|
    sprite_update(example.sprites[i])
  end
end

def redraw
  w = al_get_display_width(example.display)
  h = al_get_display_height(example.display)
  fh = al_get_font_line_height(example.font)
  info = ["textures", "memory buffers"]
  binfo = ["alpha", "additive", "tinted", "solid"]
  tint = example.white

  case example.blending
  when 0
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
    tint = example.half_white
  when 1
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE)
    tint = example.dark
  when 2
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
    tint = example.red
  when 3
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  end

  example.sprite_count.times do |i|
    s = example.sprites[i]
    al_draw_tinted_bitmap(example.bitmap, tint, s.x, s.y, 0)
  end

  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
  if example.show_help
    TEXT.each_with_index do |text, i|
      al_draw_text(example.font, example.white, 0, h - 5 * fh + i * fh, 0, text)
    end
  end

  al_draw_textf(example.font, example.white, 0, 0, 0,
    "count: #{example.sprite_count}")
  al_draw_textf(example.font, example.white, 0, fh, 0,
    "size: #{example.bitmap_size}")
  al_draw_textf(example.font, example.white, 0, fh * 2, 0,
    info[example.use_memory_bitmaps ? 1 : 0])
  al_draw_textf(example.font, example.white, 0, fh * 3, 0,
    binfo[example.blending])

  f1, f2 = get_fps
  al_draw_textf(example.font, example.white, w, 0, ALLEGRO_ALIGN_RIGHT, "FPS: %4d +- %-4d" %
    [f1, f2])
  dsm = 1.0 / example.direct_speed_measure
  al_draw_textf(example.font, example.white, w, fh, ALLEGRO_ALIGN_RIGHT, "%4d / sec" %
    (dsm.finite? ? dsm.to_i : -1))
end

def main
  info = ALLEGROMONITORINFO.new
  w, h = 640, 480
  done = false
  need_redraw = true
  example.show_help = true

  raise "Failed to init Allegro." unless al_init

  raise "Failed to init IIO addon." unless al_init_image_addon

  al_init_font_addon

  al_get_num_video_adapters

  al_get_monitor_info(0, info)
  w = info[:x2] - info[:x1] if info[:x2] - info[:x1] < w
  h = info[:y2] - info[:y1] if info[:y2] - info[:y1] < h
  example.display = al_create_display(w, h)
  raise "Error creating display." if example.display.null?

  raise "Error installing keyboard." unless al_install_keyboard

  raise "Error installing mouse." unless al_install_mouse

  example.font = al_load_font("data/fixed_font.tga", 0, 0)
  raise "Error loading data/fixed_font.tga" if example.font.null?

  example.mysha = al_load_bitmap("data/mysha256x256.png")
  raise "Error loading data/mysha256x256.png" if example.mysha.null?

  example.white = al_map_rgb_f(1, 1, 1)
  example.half_white = al_map_rgba_f(1, 1, 1, 0.5)
  example.dark = al_map_rgb(15, 15, 15)
  example.red = al_map_rgb_f(1, 0.2, 0.1)
  change_size(256)
  add_sprite
  add_sprite

  timer = al_create_timer(1.0 / FPS)

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_mouse_event_source)
  al_register_event_source(queue, al_get_timer_event_source(timer))
  al_register_event_source(queue, al_get_display_event_source(example.display))

  al_start_timer(timer)

  event = ALLEGROEVENT.new
  while (!done) do
    if need_redraw && al_is_event_queue_empty(queue)
      t = -al_get_time
      add_time
      al_clear_to_color(al_map_rgb_f(0, 0, 0))
      redraw
      t += al_get_time
      example.direct_speed_measure = t
      al_flip_display
      need_redraw = false
    end

    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_KEY_CHAR # includes repeats
      case event[:keyboard][:keycode]
      when ALLEGRO_KEY_ESCAPE
        done = true
      when ALLEGRO_KEY_UP
        add_sprites(1)
      when ALLEGRO_KEY_DOWN
        remove_sprites(1)
      when ALLEGRO_KEY_LEFT
        change_size(example.bitmap_size - 1)
      when ALLEGRO_KEY_RIGHT
        change_size(example.bitmap_size + 1)
      when ALLEGRO_KEY_F1
        example.show_help ^= true
      when ALLEGRO_KEY_SPACE
        example.use_memory_bitmaps ^= true
        change_size(example.bitmap_size)
      when ALLEGRO_KEY_B
        example.blending += 1
        example.blending = 0 if example.blending == 4
      end

    when ALLEGRO_EVENT_DISPLAY_CLOSE
      done = true

    when ALLEGRO_EVENT_TIMER
      update
      need_redraw = true

    when ALLEGRO_EVENT_MOUSE_BUTTON_DOWN
      example.mouse_down = true
      example.last_x = event[:mouse][:x]
      example.last_y = event[:mouse][:y]

    when ALLEGRO_EVENT_MOUSE_BUTTON_UP
      fh = al_get_font_line_height(example.font)
      example.mouse_down = false
      if event[:mouse][:x] < 40 && event[:mouse][:y] >= h - fh * 5
        button = (event[:mouse][:y] - (h - fh * 5)) / fh
        case button
        when 0
          example.use_memory_bitmaps ^= true
          change_size(example.bitmap_size)
        when 1
          example.blending += 1
          example.blending = 0 if example.blending == 4
        when 4
          example.show_help ^= true
        end
      end

    when ALLEGRO_EVENT_MOUSE_AXES
      raise "something"
      if example.mouse_down
        dx = event[:mouse][:x] - example.last_x
        dy = event[:mouse][:y] - example.last_y
        add_sprites(dy / 4) if dy > 4
        remove_sprites(-dy / 4) if dy < -4
        change_size(example.bitmap_size + dx - 4) if dx > 4
        change_size(example.bitmap_size + dx + 4) if dx < -4

        example.last_x = event[:mouse][:x]
        example.last_y = event[:mouse][:y]
      end

    end
  end

  al_destroy_bitmap(example.bitmap)
end

run_main(method(:main))
