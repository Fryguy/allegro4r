#include "allegro4r.h"

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the joystick driver.
 */
VALUE a4r_API_JOYSTICK_DRIVER_name_get(VALUE self)
{
  JOYSTICK_DRIVER *driver;
  Data_Get_Struct(self, JOYSTICK_DRIVER, driver);
  return rb_str_new2(driver->name);
}