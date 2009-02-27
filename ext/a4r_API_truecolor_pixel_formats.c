#include "allegro4r.h"

/*
 * call-seq:
 *   make_col(r, g, b) -> a_rgb
 *
 * Converts colors from a hardware independent format (red, green, and blue
 * values ranging 0-255) to the pixel format required by the current video mode,
 * calling the preceding 8, 15, 16, 24, or 32-bit makecol functions as
 * appropriate. Example:
 *   # Regardless of color depth, this will look green.
 *   green_color = makecol(0, 255, 0)
 *
 * Return value: Returns the requested RGB triplet in the current color depth.
 */
VALUE a4r_API_makecol(VALUE self, VALUE r, VALUE g, VALUE b)
{
  return INT2FIX(makecol(FIX2INT(r), FIX2INT(g), FIX2INT(b)));
}

/*
 * call-seq:
 *   palette_color -> ary
 *
 * Table mapping palette index colors (0-255) into whatever pixel format is
 * being used by the current display mode. In a 256-color mode this just maps
 * onto the array index. In truecolor modes it looks up the specified entry in
 * the current palette, and converts that RGB value into the appropriate packed
 * pixel format. Example:
 *   set_color_depth(32)
 *   ...
 *   set_palette(desktop_palette)
 *   # Put a pixel with the color 2 (green) of the palette
 *   putpixel(screen, 100, 100, palette_color[2])
 */
VALUE a4r_API_palette_color(VALUE self)
{
  // TODO: Cache the array, and only update if changed, or use hooked variable?
  VALUE ary = rb_ary_new2(PAL_SIZE);
  int x;
  for (x = 0; x < PAL_SIZE; x++)
    rb_ary_store(ary, x, INT2FIX(pallete_color[x]));
  return ary;
}
