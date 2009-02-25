#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::JOYSTICK_DRIVER
 *
 * Stores the contents of the joystick driver.
 */
VALUE cJOYSTICK_DRIVER;

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the joystick driver.
 */
VALUE a4r_JOYSTICK_DRIVER_name_get(VALUE self)
{
  JOYSTICK_DRIVER *driver;
  Data_Get_Struct(self, JOYSTICK_DRIVER, driver);
  return rb_str_new2(driver->name);
}
