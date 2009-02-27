#include "allegro4r.h"

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the mouse driver.
 */
VALUE a4r_API_MOUSE_DRIVER_name_get(VALUE self)
{
  MOUSE_DRIVER *driver;
  Data_Get_Struct(self, MOUSE_DRIVER, driver);
  return rb_str_new2(driver->name);
}
