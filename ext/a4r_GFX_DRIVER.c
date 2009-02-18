#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::GFX_DRIVER
 *
 * Stores the contents of the graphics driver.
 */
VALUE cGFX_DRIVER;

/*
 * call-seq:
 *   driver.name -> str
 *
 * Returns the name of the graphics driver.
 */
VALUE a4r_GFX_DRIVER_name_get(VALUE self)
{
  GFX_DRIVER *driver;
  Data_Get_Struct(self, GFX_DRIVER, driver);
  return rb_str_new2(driver->name);
}
