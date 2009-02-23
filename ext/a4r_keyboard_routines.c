#include "allegro4r.h"

/*
 * call-seq:
 *   install_keyboard -> int
 *
 * Installs the Allegro keyboard interrupt handler. You must call this before
 * using any of the keyboard input routines. Once you have set up the Allegro
 * handler, you can no longer use operating system calls or C library functions
 * to access the keyboard.
 *
 * Note that on some platforms the keyboard won't work unless you have set a
 * graphics mode, even if this function returns a success value before calling
 * set_gfx_mode. This can happen in environments with graphic windowed modes,
 * since Allegro usually reads the keyboard through the graphical window (which
 * appears after the set_gfx_mode call). Example:
 *   allegro_init
 *   install_timer
 *   install_keyboard
 *   # We are not 100% sure we can read the keyboard yet!
 *   if set_gfx_mode(GFX_AUTODETECT, 640, 480, 0, 0) != 0
 *     abort_on_error("Couldn't set graphic mode!")
 *   end
 *
 *   # Now we are guaranteed to be able to read the keyboard.
 *   readkey
 *
 * Return value: Returns zero on success, or a negative number on failure (but
 * you may decide not to check the return value as this function is very
 * unlikely to fail).
 */
VALUE a4r_install_keyboard(VALUE self)
{
  return INT2FIX(install_keyboard());
}

/*
 * call-seq:
 *   key -> ary
 *
 * Array of flags indicating the state of each key, ordered by scancode.
 * Wherever possible these values will be updated asynchronously, but if
 * keyboard_needs_poll returns true, you must manually call poll_keyboard to
 * update them with the current input state. The scancodes are defined as a
 * series of KEY_* constants (and are also listed below). For example, you could
 * write:
 *   printf("Space is pressed\n") if key[KEY_SPACE]
 *
 * Note that the array is supposed to represent which keys are physically held
 * down and which keys are not, so it is semantically read-only.
 *
 * These are the keyboard scancodes:
 *   KEY_A ... KEY_Z,
 *   KEY_0 ... KEY_9,
 *   KEY_0_PAD ... KEY_9_PAD,
 *   KEY_F1 ... KEY_F12,
 *
 *   KEY_ESC, KEY_TILDE, KEY_MINUS, KEY_EQUALS,
 *   KEY_BACKSPACE, KEY_TAB, KEY_OPENBRACE, KEY_CLOSEBRACE,
 *   KEY_ENTER, KEY_COLON, KEY_QUOTE, KEY_BACKSLASH,
 *   KEY_BACKSLASH2, KEY_COMMA, KEY_STOP, KEY_SLASH,
 *   KEY_SPACE,
 *
 *   KEY_INSERT, KEY_DEL, KEY_HOME, KEY_END, KEY_PGUP,
 *   KEY_PGDN, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN,
 *
 *   KEY_SLASH_PAD, KEY_ASTERISK, KEY_MINUS_PAD,
 *   KEY_PLUS_PAD, KEY_DEL_PAD, KEY_ENTER_PAD,
 *
 *   KEY_PRTSCR, KEY_PAUSE,
 *
 *   KEY_ABNT_C1, KEY_YEN, KEY_KANA, KEY_CONVERT, KEY_NOCONVERT,
 *   KEY_AT, KEY_CIRCUMFLEX, KEY_COLON2, KEY_KANJI,
 *
 *   KEY_LSHIFT, KEY_RSHIFT,
 *   KEY_LCONTROL, KEY_RCONTROL,
 *   KEY_ALT, KEY_ALTGR,
 *   KEY_LWIN, KEY_RWIN, KEY_MENU,
 *   KEY_SCRLOCK, KEY_NUMLOCK, KEY_CAPSLOCK
 *
 *   KEY_EQUALS_PAD, KEY_BACKQUOTE, KEY_SEMICOLON, KEY_COMMAND
 *
 * Finally, you may notice an 'odd' behaviour of the KEY_PAUSE key. This key
 * only generates an interrupt when it is pressed, not when it is released. For
 * this reason, Allegro pretends the pause key is a 'state' key, which is the
 * only way to make it usable.
 */
VALUE a4r_key(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  //       make [] access directly without array conversion?
  VALUE ret = rb_ary_new2(KEY_MAX);
  long x;
  for (x = KEY_A; x <= KEY_MAX; x++)
    rb_ary_store(ret, x, key[x] == 0 ? Qfalse : Qtrue);
  return ret;
}

