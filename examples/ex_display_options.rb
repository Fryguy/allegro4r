# Ruby port of ex_display_options.c from the Allegro examples.

# Test retrieving and settings possible modes.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

$font = nil
$white = nil
$font_h = 0
$modes_count = 0
$options_count = 0
$status = ""
$flags = 0
$old_flags = 0

$visible_rows = 0
$first_visible_row = 0

$selected_column = 0
$selected_mode = 0
$selected_option = 0

Options = Struct.new(:name, :option, :value, :max_value, :required)
$options = [
  ["COLOR_SIZE", 32],
  ["RED_SIZE", 8],
  ["GREEN_SIZE", 8],
  ["BLUE_SIZE", 8],
  ["ALPHA_SIZE", 8],
  ["RED_SHIFT", 32],
  ["GREEN_SHIFT", 32],
  ["BLUE_SHIFT", 32],
  ["ALPHA_SHIFT", 32],
  ["DEPTH_SIZE", 32],
  ["FLOAT_COLOR", 1],
  ["FLOAT_DEPTH", 1],
  ["STENCIL_SIZE", 32],
  ["SAMPLE_BUFFERS", 1],
  ["SAMPLES", 8],
  ["RENDER_METHOD", 2],
  ["SINGLE_BUFFER", 1],
  ["SWAP_METHOD", 1],
  ["VSYNC", 2],
  ["COMPATIBLE_DISPLAY", 1],
  ["MAX_BITMAP_SIZE", 65536],
  ["SUPPORT_NPOT_BITMAP", 1],
  ["CAN_DRAW_INTO_BITMAP", 1],
  ["SUPPORT_SEPARATE_ALPHA", 1]
].map { |x, m| Options.new(x, Allegro4r::API.enum_value(:"allegro_#{x.downcase}"), 0, m, 0) }

$flag_names = Array.new(32) { String.new }
def init_flags
  x = ->(i, f) { $flag_names[i] = f if 1 << i == Allegro4r::API.const_get("ALLEGRO_#{f}") }
  32.times do |i|
    x.call(i, "WINDOWED")
    x.call(i, "FULLSCREEN")
    x.call(i, "OPENGL")
    x.call(i, "RESIZABLE")
    x.call(i, "FRAMELESS")
    x.call(i, "GENERATE_EXPOSE_EVENTS")
    x.call(i, "FULLSCREEN_WINDOW")
    x.call(i, "MINIMIZED")
  end
end

def load_font
  $font = al_load_font("data/fixed_font.tga", 0, 0)
  abort_example("data/fixed_font.tga not found\n") if $font.null?
  $font_h = al_get_font_line_height($font)
end

