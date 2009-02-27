#include "allegro4r.h"

/*
 * call-seq:
 *   bmp.h -> int
 *
 * Returns the height of the BITMAP in pixels.
 */
VALUE a4r_API_BITMAP_h_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->h);
}

/*
 * call-seq:
 *   bmp.w -> int
 *
 * Returns the width of the BITMAP in pixels.
 */
VALUE a4r_API_BITMAP_w_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->w);
}
