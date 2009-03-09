#include "allegro4r.h"

/*
 * call-seq:
 *   driver.name -> str
 *
 * Driver name
 */
VALUE a4r_API_MIDI_DRIVER_name_get(VALUE self)
{
  MIDI_DRIVER *driver;
  Data_Get_Struct(self, MIDI_DRIVER, driver);
  return rb_str_new2(driver->name);
}
