#include "allegro4r.h"

/*
 * call-seq:
 *   drawing_mode(mode, pattern, x_anchor, y_anchor) -> nil
 *
 * Sets the graphics drawing mode. This only affects the geometric routines like
 * putpixel, lines, rectangles, circles, polygons, floodfill, etc, not the text
 * output, blitting, or sprite drawing functions. The mode should be one of the
 * following constants:
 *   DRAW_MODE_SOLID               - the default, solid color drawing
 *   DRAW_MODE_XOR                 - exclusive-or drawing
 *   DRAW_MODE_COPY_PATTERN        - multicolored pattern fill
 *   DRAW_MODE_SOLID_PATTERN       - single color pattern fill
 *   DRAW_MODE_MASKED_PATTERN      - masked pattern fill
 *   DRAW_MODE_TRANS               - translucent color blending
 *
 * In DRAW_MODE_SOLID, pixels of the bitmap being drawn onto are simply replaced
 * by those produced by the drawing function.
 *
 * In DRAW_MODE_XOR, pixels are written to the bitmap with an exclusive-or
 * operation rather than a simple copy, so drawing the same shape twice will
 * erase it. Because it involves reading as well as writing the bitmap memory,
 * xor drawing is a lot slower than the normal replace mode.
 *
 * With the patterned modes, you provide a pattern bitmap which is tiled across
 * the surface of the shape. Allegro stores a pointer to this bitmap rather than
 * copying it, so you must not destroy the bitmap while it is still selected as
 * the pattern. The width and height of the pattern must be powers of two, but
 * they can be different, eg. a 64x16 pattern is fine, but a 17x3 one is not.
 * The pattern is tiled in a grid starting at point (x_anchor, y_anchor).
 * Normally you should just pass zero for these values, which lets you draw
 * several adjacent shapes and have the patterns meet up exactly along the
 * shared edges. Zero alignment may look peculiar if you are moving a patterned
 * shape around the screen, however, because the shape will move but the pattern
 * alignment will not, so in some situations you may wish to alter the anchor
 * position.
 *
 * When you select DRAW_MODE_COPY_PATTERN, pixels are simply copied from the
 * pattern bitmap onto the destination bitmap. This allows the use of
 * multicolored patterns, and means that the color you pass to the drawing
 * routine is ignored. This is the fastest of the patterned modes.
 *
 * In DRAW_MODE_SOLID_PATTERN, each pixel in the pattern bitmap is compared with
 * the mask color, which is zero in 256-color modes or bright pink for truecolor
 * data (maximum red and blue, zero green). If the pattern pixel is solid, a
 * pixel of the color you passed to the drawing routine is written to the
 * destination bitmap, otherwise a zero is written. The pattern is thus treated
 * as a monochrome bitmask, which lets you use the same pattern to draw
 * different shapes in different colors, but prevents the use of multicolored
 * patterns.
 *
 * DRAW_MODE_MASKED_PATTERN is almost the same as DRAW_MODE_SOLID_PATTERN, but
 * the masked pixels are skipped rather than being written as zeros, so the
 * background shows through the gaps.
 *
 * In DRAW_MODE_TRANS, the global color_map table or truecolor blender functions
 * are used to overlay pixels on top of the existing image. This must only be
 * used after you have set up the color mapping table (for 256 color modes) or
 * blender functions (for truecolor modes). Because it involves reading as well
 * as writing the bitmap memory, translucent drawing is very slow if you draw
 * directly to video RAM, so wherever possible you should use a memory bitmap
 * instead.
 */
VALUE a4r_drawing_mode(VALUE self, VALUE mode, VALUE pattern, VALUE x_anchor, VALUE y_anchor)
{
  BITMAP *bitmap;
  Data_Get_Struct(pattern, BITMAP, bitmap);
  drawing_mode(FIX2INT(mode), bitmap, FIX2INT(x_anchor), FIX2INT(y_anchor));
  return Qnil;
}

/*
 * call-seq:
 *   solid_mode -> nil
 *
 * This is a shortcut for selecting solid drawing mode. It is equivalent to
 * calling drawing_mode(DRAW_MODE_SOLID, nil, 0, 0).
 */
VALUE a4r_solid_mode(VALUE self)
{
  solid_mode();
  return Qnil;
}
