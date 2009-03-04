#include "allegro4r.h"

/*
 * call-seq:
 *   install_sound(digi, midi, cfg_path) -> int
 *
 * Initialises the sound module. You should normally pass DIGI_AUTODETECT and
 * MIDI_AUTODETECT as the driver parameters to this function, in which case
 * Allegro will read hardware settings from the current configuration file. This
 * allows the user to select different values with the setup utility: see the
 * config section for details. Alternatively, see the platform specific
 * documentation for a list of the available drivers. The cfg_path parameter is
 * only present for compatibility with previous versions of Allegro, and has no
 * effect on anything.
 *
 * Return value: Returns zero if the sound is successfully installed, and -1 on
 * failure. If it fails it will store a description of the problem in
 * allegro_error.
 */
VALUE a4r_API_install_sound(VALUE self, VALUE digi, VALUE midi, VALUE cfg_path)
{
  char *c;
  if (cfg_path == Qnil)
    c = NULL;
  else
    c = StringValuePtr(cfg_path);

  return INT2FIX(install_sound(FIX2INT(digi), FIX2INT(midi), c));
}
