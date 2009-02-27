#include "allegro4r.h"

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the keyboard driver.
 */
VALUE a4r_API_KEYBOARD_DRIVER_name_get(VALUE self)
{
  KEYBOARD_DRIVER *driver;
  Data_Get_Struct(self, KEYBOARD_DRIVER, driver);
  return rb_str_new2(driver->name);
}
