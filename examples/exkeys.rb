#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to access the keyboard. The
# first part shows the basic use of readkey(). The second part
# shows how to extract the ASCII value. Next come the scan codes.
# The fourth test detects modifier keys like alt or shift. The
# fifth test requires some focus to be passed. The final step
# shows how to use the global key array to read simultaneous
# key presses.
# The last method to detect key presses are keyboard callbacks.
# This is demonstrated by by installing a keyboard callback,
# which marks all pressed keys by drawing to a grid.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

key_names = [
  "(none)",         "KEY_A",          "KEY_B",          "KEY_C",
  "KEY_D",          "KEY_E",          "KEY_F",          "KEY_G",
  "KEY_H",          "KEY_I",          "KEY_J",          "KEY_K",
  "KEY_L",          "KEY_M",          "KEY_N",          "KEY_O",
  "KEY_P",          "KEY_Q",          "KEY_R",          "KEY_S",
  "KEY_T",          "KEY_U",          "KEY_V",          "KEY_W",
  "KEY_X",          "KEY_Y",          "KEY_Z",          "KEY_0",
  "KEY_1",          "KEY_2",          "KEY_3",          "KEY_4",
  "KEY_5",          "KEY_6",          "KEY_7",          "KEY_8",
  "KEY_9",          "KEY_0_PAD",      "KEY_1_PAD",      "KEY_2_PAD",
  "KEY_3_PAD",      "KEY_4_PAD",      "KEY_5_PAD",      "KEY_6_PAD",
  "KEY_7_PAD",      "KEY_8_PAD",      "KEY_9_PAD",      "KEY_F1",
  "KEY_F2",         "KEY_F3",         "KEY_F4",         "KEY_F5",
  "KEY_F6",         "KEY_F7",         "KEY_F8",         "KEY_F9",
  "KEY_F10",        "KEY_F11",        "KEY_F12",        "KEY_ESC",
  "KEY_TILDE",      "KEY_MINUS",      "KEY_EQUALS",     "KEY_BACKSPACE",
  "KEY_TAB",        "KEY_OPENBRACE",  "KEY_CLOSEBRACE", "KEY_ENTER",
  "KEY_COLON",      "KEY_QUOTE",      "KEY_BACKSLASH",  "KEY_BACKSLASH2",
  "KEY_COMMA",      "KEY_STOP",       "KEY_SLASH",      "KEY_SPACE",
  "KEY_INSERT",     "KEY_DEL",        "KEY_HOME",       "KEY_END",
  "KEY_PGUP",       "KEY_PGDN",       "KEY_LEFT",       "KEY_RIGHT",
  "KEY_UP",         "KEY_DOWN",       "KEY_SLASH_PAD",  "KEY_ASTERISK",
  "KEY_MINUS_PAD",  "KEY_PLUS_PAD",   "KEY_DEL_PAD",    "KEY_ENTER_PAD",
  "KEY_PRTSCR",     "KEY_PAUSE",      "KEY_ABNT_C1",    "KEY_YEN",
  "KEY_KANA",       "KEY_CONVERT",    "KEY_NOCONVERT",  "KEY_AT",
  "KEY_CIRCUMFLEX", "KEY_COLON2",     "KEY_KANJI",      "KEY_EQUALS_PAD",
  "KEY_BACKQUOTE",  "KEY_SEMICOLON",  "KEY_COMMAND",    "KEY_UNKNOWN1",
  "KEY_UNKNOWN2",   "KEY_UNKNOWN3",   "KEY_UNKNOWN4",   "KEY_UNKNOWN5",
  "KEY_UNKNOWN6",   "KEY_UNKNOWN7",   "KEY_UNKNOWN8",   "KEY_LSHIFT",
  "KEY_RSHIFT",     "KEY_LCONTROL",   "KEY_RCONTROL",   "KEY_ALT",
  "KEY_ALTGR",      "KEY_LWIN",       "KEY_RWIN",       "KEY_MENU",
  "KEY_SCRLOCK",    "KEY_NUMLOCK",    "KEY_CAPSLOCK",   "KEY_MAX"
]

# Keyboard callback. We are very evil and draw to the screen from within
# the callback. Don't do this in your own programs ;)
def keypress_handler(scancode)
  i = scancode & 0x7f
  x = SCREEN_W() - 100 * 3 + (i % 3) * 100
  y = SCREEN_H() / 2 + (i / 3 - 21) * 10
  color = scancode & 0x80 != 0 ? makecol(255, 255, 0) : makecol(128, 0, 0)
  rectfill(screen, x, y, x + 95, y + 8, color)
  str = ustrzncpy(scancode_to_name(i), 12)
  textprintf_ex(screen, font, x + 1, y + 1, makecol(0, 0, 0), -1, str)
end

# helper function for making more room on the screen
def scroll
  blit(screen, screen, 0, 32, 0, 24, SCREEN_W() / 2, SCREEN_H() - 32)
  rectfill(screen, 0, SCREEN_H() - 16, SCREEN_W() / 2, SCREEN_H() - 1, makecol(255, 255, 255))
end

