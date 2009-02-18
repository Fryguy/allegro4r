#include "allegro4r.h"

/*
 * call-seq:
 *   install_timer -> int
 *
 * Installs the Allegro timer interrupt handler. You must do this before
 * installing any user timer routines, and also before displaying a mouse
 * pointer, playing FLI animations or MIDI music, and using any of the GUI
 * routines.
 *
 * Return value: Returns zero on success, or a negative number on failure (but
 * you may decide not to check the return value as this function is very
 * unlikely to fail).
 */
VALUE a4r_install_timer(VALUE self)
{
  return INT2FIX(install_timer());
}

/*
 * call-seq:
 *   retrace_count -> int
 *
 * If the retrace simulator is installed, this count is incremented on each
 * vertical retrace; otherwise, if the refresh rate is known, the count is
 * incremented at the same rate (ignoring retraces); otherwise, it is
 * incremented 70 times a second. This provides a way of controlling the speed
 * of your program without installing user timer functions.
 */
VALUE a4r_retrace_count(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return INT2FIX(retrace_count);
}
