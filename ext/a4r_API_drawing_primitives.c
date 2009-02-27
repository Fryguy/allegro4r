#include "allegro4r.h"

/*
 * call-seq:
 *   clear_bitmap(bitmap) -> nil
 *
 * Clears the bitmap to color 0.
 */
VALUE a4r_API_clear_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_bitmap(bmp);
  return Qnil;
}

/*
 * call-seq:
 *   clear_to_color(bitmap, color) -> nil
 *
 * Clears the bitmap to the specified color. Example:
 *   # Clear the screen to red.
 *   clear_to_color(bmp, makecol(255, 0, 0))
 */
VALUE a4r_API_clear_to_color(VALUE self, VALUE bitmap, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_to_color(bmp, FIX2INT(color));
  return Qnil;
}

/*
 * call-seq:
 *   putpixel(bmp, x, y, color) -> nil
 *
 * Writes a pixel to the specified position in the bitmap, using the current
 * drawing mode and the bitmap's clipping rectangle. Example:
 *   putpixel(screen, 10, 30, some_color)
 */
VALUE a4r_API_putpixel(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  putpixel(bitmap, FIX2INT(x), FIX2INT(y), FIX2INT(color));
  return Qnil;
}

/*
 * call-seq:
 *   getpixel(bmp, x, y) -> int
 *
 * Reads a pixel from point (x, y) in the bitmap.
 *
 * Return value: Returns -1 if the point lies outside the bitmap (ignoring the
 * clipping rectangle), otherwise the value of the pixel in the color format of
 * the bitmap.
 *
 * Warning: -1 is also a valid value for pixels contained in 32-bit bitmaps with
 * alpha channel (when R,G,B,A are all equal to 255) so you can't use the test
 * against -1 as a predicate for such bitmaps. In this cases, the only reliable
 * predicate is is_inside_bitmap.
 *
 * To extract the individual color components, use the getr / getg / getb /
 * geta family of functions.
 */
VALUE a4r_API_getpixel(VALUE self, VALUE bmp, VALUE x, VALUE y)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return INT2FIX(getpixel(bitmap, FIX2INT(x), FIX2INT(y)));
}

/*
 * call-seq:
 *   rectfill(bmp, x1, y1, x2, y2, color) -> nil
 *
 * Draws a solid, filled rectangle with the two points as its opposite corners.
 */
VALUE a4r_API_rectfill(VALUE self, VALUE bmp, VALUE x1, VALUE y1, VALUE x2, VALUE y2, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  rectfill(bitmap, FIX2INT(x1), FIX2INT(y1), FIX2INT(x2), FIX2INT(y2), FIX2INT(color));
  return Qnil;
}

/*
 * call-seq:
 *   circle(bmp, x, y, radius, color) -> nil
 *
 * Draws a circle with the specified centre and radius.
 */
VALUE a4r_API_circle(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  circle(bitmap, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}

/*
 * call-seq:
 *   circlefill(bmp, x, y, radius, color) -> nil
 *
 * Draws a filled circle with the specified centre and radius. 
 */
VALUE a4r_API_circlefill(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  circlefill(bitmap, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}
