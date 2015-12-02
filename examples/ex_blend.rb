# Ruby port of ex_blend.c from the Allegro examples.

# An example demonstrating different blending modes.

require 'allegro4r'

include Allegro4r::API
include Allegro4r::API::Font
include Allegro4r::API::Image
include Allegro4r::API::Primitives

require_relative "common"

# A structure holding all variables of our example program.
class Example
  attr_accessor :example # Our example bitmap.
  attr_accessor :offscreen # An offscreen buffer, for testing.
  attr_accessor :memory # A memory buffer, for testing.
  attr_accessor :myfont # Our font.
  attr_accessor :queue # Our events queue.
  attr_accessor :image # Which test image to use.
  attr_accessor :mode # How to draw it.
  attr_accessor :buttons_x # Where to draw buttons.

  attr_accessor :max_fps, :last_second, :frames_accum, :fps

  def initialize
    @image = @mode = @frames_accum = 0
    @last_second = @fps = 0.0
  end
end
$ex = Example.new

# Print some text with a shadow.
def print(x, y, vertical, format, *args)
  message = format % args

  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
  h = al_get_font_line_height($ex.myfont)

  2.times do |j|
    if j == 0
      color = al_map_rgb(0, 0, 0)
    else
      color = al_map_rgb(255, 255, 255)
    end

    if vertical
      ui = ALLEGRO_USTR_INFO.new
      us = al_ref_cstr(ui, message)
      letter = ALLEGRO_USTR_INFO.new
      al_ustr_length(us).to_i.times do |i|
        al_draw_ustr($ex.myfont, color, x + 1 - j, y + 1 - j + h * i, 0,
          al_ref_ustr(letter, us, al_ustr_offset(us, i),
          al_ustr_offset(us, i + 1)))
      end
    else
      al_draw_text($ex.myfont, color, x + 1 - j, y + 1 - j, 0, message)
    end
  end
end

# Create an example bitmap.
def create_example_bitmap
  bitmap = al_create_bitmap(100, 100)
  locked = al_lock_bitmap(bitmap, :pixel_format_abgr_8888, ALLEGRO_LOCK_WRITEONLY)
  data = locked[:data]

  100.times do |j|
    100.times do |i|
      x = i - 50
      y = j - 50
      r = Math.sqrt(x * x + y * y)
      rc = 1 - r / 50.0
      rc = 0.0 if rc < 0
      data.put_uint8(i * 4 + 0, i * 255 / 100)
      data.put_uint8(i * 4 + 1, j * 255 / 100)
      data.put_uint8(i * 4 + 2, rc * 255)
      data.put_uint8(i * 4 + 3, rc * 255)
    end
    data = FFI::Pointer.new(:void, data.address + locked[:pitch])
  end
  al_unlock_bitmap(bitmap)

  bitmap
end

# Draw our example scene.
def draw
  test = []
  target = al_get_target_bitmap

  blend_names = %w(ZERO ONE ALPHA INVERSE)
  blend_vnames = %w(ZERO ONE ALPHA INVER)
  blend_modes = [ALLEGRO_ZERO, ALLEGRO_ONE, ALLEGRO_ALPHA,
    ALLEGRO_INVERSE_ALPHA]
  x = 40.0
  y = 40.0

  al_clear_to_color(al_map_rgb_f(0.5, 0.5, 0.5))

  test[0] = al_map_rgba_f(1, 1, 1, 1)
  test[1] = al_map_rgba_f(1, 1, 1, 0.5)
  test[2] = al_map_rgba_f(1, 1, 1, 0.25)
  test[3] = al_map_rgba_f(1, 0, 0, 0.75)
  test[4] = al_map_rgba_f(0, 0, 0, 0)

  print(x, 0, false, "D  E  S  T  I  N  A  T  I  O  N  (%0.2f fps)", $ex.fps)
  print(0, y, true, "S O U R C E")
  4.times do |i|
    print(x + i * 110, 20, false, blend_names[i])
    print(20, y + i * 110, true, blend_vnames[i])
  end

  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  if $ex.mode >= 1 && $ex.mode <= 5
    al_set_target_bitmap($ex.offscreen)
    al_clear_to_color(test[$ex.mode - 1])
  end
  if $ex.mode >= 6 && $ex.mode <= 10
    al_set_target_bitmap($ex.memory)
    al_clear_to_color(test[$ex.mode - 6])
  end

  4.times do |j|
    4.times do |i|
      al_set_blender(ALLEGRO_ADD, blend_modes[j], blend_modes[i])
      if $ex.image == 0
        al_draw_bitmap($ex.example, x + i * 110, y + j * 110, 0)
      elsif $ex.image >= 1 && $ex.image <= 6
        al_draw_filled_rectangle(x + i * 110, y + j * 110,
          x + i * 110 + 100, y + j * 110 + 100,
            test[$ex.image - 1])
      end
    end
  end

  if $ex.mode >= 1 && $ex.mode <= 5
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
    al_set_target_bitmap(target)
    al_draw_bitmap_region($ex.offscreen, x, y, 430, 430, x, y, 0)
  end
  if $ex.mode >= 6 && $ex.mode <= 10
    al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
    al_set_target_bitmap(target)
    al_draw_bitmap_region($ex.memory, x, y, 430, 430, x, y, 0)
  end

  is = ->(n) { $ex.image == n ? "*" : " " }
  print($ex.buttons_x, 20 * 1, false, "What to draw")
  print($ex.buttons_x, 20 * 2, false, "%s Picture", is.(0))
  print($ex.buttons_x, 20 * 3, false, "%s Rec1 (1/1/1/1)", is.(1))
  print($ex.buttons_x, 20 * 4, false, "%s Rec2 (1/1/1/.5)", is.(2))
  print($ex.buttons_x, 20 * 5, false, "%s Rec3 (1/1/1/.25)", is.(3))
  print($ex.buttons_x, 20 * 6, false, "%s Rec4 (1/0/0/.75)", is.(4))
  print($ex.buttons_x, 20 * 7, false, "%s Rec5 (0/0/0/0)", is.(5))

  is = ->(n) { $ex.mode == n ? "*" : " " }
  print($ex.buttons_x, 20 * 9, false, "Where to draw")
  print($ex.buttons_x, 20 * 10, false, "%s screen", is.(0))

  print($ex.buttons_x, 20 * 11, false, "%s offscreen1", is.(1))
  print($ex.buttons_x, 20 * 12, false, "%s offscreen2", is.(2))
  print($ex.buttons_x, 20 * 13, false, "%s offscreen3", is.(3))
  print($ex.buttons_x, 20 * 14, false, "%s offscreen4", is.(4))
  print($ex.buttons_x, 20 * 15, false, "%s offscreen5", is.(5))

  print($ex.buttons_x, 20 * 16, false, "%s memory1", is.(6))
  print($ex.buttons_x, 20 * 17, false, "%s memory2", is.(7))
  print($ex.buttons_x, 20 * 18, false, "%s memory3", is.(8))
  print($ex.buttons_x, 20 * 19, false, "%s memory4", is.(9))
  print($ex.buttons_x, 20 * 20, false, "%s memory5", is.(10))
