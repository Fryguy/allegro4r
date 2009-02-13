#include "allegro4r.h"

VALUE cMOUSE_DRIVER;

VALUE a4r_MOUSE_DRIVER_name_get(VALUE self)
{
  MOUSE_DRIVER *driver;
  Data_Get_Struct(self, MOUSE_DRIVER, driver);
  return rb_str_new2(driver->name);
}
