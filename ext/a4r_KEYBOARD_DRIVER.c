#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::KEYBOARD_DRIVER
 *
 * Stores the contents of the keyboard driver.
 */
VALUE cKEYBOARD_DRIVER;

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the keyboard driver.
 */
VALUE a4r_KEYBOARD_DRIVER_name_get(VALUE self)
{
  KEYBOARD_DRIVER *driver;
  Data_Get_Struct(self, KEYBOARD_DRIVER, driver);
  return rb_str_new2(driver->name);
}
