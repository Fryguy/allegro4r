#include "allegro4r.h"

/*
 * call-seq:
 *   blit(source, dest, source_x, source_y, dest_x, dest_y, width, height) -> nil
 *
 * Copies a rectangular area of the source bitmap to the destination bitmap. The
 * source_x and source_y parameters are the top left corner of the area to copy
 * from the source bitmap, and dest_x and dest_y are the corresponding position
 * in the destination bitmap. This routine respects the destination clipping
 * rectangle, and it will also clip if you try to blit from areas outside the
 * source bitmap. Example:
 *   # Blit src on the screen.
 *   blit(bmp, screen, 0, 0, 0, 0, bmp.w, bmp.h)
 *
 *   # Now copy a chunk to a corner, slightly outside.
 *   blit(screen, screen, 100, 100, -10, -10, 25, 30)
 *
 * You can blit between any parts of any two bitmaps, even if the two memory
 * areas overlap (ie. source and dest are the same, or one is sub-bitmap of the
 * other). You should be aware, however, that a lot of SVGA cards don't provide
 * separate read and write banks, which means that blitting from one part of the
 * screen to another requires the use of a temporary bitmap in memory, and is
 * therefore extremely slow. As a general rule you should avoid blitting from
 * the screen onto itself in SVGA modes.
 *
 * In mode-X, on the other hand, blitting from one part of the screen to another
 * can be significantly faster than blitting from memory onto the screen, as
 * long as the source and destination are correctly aligned with each other.
 * Copying between overlapping screen rectangles is slow, but if the areas
 * don't overlap, and if they have the same plane alignment (ie. (source_x%4) ==
 * (dest_x%4)), the VGA latch registers can be used for a very fast data
 * transfer. To take advantage of this, in mode-X it is often worth storing
 * tile graphics in a hidden area of video memory (using a large virtual
 * screen), and blitting them from there onto the visible part of the screen.
 *
 * If the GFX_HW_VRAM_BLIT bit in the gfx_capabilities flag is set, the current
 * driver supports hardware accelerated blits from one part of the screen onto
 * another. This is extremely fast, so when this flag is set it may be worth
 * storing some of your more frequently used graphics in an offscreen portion of
 * the video memory.
 *
 * Unlike most of the graphics routines, blit allows the source and destination
 * bitmaps to be of different color depths, so it can be used to convert images
 * from one pixel format to another. In this case, the behavior is affected by
 * the COLORCONV_KEEP_TRANS and COLORCONV_DITHER* flags of the current color
 * conversion mode: see set_color_conversion for more information.
 */
VALUE a4r_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height)
{
  BITMAP *bmp_source, *bmp_dest;
  Data_Get_Struct(source, BITMAP, bmp_source);
  Data_Get_Struct(dest, BITMAP, bmp_dest);
  blit(bmp_source, bmp_dest, FIX2INT(source_x), FIX2INT(source_y), FIX2INT(dest_x), FIX2INT(dest_y), FIX2INT(width), FIX2INT(height));
  return Qnil;
}

/*
 * call-seq:
 *   masked_blit(source, dest, source_x, source_y, dest_x, dest_y, width, height) -> nil
 *
 * Like blit, but skips transparent pixels, which are marked by a zero in
 * 256-color modes or bright pink for truecolor data (maximum red and blue, zero
 * green), and requires the source and destination bitmaps to be of the same
 * color depth. The source and destination regions must not overlap. Example:
 *   # Paint hud overlay on the screen.
 *   masked_blit(hud_overlay, screen, 0, 0, 0, 0, hud_overlay.w, hud_overlay.h)
 *
 * If the GFX_HW_VRAM_BLIT_MASKED bit in the gfx_capabilities flag is set, the
 * current driver supports hardware accelerated masked blits from one part of
 * the screen onto another. This is extremely fast, so when this flag is set it
 * may be worth storing some of your more frequently used sprites in an
 * offscreen portion of the video memory.
 *
 * Warning: if the hardware acceleration flag is not set, masked_blit will not
 * work correctly when used with a source image in system or video memory so the
 * latter must be a memory bitmap.
 */
VALUE a4r_masked_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height)
{
  BITMAP *bmp_source, *bmp_dest;
  Data_Get_Struct(source, BITMAP, bmp_source);
  Data_Get_Struct(dest, BITMAP, bmp_dest);
  masked_blit(bmp_source, bmp_dest, FIX2INT(source_x), FIX2INT(source_y), FIX2INT(dest_x), FIX2INT(dest_y), FIX2INT(width), FIX2INT(height));
  return Qnil;
}
