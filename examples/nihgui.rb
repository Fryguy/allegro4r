# Ruby port of nihgui.cpp/hpp from the Allegro examples.

# This is a GUI for example programs that require GUI-style interaction.
# It's intended to be as simple and transparent as possible (simplistic,
# even).

require 'allegro4r'
include Allegro4r::API

def clamp(x, y, z)
  [x, [y, z].min].max
end

class SaveState
  def initialize(save = :allegro_state_all)
    state = AllegroState.new
    al_store_state(state, save)
    yield
  ensure
    al_restore_state(state)
  end
end

class UString
  private

  attr_accessor :info, :ustr

  public

  def initialize(s, first, last = -1)
    self.info = AllegroUstrInfo.new
    last = al_ustr_size(s) if last == -1
    self.ustr = al_ref_ustr(info, s, first, last)
  end

  # Conversion
  alias_method :get_ustrm, :ustr
end

class Theme
  attr_accessor :bg, :fg, :highlight, :font

  # Null font is fine if you don't use a widget that requires text.
  def initialize(font = nil)
    @bg = al_map_rgb(255, 255, 255)
    @fg = al_map_rgb(0, 0, 0)
    @highlight = al_map_rgb(128, 128, 255)
    @font = font
  end
end

class Widget
  attr_accessor :grid_x, :grid_y, :grid_w, :grid_h

  attr_accessor :dialog, :x1, :y1, :x2, :y2

  def initialize
    self.grid_x = self.grid_y = self.grid_w = self.grid_h = 0
    self.x1 = self.x2 = self.y1 = self.y2 = 0
  end

  def configure(xsize, ysize, x_padding, y_padding)
    self.x1 = xsize * grid_x + x_padding
    self.y1 = ysize * grid_y + y_padding
    self.x2 = xsize * (grid_x + grid_w) - x_padding - 1
    self.y2 = ysize * (grid_y + grid_h) - y_padding - 1
  end

  def contains(x, y)
    x >= x1 && y >= y1 && x <= x2 && y <= y2
  end

  def width
    x2 - x1 + 1
  end

  def height
    y2 - y1 + 1
  end

  def want_mouse_focus
    true
  end

  def got_mouse_focus
  end

  def lost_mouse_focus
  end

  def on_mouse_button_down(_mx, _my)
  end

  def on_mouse_button_hold(_mx, _my)
  end

  def on_mouse_button_up(_mx, _my)
  end

  def on_click(_mx, _my)
  end

  def want_key_focus
    false
  end

  def got_key_focus
  end

  def lost_key_focus
  end

  def on_key_down(_event)
  end
end

class EventHandler
end

