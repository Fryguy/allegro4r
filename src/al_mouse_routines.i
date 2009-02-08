#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_install_mouse(VALUE self)
{
  return INT2FIX(install_mouse());
}

static VALUE al_show_mouse(VALUE self, VALUE bmp)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  show_mouse(b);
  return Qnil;
}