begin
  exit 1 if allegro_init != 0
  install_keyboard
  install_timer

  if set_gfx_mode(GFX_AUTODETECT, 640, 480, 0, 0) != 0
    if set_gfx_mode(GFX_SAFE, 640, 480, 0, 0) != 0
      set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
      allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
      exit 1
    end
  end

  set_palette(desktop_palette)

  clear_to_color(screen, makecol(255, 255, 255))

  # Draw the initial keys grid by simulating release of every key.
  (0...KEY_MAX).each do |k|
    keypress_handler(k + 0x80)
  end

  # Install our keyboard callback.
  # TODO: Have not been able to figure out how to get the keyboard interrupt stuff
  # to work with Ruby, so I'm temporarily skipping this part.
#  LOCK_FUNCTION(:keypress_handler)
#  Allegro4r::API.keyboard_lowlevel_callback = self.method(:keypress_handler)

  acquire_screen
  textprintf_centre_ex(screen, font, SCREEN_W()/2, 8, makecol(0, 0, 0), makecol(255, 255, 255), "Driver: %s" % keyboard_driver.name)

  # keyboard input can be accessed with the readkey function
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press some keys (ESC to finish)")
  scroll

  loop do
    release_screen
    k = readkey
    acquire_screen
    scroll
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "readkey returned %-6d (0x%04X)" % [k, k])
    break unless (k & 0xFF) != 27
  end

  # the ASCII code is in the low byte of the return value
  scroll; scroll; scroll
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press some more keys (ESC to finish)")
  scroll

  loop do
    release_screen
    k = readkey
    acquire_screen
    scroll
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "ASCII code is %d" % (k & 0xFF))
    break unless (k & 0xFF) != 27
  end

  # the hardware scan code is in the high byte of the return value
  scroll; scroll; scroll
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press some more keys (ESC to finish)")
  scroll

  loop do
    release_screen
    k = readkey
    acquire_screen
    scroll
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Scan code is %d (%s)" % [k>>8, key_names[k>>8]])
    break unless (k & 0xFF) != 27
  end
  
  # key qualifiers are stored in the key_shifts variable. Note that this
  # version of the code uses ureadkey instead of readkey: that is
  # necessary if you want to access Unicode characters from outside
  # the normal ASCII range, for example to support Russian or Chinese.
  scroll; scroll; scroll
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press some more keys (ESC to finish)")
  scroll

  loop do
    release_screen
    k = ureadkey(nil)
    acquire_screen
    buf = ""
    buf << "shift "   if (key_shifts & KB_SHIFT_FLAG != 0)
    buf << "ctrl "    if (key_shifts & KB_CTRL_FLAG != 0)
    buf << "alt "     if (key_shifts & KB_ALT_FLAG != 0)
    buf << "lwin "    if (key_shifts & KB_LWIN_FLAG != 0)
    buf << "rwin "    if (key_shifts & KB_RWIN_FLAG != 0)
    buf << "menu "    if (key_shifts & KB_MENU_FLAG != 0)
    buf << "command " if (key_shifts & KB_COMMAND_FLAG != 0)
    buf << usprintf("'%c' [0x%02x]" % [k != 0 ? k : ' '[0], k])
    buf << " caps"    if (key_shifts & KB_CAPSLOCK_FLAG != 0)
    buf << " num"     if (key_shifts & KB_NUMLOCK_FLAG != 0)
    buf << " scrl"    if (key_shifts & KB_SCROLOCK_FLAG != 0)
    scroll
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), buf)
    break unless k != 27
  end

  # various scan codes are defined in allegro.h as KEY_* constants
  scroll; scroll; scroll
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press F6")
  scroll

  release_screen
  k = readkey
  acquire_screen

  while (k>>8) != KEY_F6 && (k>>8) != KEY_ESC
    scroll
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Wrong key, stupid! I said press F6")
    release_screen
    k = readkey
    acquire_screen
  end

  # for detecting multiple simultaneous key presses, use the key[] array
  scroll; scroll; scroll
  textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), "Press a combination of numbers")
  scroll; scroll

  release_screen

  buf = ' ' * 10
  loop do
    buf[0] = key[KEY_0] ? '0' : ' '
    buf[1] = key[KEY_1] ? '1' : ' '
    buf[2] = key[KEY_2] ? '2' : ' '
    buf[3] = key[KEY_3] ? '3' : ' '
    buf[4] = key[KEY_4] ? '4' : ' '
    buf[5] = key[KEY_5] ? '5' : ' '
    buf[6] = key[KEY_6] ? '6' : ' '
    buf[7] = key[KEY_7] ? '7' : ' '
    buf[8] = key[KEY_8] ? '8' : ' '
    buf[9] = key[KEY_9] ? '9' : ' '
    textprintf_ex(screen, font, 8, SCREEN_H()-16, makecol(0, 0, 0), makecol(255, 255, 255), buf)
    rest(1)
    break unless !keypressed || (readkey >> 8) != KEY_ESC
  end

  clear_keybuf
#  Allegro4r::API.keyboard_lowlevel_callback = nil;
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