def display_options(display)
  i = y = 10
  x = 10
  n = $options_count
  dw = al_get_display_width(display)
  dh = al_get_display_height(display)

  $modes_count = al_get_num_display_modes

  c = al_map_rgb_f(0.8, 0.8, 1)
  al_draw_textf($font, c, x, y, 0, "Create new display")
  y += $font_h
  i = $first_visible_row
  while i < $modes_count + 2 && i < $first_visible_row + $visible_rows
    mode = AllegroDisplayMode.new
    if i > 1
      al_get_display_mode(i - 2, mode)
    elsif i == 1
      mode[:width] = 800
      mode[:height] = 600
      mode[:format] = 0
      mode[:refresh_rate] = 0
    else
      mode[:width] = 800
      mode[:height] = 600
      mode[:format] = 0
      mode[:refresh_rate] = 0
    end
    if $selected_column == 0 && $selected_mode == i
      c = al_map_rgb_f(1, 1, 0)
      al_set_blender(:allegro_add, :allegro_one, :allegro_zero)
      al_draw_filled_rectangle(x, y, x + 300, y + $font_h, c)
    end
    c = al_map_rgb_f(0, 0, 0)
    al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)
    if (i == $first_visible_row && i > 0) ||
        (i == $first_visible_row + $visible_rows - 1 &&
        i < $modes_count + 1)
      al_draw_textf($font, c, x, y, 0, "...")
    else
      al_draw_textf($font, c, x, y, 0, "%s %d x %d (fmt: %x, %d Hz)" % [
        i > 1 ? "Fullscreen" : i == 0 ? "Windowed" : "FS Window",
        mode[:width], mode[:height], mode[:format], mode[:refresh_rate]])
    end
    y += $font_h

    i += 1
  end

  x = dw / 2 + 10
  y = 10
  c = al_map_rgb_f(0.8, 0.8, 1)
  al_draw_textf($font, c, x, y, 0, "Options for new display")
  al_draw_textf($font, c, dw - 10, y, ALLEGRO_ALIGN_RIGHT, "(current display)")
  y += $font_h
  n.times do |i|
    if $selected_column == 1 && $selected_option == i
      c = al_map_rgb_f(1, 1, 0)
      al_draw_filled_rectangle(x, y, x + 300, y + $font_h, c)
    end

    case $options[i].required
    when ALLEGRO_REQUIRE then c = al_map_rgb_f(0.5, 0, 0)
    when ALLEGRO_SUGGEST then c = al_map_rgb_f(0, 0, 0)
    when ALLEGRO_DONTCARE then c = al_map_rgb_f(0.5, 0.5, 0.5)
    end
    al_draw_textf($font, c, x, y, 0, "%s: %d (%s)" % [$options[i].name,
      $options[i].value,
        $options[i].required == ALLEGRO_REQUIRE ? "required" :
        $options[i].required == ALLEGRO_SUGGEST ? "suggested" :
        "ignored"])

    c = al_map_rgb_f(0.9, 0.5, 0.3)
    al_draw_textf($font, c, dw - 10, y, ALLEGRO_ALIGN_RIGHT, "%d" %
      al_get_display_option(display, $options[i].option))
    y += $font_h
  end

  c = al_map_rgb_f(0, 0, 0.8)
  x = 10
  y = dh - $font_h - 10
  y -= $font_h
  al_draw_textf($font, c, x, y, 0, "PageUp/Down: modify values")
  y -= $font_h
  al_draw_textf($font, c, x, y, 0, "Return: set mode or require option")
  y -= $font_h
  al_draw_textf($font, c, x, y, 0, "Cursor keys: change selection")

  y -= $font_h * 2
  32.times do |i|
    if $flag_names[i]
      if $flags & (1 << i) != 0
        c = al_map_rgb_f(0.5, 0, 0)
      elsif $old_flags & (1 << i) != 0
        c = al_map_rgb_f(0.5, 0.4, 0.4)
      else
        next
      end
      al_draw_text($font, c, x, y, 0, $flag_names[i])
      x += al_get_text_width($font, $flag_names[i]) + 10
    end
  end

  c = al_map_rgb_f(1, 0, 0)
  al_draw_text($font, c, dw / 2, dh - $font_h, ALLEGRO_ALIGN_CENTRE, $status)
end

def update_ui
  h = al_get_display_height(al_get_current_display)
  $visible_rows = h / $font_h - 10
end

