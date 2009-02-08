#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_drawing_mode(VALUE self, VALUE mode, VALUE pattern, VALUE x_anchor, VALUE y_anchor)
{
  BITMAP *bitmap;
  Data_Get_Struct(pattern, BITMAP, bitmap);
  drawing_mode(FIX2INT(mode), bitmap, FIX2INT(x_anchor), FIX2INT(y_anchor));
  return Qnil;
}

static VALUE a4r_solid_mode(VALUE self)
{
  solid_mode();
  return Qnil;
}