end

# Called a fixed amount of times per second.
def tick
  # Count frames during the last second or so.
  t = al_get_time
  if t >= $ex.last_second + 1
    $ex.fps = $ex.frames_accum / (t - $ex.last_second)
    $ex.frames_accum = 0
    $ex.last_second = t
  end

  draw
  al_flip_display
  $ex.frames_accum += 1
end

# Run our test.
def run
  event = ALLEGROEVENT.new
  need_draw = true

  loop do
    # Perform frame skipping so we don't fall behind the timer events.
    if need_draw && al_is_event_queue_empty($ex.queue)
      tick
      need_draw = false
    end

    al_wait_for_event($ex.queue, event)

    case event[:type]
    # Was the X button on the window pressed?
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      return

    # Was a key pressed?
    when ALLEGRO_EVENT_KEY_DOWN
      return if event[:keyboard][:keycode] == ALLEGRO_KEY_ESCAPE

    # Is it time for the next timer tick?
    when ALLEGRO_EVENT_TIMER
      need_draw = true

    # Mouse click?
    when ALLEGRO_EVENT_MOUSE_BUTTON_UP
      x = event[:mouse][:x]
      y = event[:mouse][:y]
      if x >= $ex.buttons_x
        button = y / 20
        $ex.image = 0 if button == 2
        $ex.image = 1 if button == 3
        $ex.image = 2 if button == 4
        $ex.image = 3 if button == 5
        $ex.image = 4 if button == 6
        $ex.image = 5 if button == 7

        $ex.mode = 0 if button == 10

        $ex.mode = 1 if button == 11
        $ex.mode = 2 if button == 12
        $ex.mode = 3 if button == 13
        $ex.mode = 4 if button == 14
        $ex.mode = 5 if button == 15

        $ex.mode = 6 if button == 16
        $ex.mode = 7 if button == 17
        $ex.mode = 8 if button == 18
        $ex.mode = 9 if button == 19
        $ex.mode = 10 if button == 20
      end
    end
  end
end

# Initialize the example.
def init
  $ex.buttons_x = 40 + 110 * 4
  $ex.max_fps = 60

  $ex.myfont = al_load_font("data/font.tga", 0, 0)
  abort_example("data/font.tga not found\n") if $ex.myfont.null?
  $ex.example = create_example_bitmap

  $ex.offscreen = al_create_bitmap(640, 480)
  al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP)
  $ex.memory = al_create_bitmap(640, 480)
end

def main
  abort_example("Could not init Allegro.\n") unless al_init

  al_init_primitives_addon
  al_install_keyboard
  al_install_mouse
  al_init_image_addon
  al_init_font_addon

  display = al_create_display(640, 480)
  abort_example("Error creating display\n") if display.null?

  init

  timer = al_create_timer(1.0 / $ex.max_fps)

  $ex.queue = al_create_event_queue
  al_register_event_source($ex.queue, al_get_keyboard_event_source)
  al_register_event_source($ex.queue, al_get_mouse_event_source)
  al_register_event_source($ex.queue, al_get_display_event_source(display))
  al_register_event_source($ex.queue, al_get_timer_event_source(timer))

  al_start_timer(timer)
  run

  al_destroy_event_queue($ex.queue)
end

run_main(method(:main))
