#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_clear_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_bitmap(bmp);
  return Qnil;
}

static VALUE al_clear_to_color(VALUE self, VALUE bitmap, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_to_color(bmp, FIX2INT(color));
  return Qnil;
}

static VALUE al_circle(VALUE self, VALUE bitmap, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  circle(bmp, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}

static VALUE al_circlefill(VALUE self, VALUE bitmap, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  circlefill(bmp, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}
