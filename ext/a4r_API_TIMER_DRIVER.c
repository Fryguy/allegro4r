#include "allegro4r.h"

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the timer driver.
 */
VALUE a4r_API_TIMER_DRIVER_name_get(VALUE self)
{
  TIMER_DRIVER *driver;
  Data_Get_Struct(self, TIMER_DRIVER, driver);
  return rb_str_new2(driver->name);
}
