#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_clear_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_bitmap(bmp);
  return Qnil;
}

static VALUE a4r_clear_to_color(VALUE self, VALUE bitmap, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_to_color(bmp, FIX2INT(color));
  return Qnil;
}

static VALUE a4r_rectfill(VALUE self, VALUE bmp, VALUE x1, VALUE y1, VALUE x2, VALUE y2, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  rectfill(bitmap, FIX2INT(x1), FIX2INT(y1), FIX2INT(x2), FIX2INT(y2), FIX2INT(color));
  return Qnil;
}

static VALUE a4r_circle(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  circle(bitmap, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}

static VALUE a4r_circlefill(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  circlefill(bitmap, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}
