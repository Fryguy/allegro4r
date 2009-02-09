#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_GFX_DRIVER_name_get(VALUE self)
{
  GFX_DRIVER *driver;
  Data_Get_Struct(self, GFX_DRIVER, driver);
  return rb_str_new2(driver->name);
}
