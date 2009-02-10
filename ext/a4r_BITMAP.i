#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_BITMAP_h_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->h);
}

static VALUE a4r_BITMAP_w_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->w);
}