class Dialog
  private

  attr_accessor :theme, :display, :event_queue,
                :grid_m, :grid_n, :x_padding, :y_padding

  attr_accessor :draw_requested, :quit_requested, :all_widgets,
                :mouse_over_widget, :mouse_down_widget, :key_widget

  attr_accessor :event_handler

  public

  def initialize(theme, display, grid_m, grid_n)
    self.theme = theme
    self.display = display
    self.grid_m = grid_m
    self.grid_n = grid_n
    self.x_padding = 1
    self.y_padding = 1

    self.draw_requested = true
    self.quit_requested = false
    self.all_widgets = []

    self.event_queue = al_create_event_queue
    al_register_event_source(event_queue, al_get_keyboard_event_source)
    al_register_event_source(event_queue, al_get_mouse_event_source)
    al_register_event_source(event_queue, al_get_display_event_source(display))

    ObjectSpace.define_finalizer(self, self.class.finalize(event_queue))
  end

  def self.finalize(event_queue)
    proc { al_destroy_event_queue(event_queue) }
  end

  def set_padding(x_padding, y_padding)
    self.x_padding = x_padding
    self.y_padding = y_padding
  end

  def add(widget, grid_x, grid_y, grid_w, grid_h)
    widget.grid_x = grid_x
    widget.grid_y = grid_y
    widget.grid_w = grid_w
    widget.grid_h = grid_h

    all_widgets << widget
    widget.dialog = self
  end

  def prepare
    configure_all

    # XXX this isn't working right in X.  The mouse position is reported as
    # (0,0) initially, until the mouse pointer is moved.
    mst = AllegroMouseState.new
    al_get_mouse_state(mst)
    check_mouse_over(mst[:x], mst[:y])
  end

  private def configure_all
    xsize = al_get_display_width(display) / grid_m
    ysize = al_get_display_height(display) / grid_n

    all_widgets.each do |it|
      it.configure(xsize, ysize, x_padding, y_padding)
    end
  end

  def run_step(block)
    event = AllegroEvent.new

    al_wait_for_event(event_queue, nil) if block

    while al_get_next_event(event_queue, event)
      case event[:type]
      when ALLEGRO_EVENT_DISPLAY_CLOSE
        request_quit

      when ALLEGRO_EVENT_KEY_CHAR
        on_key_down(event[:keyboard])

      when ALLEGRO_EVENT_MOUSE_AXES
        on_mouse_axes(event[:mouse])

      when ALLEGRO_EVENT_MOUSE_BUTTON_DOWN
        on_mouse_button_down(event[:mouse])

      when ALLEGRO_EVENT_MOUSE_BUTTON_UP
        on_mouse_button_up(event[:mouse])

      when ALLEGRO_EVENT_DISPLAY_EXPOSE
        request_draw

      else
        event_handler.handle_event(event) if event_handler
      end
    end
  end

  private def on_key_down(event)
    return if event[:display] != display

    # XXX think of something better when we need it
    request_quit if event[:keycode] == ALLEGRO_KEY_ESCAPE

    key_widget.on_key_down(event) if key_widget
  end

  private def on_mouse_axes(event)
    mx = event[:x]
    my = event[:y]

    return if event[:display] != display

    if mouse_down_widget
      mouse_down_widget.on_mouse_button_hold(mx, my)
      return
    end

    if mouse_over_widget && mouse_over_widget.contains(mx, my)
      # no change
      return
    end

    check_mouse_over(mx, my)
  end

  private def check_mouse_over(mx, my)
    all_widgets.each do |it|
      if it.contains(mx, my) && it.want_mouse_focus
        self.mouse_over_widget = it
        mouse_over_widget.got_mouse_focus
        return
      end
    end

    if mouse_over_widget
      mouse_over_widget.lost_mouse_focus
      self.mouse_over_widget = nil
    end
  end

  private def on_mouse_button_down(event)
    return if event[:button] != 1
    return unless mouse_over_widget

    self.mouse_down_widget = mouse_over_widget
    mouse_down_widget.on_mouse_button_down(event[:x], event[:y])

    # transfer key focus
    if mouse_down_widget != key_widget
      if key_widget
        key_widget.lost_key_focus
        self.key_widget = nil
      end
      if mouse_down_widget.want_key_focus
        self.key_widget = mouse_down_widget
        key_widget.got_key_focus
      end
    end
  end

  private def on_mouse_button_up(event)
    return if event[:button] != 1
    return unless mouse_down_widget

    mouse_down_widget.on_mouse_button_up(event[:x], event[:y])
    if mouse_down_widget.contains(event[:x], event[:y])
      mouse_down_widget.on_click(event[:x], event[:y])
    end
    self.mouse_down_widget = nil
  end

  def request_quit
    self.quit_requested = true
  end

  alias_method :quit_requested?, :quit_requested
  public :quit_requested?

  def request_draw
    self.draw_requested = true
  end

  alias_method :draw_requested?, :draw_requested
  public :draw_requested?

  def draw
    cx, cy, cw, ch = al_get_clipping_rectangle

    all_widgets.each do |wid|
      al_set_clipping_rectangle(wid.x1, wid.y1, wid.width, wid.height)
      wid.draw
    end

    al_set_clipping_rectangle(cx, cy, cw, ch)

    self.draw_requested = false
  end

  alias_method :get_theme, :theme
  public :get_theme

  def register_event_source(source)
    al_register_event_source(event_queue, source)
  end

  def set_event_handler(event_handler)
    self.event_handler = event_handler
  end
end

class Label < Widget
  private

  attr_accessor :text, :centred

  public

  def initialize(text = "", centred = true)
    self.text = text
    self.centred = centred
  end

  def draw
    theme = dialog.get_theme

    SaveState.new do
      al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)
      if centred
        al_draw_text(theme.font, theme.fg, (x1 + x2 + 1) / 2,
          y1, ALLEGRO_ALIGN_CENTRE, text)
      else
        al_draw_text(theme.font, theme.fg, x1, y1, 0, text)
      end
    end
  end

  alias_method :set_text, :text=

  def want_mouse_focus
    false
  end
end