/*
 * call-seq:
 *   key_shifts -> int
 *
 * Bitmask containing the current state of shift/ctrl/alt, the special Windows
 * keys, and the accent escape characters. Wherever possible this value will be
 * updated asynchronously, but if keyboard_needs_poll returns true, you must
 * manually call poll_keyboard to update it with the current input state. This
 * can contain any of the flags:
 *   KB_SHIFT_FLAG
 *   KB_CTRL_FLAG
 *   KB_ALT_FLAG
 *   KB_LWIN_FLAG
 *   KB_RWIN_FLAG
 *   KB_MENU_FLAG
 *   KB_COMMAND_FLAG
 *   KB_SCROLOCK_FLAG
 *   KB_NUMLOCK_FLAG
 *   KB_CAPSLOCK_FLAG
 *   KB_INALTSEQ_FLAG
 *   KB_ACCENT1_FLAG
 *   KB_ACCENT2_FLAG
 *   KB_ACCENT3_FLAG
 *   KB_ACCENT4_FLAG
 *
 * Example:
 *   if key[KEY_W]
 *     if key_shifts & KB_SHIFT_FLAG != 0
 *        # User is pressing shift + W.
 *     else
 *        # Hmmm... lower case W then.
 *     end
 *   end
 */
VALUE a4r_key_shifts(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return INT2FIX(key_shifts);
}

/*
 * call-seq:
 *   keypressed -> true or false
 *
 * Returns true if there are keypresses waiting in the input buffer. You can use
 * this to see if the next call to readkey is going to block or to simply wait
 * for the user to press a key while you still update the screen possibly
 * drawing some animation. Example:
 *   while !keypressed do
 *     # Show cool animated logo.
 *   end
 *   # So he skipped our title screen.
 */