def main
  redraw = false

  abort_example("Could not init Allegro.\n") unless al_init
  init_flags
  al_init_primitives_addon

  $white = al_map_rgba_f(1, 1, 1, 1)

  al_install_keyboard
  al_install_mouse
  al_init_image_addon
  al_init_font_addon

  display = al_create_display(800, 600)
  abort_example("Could not create display.\n") if display.null?

  load_font

  timer = al_create_timer(1.0 / 60)

  $modes_count = al_get_num_display_modes
  $options_count = $options.length

  update_ui

  al_clear_to_color(al_map_rgb_f(1, 1, 1))
  display_options(display)
  al_flip_display

  queue = al_create_event_queue
  al_register_event_source(queue, al_get_keyboard_event_source)
  al_register_event_source(queue, al_get_mouse_event_source)
  al_register_event_source(queue, al_get_display_event_source(display))
  al_register_event_source(queue, al_get_timer_event_source(timer))

  al_start_timer(timer)

  event = AllegroEvent.new
  loop do
    al_wait_for_event(queue, event)
    case event[:type]
    when ALLEGRO_EVENT_DISPLAY_CLOSE
      break
    when ALLEGRO_EVENT_MOUSE_BUTTON_DOWN
      if event[:mouse][:button] == 1
        dw = al_get_display_width(display)
        y = 10
        row = (event[:mouse][:y] - y) / $font_h - 1
        column = event[:mouse][:x] / (dw / 2)
        if column == 0
          if row >= 0 && row <= $modes_count
            $selected_column = column
            $selected_mode = row
            redraw = true
          end
        end
        if column == 1
          if row >= 0 && row < $options_count
            $selected_column = column
            $selected_option = row
            redraw = true
          end
        end
      end
    when ALLEGRO_EVENT_TIMER
      f = al_get_display_flags(display)
      if f != $flags
        redraw = true
        $flags = f
        $old_flags |= f
      end
    when ALLEGRO_EVENT_KEY_CHAR
      case event[:keyboard][:keycode]
      when ALLEGRO_KEY_ESCAPE
        break
      when ALLEGRO_KEY_LEFT
        $selected_column = 0
        redraw = true
      when ALLEGRO_KEY_RIGHT
        $selected_column = 1
        redraw = true
      when ALLEGRO_KEY_UP
        $selected_mode -= 1 if $selected_column == 0
        $selected_option -= 1 if $selected_column == 1
        redraw = true
      when ALLEGRO_KEY_DOWN
        $selected_mode += 1 if $selected_column == 0
        $selected_option += 1 if $selected_column == 1
        redraw = true
      when ALLEGRO_KEY_ENTER
        if $selected_column == 0
          mode = AllegroDisplayMode.new
          if $selected_mode > 1
            al_get_display_mode($selected_mode - 2, mode)
            al_set_new_display_flags(ALLEGRO_FULLSCREEN)
          elsif $selected_mode == 1
            mode[:width] = 800
            mode[:height] = 600
            al_set_new_display_flags(ALLEGRO_FULLSCREEN_WINDOW)
          else
            mode[:width] = 800
            mode[:height] = 600
            al_set_new_display_flags(ALLEGRO_WINDOWED)
          end

          al_destroy_font($font)
          $font = nil

          new_display = al_create_display(
            mode[:width], mode[:height])
          if !new_display.null?
            al_destroy_display(display)
            display = new_display
            al_set_target_backbuffer(display)
            al_register_event_source(queue,
              al_get_display_event_source(display))
            update_ui
            $status = "Display creation succeeded."
          else
            $status = "Display creation failed."
          end

          load_font
        end
        if $selected_column == 1
          $options[$selected_option].required += 1
          $options[$selected_option].required %= 3
          al_set_new_display_option(
            $options[$selected_option].option,
            $options[$selected_option].value,
            $options[$selected_option].required)
        end
        redraw = true
      end
      change = 0
      change = 1 if event[:keyboard][:keycode] == ALLEGRO_KEY_PGUP
      change = -1 if event[:keyboard][:keycode] == ALLEGRO_KEY_PGDN
      if change != 0 && $selected_column == 1
        $options[$selected_option].value += $change
        if $options[$selected_option].value < 0
          $options[$selected_option].value = 0
        end
        if $options[$selected_option].value >
          $options[$selected_option].max_value
          $options[$selected_option].value =
            $options[$selected_option].max_value
        end
        al_set_new_display_option($options[$selected_option].option,
          $options[$selected_option].value,
          $options[$selected_option].required)
        redraw = true
      end
    end

    if $selected_mode < 0
      $selected_mode = 0
    end
    if $selected_mode > $modes_count + 1
      $selected_mode = $modes_count + 1
    end
    if $selected_option < 0
      $selected_option = 0
    end
    if $selected_option >= $options_count
      $selected_option = $options_count - 1
    end
    if $selected_mode < $first_visible_row
      $first_visible_row = $selected_mode
    end
    if $selected_mode > $first_visible_row + $visible_rows - 1
      $first_visible_row = $selected_mode - $visible_rows + 1
    end

    if redraw && al_is_event_queue_empty(queue)
      redraw = false
      al_clear_to_color(al_map_rgb_f(1, 1, 1))
      display_options(display)
      al_flip_display
    end
  end

  al_destroy_font($font)
end

run_main(method(:main))