class Button < Widget
  protected

  attr_accessor :text, :pushed

  public

  def initialize(text)
    self.text = text
    self.pushed = false
  end

  def on_mouse_button_down(mx, my)
    self.pushed = true
    dialog.request_draw
  end

  def on_mouse_button_up(mx, my)
    self.pushed = false
    dialog.request_draw
  end

  def draw
    theme = dialog.get_theme

    SaveState.new do
      if pushed
        fg = theme.bg
        bg = theme.fg
      else
        fg = theme.fg
        bg = theme.bg
      end

      al_draw_filled_rectangle(x1, y1,
        x2, y2, bg)
      al_draw_rectangle(x1 + 0.5, y1 + 0.5,
        x2 - 0.5, y2 - 0.5, fg, 0)
      al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)
      al_draw_text(theme.font, fg, (x1 + x2 + 1) / 2,
        y1, ALLEGRO_ALIGN_CENTRE, text.c_str)
    end
  end

  alias_method :get_pushed, :pushed
end

class ToggleButton < Button
  def on_mouse_button_down(mx, my)
    set_pushed(!pushed)
  end

  def on_mouse_button_up(mx, my)
  end

  def set_pushed(pushed)
    if self.pushed != pushed
      self.pushed = pushed
      dialog.request_draw if dialog
    end
  end
end

class List < Widget
  private

  attr_accessor :empty_string

  attr_accessor :items, :selected_item

  public

  def initialize(initial_selection = 0)
    self.empty_string = ""
    self.items = []
    self.selected_item = initial_selection
  end

  def want_key_focus
    true
  end

  def on_key_down(event)
    case event[:keycode]
    when ALLEGRO_KEY_DOWN
      if selected_item < items.size - 1
        self.selected_item += 1
        dialog.request_draw
      end

    when ALLEGRO_KEY_UP
      if selected_item > 0
        self.selected_item -= 1
        dialog.request_draw
      end
    end
  end

  def on_click(mx, my)
    theme = dialog.get_theme
    i = (my - y1) / al_get_font_line_height(theme.font)
    if i < items.size
      self.selected_item = i
      dialog.request_draw
    end
  end

  def draw
    theme = dialog.get_theme

    SaveState.new do
      al_draw_filled_rectangle(x1 + 1, y1 + 1, x2 - 1, y2 - 1, theme.bg)

      al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)
      font_height = al_get_font_line_height(theme.font)
      items.each_with_index do |item, i|
        yi = y1 + i * font_height

        if i == selected_item
          al_draw_filled_rectangle(x1 + 1, yi, x2 - 1, yi + font_height - 1,
            theme.highlight)
        end

        al_draw_text(theme.font, theme.fg, x1, yi, 0, item)
      end
    end
  end

  def clear_items
    items.clear
    self.selected_item = 0
  end

  def append_item(text)
    items << text
  end

  def get_selected_item_text
    if selected_item < items.size
      items[selected_item]
    else
      empty_string
    end
  end

  alias_method :get_cur_value, :selected_item
  public :get_cur_value
end

class VSlider < Widget
  private

  attr_accessor :cur_value, :max_value

  public

  def initialize(cur_value = 0, max_value = 1)
    self.cur_value = cur_value
    self.max_value = max_value
  end

  def on_mouse_button_down(mx, my)
    on_mouse_button_hold(mx, my)
  end

  def on_mouse_button_hold(mx, my)
    r = (y2 - 1 - my).to_f / (height - 2)
    r = clamp(0.0, r, 1.0)
    self.cur_value = (r * max_value).to_i
    dialog.request_draw
  end

  def draw
    theme = dialog.get_theme
    left = x1 + 0.5
    top = y1 + 0.5
    right = x2 + 0.5
    bottom = y2 + 0.5

    SaveState.new do
      al_draw_rectangle(left, top, right, bottom, theme.fg, 1)

      ratio = cur_value.to_f / max_value.to_f
      ypos = (bottom - 0.5 - (ratio * (height - 7)).to_i).to_i
      al_draw_filled_rectangle(left + 0.5, ypos - 5, right - 0.5, ypos, theme.fg)
    end
  end

  alias_method :get_cur_value, :cur_value
  public :get_cur_value

  alias_method :set_cur_value, :cur_value=
  public :set_cur_value
end