VALUE a4r_keypressed(VALUE self)
{
  return keypressed() ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   readkey -> int
 *
 * Returns the next character from the keyboard buffer, in ASCII format. If the
 * buffer is empty, it waits until a key is pressed. You can see if there are
 * queued keypresses with keypressed.
 *
 * The low byte of the return value contains the ASCII code of the key, and the
 * high byte the scancode. The scancode remains the same whatever the state of
 * the shift, ctrl and alt keys, while the ASCII code is affected by shift and
 * ctrl in the normal way (shift changes case, ctrl+letter gives the position of
 * that letter in the alphabet, eg. ctrl+A = 1, ctrl+B = 2, etc). Pressing
 * alt+key returns only the scancode, with a zero ASCII code in the low byte.
 * For example:
 *   val = readkey
 *   if (val & 0xff) == 'd'      # by ASCII code
 *     allegro_message("You pressed 'd'\n")
 *   end
 *
 *   if (val >> 8) == KEY_SPACE  # by scancode
 *     allegro_message("You pressed Space\n");
 *   end
 *
 *   if (val & 0xff) == 3        # ctrl+letter
 *     allegro_message("You pressed Control+C\n");
 *   end
 *
 *   if val == (KEY_X << 8)      # alt+letter
 *     allegro_message("You pressed Alt+X\n");
 *   end
 *
 * This function cannot return character values greater than 255. If you need to
 * read Unicode input, use ureadkey instead.
 */
VALUE a4r_readkey(VALUE self)
{
  return INT2FIX(readkey());
}

/*
 * call-seq:
 *   ureadkey(scancode) -> int
 *   ureadkey(scancode) -> [int, int]
 *
 * Returns the next character from the keyboard buffer, in Unicode format. If
 * the buffer is empty, it waits until a key is pressed. You can see if there
 * are queued keypresses with keypressed. The return value contains the Unicode
 * value of the key, and if not nil or false, the second return value will be
 * set to the scancode. Unlike readkey, this function is able to return
 * character values greater than 255. Example:
 *   val, scancode = ureadkey(true)
 *   if val == 0x00F1
 *     allegro_message("You pressed n with tilde\n")
 *   end
 *
 *   if val == 0x00DF
 *     allegro_message("You pressed sharp s\n")
 *   end
 *
 * You should be able to find Unicode character maps at http://www.unicode.org/.
 * Remember that on DOS you must specify a custom keyboard map (like those found
 * in 'keyboard.dat') usually with the help of a configuration file specifying
 * the language mapping (keyboard variable in system section of 'allegro.cfg'),
 * or you will get the default US keyboard mapping.
 *
 * *** The Ruby method signature differs from the Allegro method signature. The
 * Allegro signature takes scancode by reference, but the Ruby signature takes a
 * boolean.  If false or nil, the method returns only the read key, otherwise it
 * returns an array containing the read key and the scancode.
 */
VALUE a4r_ureadkey(VALUE self, VALUE scancode)
{
  int s;
  int *s_p = NULL;

  if (RTEST(scancode))
    s_p = &s;
  int u = ureadkey(s_p);

  VALUE ret;
  if (s_p)
    ret = rb_ary_new3(2, INT2FIX(u), INT2FIX(s));
  else
    ret = INT2FIX(u);

  return ret;
}

/*
 * call-seq:
 *   scancode_to_name(scancode) -> str
 *
 * This function returns a string containing the name of they key with the given
 * scancode. This is useful if you e.g. let the user choose a key for some
 * action, and want to display something more meaningful than just the scancode.
 * Example:
 *   keyname = scancode_to_name(scancode)
 *   allegro_message("You pressed the %s key." % keyname)
 */
VALUE a4r_scancode_to_name(VALUE self, VALUE scancode)
{
  return rb_str_new2(scancode_to_name(FIX2INT(scancode)));
}

/*
 * call-seq:
 *   keyboard_callback = proc
 *
 * If set, this function is called by the keyboard handler in response to every
 * keypress. It is passed a copy of the value that is about to be added into the
 * input buffer, and can either return this value unchanged, return zero to
 * cause the key to be ignored, or return a modified value to change what
 * readkey will later return. This routine executes in an interrupt context, so
 * it must be in locked memory. Example:
 *   def enigma_scrambler(key)
 *     # Add one to both the scancode and ascii values.
 *     return (((key >> 8) + 1) << 8) | ((key & 0xff) + 1)
 *   end
 *
 *   ...
 *
 *     install_timer
 *     LOCK_FUNCTION(:enigma_scrambler)
 *     install_keyboard
 *     keyboard_callback = self.method(:enigma_scrambler)
 *
 * Note that this callback will be ignored if you also set the unicode keyboard
 * callback.
 */
VALUE a4r_keyboard_callback_set(VALUE self, VALUE proc)
{
  // TODO: Validate proc and maybe check for 0 in the keyboard_callback_method?
  // TODO: hooked variable?
  keyboard_callback_proc = proc;
  if (proc == Qnil)
    keyboard_callback = NULL;
  else
    keyboard_callback = keyboard_callback_method;
  return proc;
}

/*
 * call-seq:
 *   keyboard_lowlevel_callback = proc
 *
 * If set, this function is called by the keyboard handler in response to every
 * keyboard event, both presses (including keyboard repeat rate) and releases.
 * It will be passed a raw keyboard scancode byte (scancodes are 7 bits long),
 * with the top bit (8th bit) clear if the key has been pressed or set if it was
 * released. This routine executes in an interrupt context, so it must be in
 * locked memory. Example:
 *
 *   def keypress_watcher(scancode)
 *     if (scancode & 0x80) != 0
 *       key_up = 1
 *     else
 *       key_down = 1
 *     end
 *   end
 *
 *   ...
 *
 *     install_timer
 *     LOCK_FUNCTION(silence_g_key)
 *     LOCK_VARIABLE(key_down)
 *     LOCK_VARIABLE(key_up)
 *     install_keyboard
 *     keyboard_lowlevel_callback = self.method(:keypress_watcher)
 *     # Disable keyboard repeat to get typewriter effect.
 *     set_keyboard_rate(0, 0)
 *
 *   ...
 *
 *     while (game_loop)
 *       if (key_down == 1)
 *          key_down = 0
 *          # Play sample of typewriter key press.
 *       end
 *       if (key_up == 1)
 *          key_up = 0;
 *          # Play sample of typewriter key release.
 *       end
 *     end
 */
VALUE a4r_keyboard_lowlevel_callback_set(VALUE self, VALUE proc)
{
  // TODO: Validate proc and maybe check for 0 in the keyboard_lowlevel_callback_method?
  // TODO: hooked variable?
  keyboard_lowlevel_callback_proc = proc;
  if (proc == Qnil)
    keyboard_lowlevel_callback = NULL;
  else
    keyboard_lowlevel_callback = keyboard_lowlevel_callback_method;
  return proc;
}

/*
 * call-seq:
 *   clear_keybuf -> nil
 *
 * Empties the keyboard buffer. Usually you want to use this in your program
 * before reading keys to avoid previously buffered keys to be returned by calls
 * to readkey or ureadkey.
 */
VALUE a4r_clear_keybuf(VALUE self)
{
  clear_keybuf();
  return Qnil;
}

/******************************************************************************/
// Predefined keyboard callback routines
/*
 * TODO: The keyboard callback routines are not working as expected.  I thought
 * I might be able to fake things by setting a global variable to a proc, which
 * then would get called by the below methods.  Unfortunately, even with no code
 * in the proc, it crashes ruby.  I'm assuming that since these methods run
 * in an interrupt context, there is a clash between the Ruby code and the
 * lowlevel code.
 */

VALUE keyboard_callback_proc;
VALUE keyboard_lowlevel_callback_proc;

int keyboard_callback_method(int key)
{
  return FIX2INT(rb_funcall(keyboard_callback_proc, CALL_ID, 1, INT2FIX(key)));
}
END_OF_FUNCTION(keyboard_callback_method)

void keyboard_lowlevel_callback_method(int scancode)
{
  rb_funcall(keyboard_lowlevel_callback_proc, CALL_ID, 1, INT2FIX(scancode));
}
END_OF_FUNCTION(keyboard_lowlevel_callback_method)

