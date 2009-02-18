#include "allegro4r.h"

/*
 * call-seq:
 *   allegro_init -> int
 *
 * Macro which initialises the Allegro library. This is the same thing as
 * calling install_allegro(SYSTEM_AUTODETECT, &errno, atexit).
 */
VALUE a4r_allegro_init(VALUE self)
{
  return INT2FIX(allegro_init());
}

/*
 * call-seq:
 *   allegro_exit -> nil
 *
 * Closes down the Allegro system. This includes returning the system to text
 * mode and removing whatever mouse, keyboard, and timer routines have been
 * installed. You don't normally need to bother making an explicit call to this
 * function, because allegro_init installs it as an atexit routine so it will be
 * called automatically when your program exits.
 *
 * Note that after you call this function, other functions like destroy_bitmap
 * will most likely crash. This is a problem for C++ global destructors, which
 * usually get called after atexit, so don't put Allegro calls in them. You can
 * write the destructor code in another method which you can manually call
 * before your program exits, avoiding this problem.
 */
VALUE a4r_allegro_exit(VALUE self)
{
  allegro_exit();
  return Qnil;
}

/*
 * call-seq:
 *   allegro_error -> str
 *
 * Text string used by set_gfx_mode, install_sound and other functions to report
 * error messages. If they fail and you want to tell the user why, this is the
 * place to look for a description of the problem. Example:
 *   def abort_on_error(message)
 *     set_gfx_mode(GFX_TEXT, 0, 0, 0, 0) unless screen.nil?
 *
 *     allegro_message("%s.\nLast Allegro error '%s'\n" %
 *       [message, allegro_error])
 *     exit -1
 *   end
 *   ...
 *     if some_allegro_function == ERROR_CODE
 *       abort_on_error("Error calling some function!")
 *     end
 */
VALUE a4r_allegro_error(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return rb_str_new2(allegro_error);
}

/*
 * call-seq:
 *   allegro_message(text) -> nil
 *
 * Outputs a message, using a printf format string. Usually you want to use this
 * to report messages to the user in an OS independant way when some Allegro
 * subsystem cannot be initialised. But you must not use this function if you
 * are in a graphic mode, only before calling set_gfx_mode, or after a
 * set_gfx_mode(GFX_TEXT). Also, this function depends on a system driver being
 * installed, which means that it won't display the message at all on some
 * platforms if Allegro has not been initialised correctly.
 *
 * On platforms featuring a windowing system, it will bring up a blocking GUI
 * message box. If there is no windowing system, it will try to print the string
 * to a text console, attempting to work around codepage differences by reducing
 * any accented characters to 7-bit ASCII approximations. Example:
 *   exit 1 if allegro_init != 0
 *
 *   if init_my_data != 0
 *     allegro_message("Sorry, missing game data!\n")
 *     exit 2
 *   end
 */
VALUE a4r_allegro_message(VALUE self, VALUE text)
{
  // TODO: Allow parameter possing a lo printf for direct API consistency or force string only?
  allegro_message(StringValuePtr(text));
  return Qnil;
}