class HSlider < Widget
  private

  attr_accessor :cur_value, :max_value

  public

  def initialize(cur_value = 0, max_value = 1)
    self.cur_value = cur_value
    self.max_value = max_value
  end

  def on_mouse_button_down(mx, my)
    on_mouse_button_hold(mx, my)
  end

  def on_mouse_button_hold(mx, my)
    r = (mx - 1 - x1).to_f / (width - 2)
    r = clamp(0.0, r, 1.0)
    self.cur_value = (r * max_value).to_i
    dialog.request_draw
  end

  def draw
    theme = dialog.get_theme
    cy = (y1 + y2) / 2

    SaveState.new do
      al_draw_filled_rectangle(x1, y1, x2, y2, theme.bg)
      al_draw_line(x1, cy, x2, cy, theme.fg, 0)

      ratio = cur_value.to_f / max_value.to_f
      xpos = x1 + (ratio * (width - 2)).to_i
      al_draw_filled_rectangle(xpos - 2, y1, xpos + 2, y2, theme.fg)
    end
  end

  alias_method :get_cur_value, :cur_value
  public :get_cur_value

  alias_method :set_cur_value, :cur_value=
  public :set_cur_value
end

class TextEntry < Widget
  private

  CURSOR_WIDTH = 8

  attr_accessor :text, :focused, :cursor_pos, :left_pos

  public

  def initialize(initial_text)
    self.focused = false
    self.cursor_pos = 0
    self.left_pos = 0
    self.text = al_ustr_new(initial_text)

    ObjectSpace.define_finalizer(self, self.class.finalize(text))
  end

  def self.finalize(text)
    proc { al_ustr_free(text) }
  end

  def want_key_focus
    true
  end

  def got_key_focus
    self.focused = true
    dialog.request_draw
  end

  def lost_key_focus
    self.focused = false
    dialog.request_draw
  end

  def on_key_down(event)
    case event[:keycode]
    when ALLEGRO_KEY_LEFT
      al_ustr_prev(text, cursor_pos)

    when ALLEGRO_KEY_RIGHT
      al_ustr_next(text, cursor_pos)

    when ALLEGRO_KEY_HOME
      self.cursor_pos = 0

    when ALLEGRO_KEY_END
      self.cursor_pos = al_ustr_size(text)

    when ALLEGRO_KEY_DELETE
      al_ustr_remove_chr(text, cursor_pos)

    when ALLEGRO_KEY_BACKSPACE
      if al_ustr_prev(text, cursor_pos)
        al_ustr_remove_chr(text, cursor_pos)
      end

    else
      if event[:unichar] >= ' '.ord
        al_ustr_insert_chr(text, cursor_pos, event[:unichar])
        self.cursor_pos += al_utf8_width(event[:unichar])
      end
    end

    maybe_scroll
    dialog.request_draw
  end

  private def maybe_scroll
    theme = dialog.get_theme

    if cursor_pos < left_pos + 3
      if cursor_pos < 3
        self.left_pos = 0
      else
        self.left_pos = cursor_pos - 3
      end
    else
      loop do
        tw = al_get_ustr_width(theme.font,
          UString.new(text, left_pos, cursor_pos).ustr)
        break if x1 + tw + CURSOR_WIDTH < x2
        al_ustr_next(text, left_pos)
      end
    end
  end

  def draw
    theme = dialog.get_theme

    SaveState.new do
      al_draw_filled_rectangle(x1, y1, x2, y2, theme.bg)

      al_set_blender(:allegro_add, :allegro_one, :allegro_inverse_alpha)

      if !focused
        al_draw_ustr(theme.font, theme.fg, x1, y1, 0, UString.new(text, left_pos).ustr)
      else
        x = x1

        if cursor_pos > 0
          sub = UString.new(text, left_pos, cursor_pos)
          al_draw_ustr(theme.font, theme.fg, x1, y1, 0, sub)
          x += al_get_ustr_width(theme.font, sub)
        end

        if cursor_pos == al_ustr_size(text) # TODO unsigned?
          al_draw_filled_rectangle(x, y1, x + CURSOR_WIDTH,
            y1 + al_get_font_line_height(theme.font), theme.fg)
        else
          post_cursor = cursor_pos
          al_ustr_next(text, post_cursor)

          sub = UString.new(text, cursor_pos, post_cursor)
          subw = al_get_ustr_width(theme.font, sub.ustr)
          al_draw_filled_rectangle(x, y1, x + subw,
            y1 + al_get_font_line_height(theme.font), theme.fg)
          al_draw_ustr(theme.font, theme.bg, x, y1, 0, sub.ustr)
          x += subw

          al_draw_ustr(theme.font, theme.fg, x, y1, 0,
            UString.new(text, post_cursor).ustr)
        end
      end
    end
  end

  def get_text
    al_cstr(text)
  end
end
