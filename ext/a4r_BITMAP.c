#include "allegro4r.h"

VALUE cBITMAP;

VALUE a4r_BITMAP_h_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->h);
}

VALUE a4r_BITMAP_w_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->w);
}
