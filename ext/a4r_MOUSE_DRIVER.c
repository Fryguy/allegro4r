#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::MOUSE_DRIVER
 *
 * Stores the contents of the mouse driver.
 */
VALUE cMOUSE_DRIVER;

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the mouse driver.
 */
VALUE a4r_MOUSE_DRIVER_name_get(VALUE self)
{
  MOUSE_DRIVER *driver;
  Data_Get_Struct(self, MOUSE_DRIVER, driver);
  return rb_str_new2(driver->name);
}
