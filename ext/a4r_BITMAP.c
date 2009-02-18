#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::BITMAP
 *
 * Stores the contents of a bitmap.
 *
 *   int w, h               - size of the bitmap in pixels
 *   int clip               - non-zero if clipping is turned on
 *   int cl, cr, ct, cb     - clip rectangle left, right, top,
 *                             and bottom
 *   unsigned char *line[]  - pointers to the start of each line
 *
 * There is some other stuff in the structure as well, but it is liable to
 * change and you shouldn't use anything except the above. The 'w' and 'h'
 * fields can be used to obtain the size of an existing bitmap:
 *
 *   bmp = load_bitmap("file.bmp", pal)
 *   allegro_message("Bitmap size: (%dx%d)\n" % [bmp.w, bmp.h])
 *
 * The clipping rectangle is inclusive on the left and top (0 allows drawing to
 * position 0) but exclusive on the right and bottom (10 allows drawing to
 * position 9, but not to 10). Note this is not the same format as that of the
 * clipping API, which takes inclusive coordinates for all four corners. All the
 * values of this structure should be regarded as read-only, with the exception
 * of the line field, whose access is described in depth in the "Direct access
 * to video memory" section of the manual. If you want to modify the clipping
 * region, please refrain from changing this structure. Use set_clip_rect
 * instead.
 */
VALUE cBITMAP;

/*
 * call-seq:
 *   bmp.h -> int
 *
 * Returns the height of the BITMAP in pixels.
 */
VALUE a4r_BITMAP_h_get(VALUE self)
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
VALUE a4r_BITMAP_w_get(VALUE self)
{
  BITMAP *bitmap;
  Data_Get_Struct(self, BITMAP, bitmap);
  return INT2FIX(bitmap->w);
}
