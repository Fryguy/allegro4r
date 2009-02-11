#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_MOUSE_DRIVER_name_get(VALUE self)
{
  MOUSE_DRIVER *driver;
  Data_Get_Struct(self, MOUSE_DRIVER, driver);
  return rb_str_new2(driver->name);
}
