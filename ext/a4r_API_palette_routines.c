#include "allegro4r.h"

/*
 * call-seq:
 *   set_palette(p) -> nil
 *
 * Sets the entire palette of 256 colors. You should provide an array of 256 RGB
 * structures. Unlike set_color, there is no need to call vsync before this
 * function. Example:
 *   palette = PALETTE.new
 *   ...
 *   bmp = load_bitmap(filename, palette)
 *   abort_on_error("Couldn't load bitmap!") if bmp.nil?
 *   set_palette(palette)
 */
VALUE a4r_API_set_palette(VALUE self, VALUE p)
{
  // TODO: Check data type of palette? Also, allow array of 256 RGBs
  PALETTE *pal;
  Data_Get_Struct(p, PALETTE, pal);
  set_palette(*pal);
  return Qnil;
}

/*
 * call_seq:
 *   get_palette(p) -> nil
 *
 * Retrieves the entire palette of 256 colors. You should provide an array of
 * 256 RGB structures to store it in. Example:
 *   pal = PALETTE.new
 *   ...
 *   get_palette(pal)
 */
VALUE a4r_API_get_palette(VALUE self, VALUE p)
{
  // TODO: Check data type of p?
  PALETTE *pal;
  Data_Get_Struct(p, PALETTE, pal);
  get_palette(*pal);
  return Qnil;
}

/*
 * call-seq:
 *   default_palette -> pal
 *
 * The default IBM BIOS palette. This will be automatically selected whenever
 * you set a new graphics mode. The palette contains 16 basic colors plus many
 * gradients between them. If you want to see the values, you can write a small
 * Allegro program which saves a screenshot with this palette, or open the
 * grabber tool provided with Allegro and create a new palette object, which
 * will use this palette by default.
 */
VALUE a4r_API_default_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &default_palette;
  VALUE obj = Data_Wrap_Struct(cAPI_PALETTE, 0, 0, pal);
  return obj;
}

/*
 * call-seq:
 *   black_palette -> pal
 *
 * A palette containing solid black colors, used by the fade routines.
 */
VALUE a4r_API_black_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &black_palette;
  VALUE obj = Data_Wrap_Struct(cAPI_PALETTE, 0, 0, pal);
  return obj;
}

/*
 * call-seq:
 *   desktop_palette -> pal
 *
 * The palette used by the Atari ST low resolution desktop. I'm not quite sure
 * why this is still here, except that the grabber and test programs use it. It
 * is probably the only Atari legacy code left in Allegro, and it would be a
 * shame to remove it :-)
 *
 * The contents of this palette are 16 colors repeated 16 times. Color entry
 * zero is equal to color entry 16, which is equal to color entry 24, etc.
 *   Index      Color       RGB values
 *     0     White          63  63  63
 *     1     Red            63   0   0
 *     2     Green           0  63   0
 *     3     Yellow         63  63   0
 *     4     Blue            0   0  63
 *     5     Pink           63   0  63
 *     6     Cyan            0  63  63
 *     7     Grey           16  16  16
 *     8     Light grey     31  31  31
 *     9     Light red      63  31  31
 *    10     Light green    31  63  31
 *    11     Light yellow   63  63  31
 *    12     Light blue     31  31  63
 *    13     Light pink     63  31  63
 *    14     Light cyan     31  63  63
 *    15     Black           0   0   0
 */
VALUE a4r_API_desktop_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &desktop_palette;
  VALUE obj = Data_Wrap_Struct(cAPI_PALETTE, 0, 0, pal);
  return obj;
}
