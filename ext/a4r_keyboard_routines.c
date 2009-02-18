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
