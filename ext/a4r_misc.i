#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_MIN(VALUE self, VALUE x, VALUE y)
{
  return INT2NUM(MIN(NUM2INT(x), NUM2INT(y)));
}

static VALUE a4r_ABS(VALUE self, VALUE x)
{
  return INT2NUM(ABS(NUM2INT(x)));
}

static VALUE a4r_AL_RAND(VALUE self)
{
  return INT2NUM(AL_RAND());
}

static VALUE a4r_gfx_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  GFX_DRIVER *driver = gfx_driver;
  VALUE obj = Data_Wrap_Struct(cGFX_DRIVER, 0, 0, driver);
  return obj;
}

static VALUE a4r_mouse_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  MOUSE_DRIVER *driver = mouse_driver;
  VALUE obj = Data_Wrap_Struct(cMOUSE_DRIVER, 0, 0, driver);
  return obj;
}
