#include "allegro4r.h"

/*
 * call-seq:
 *   font -> a_fnt
 *
 * A simple 8x8 fixed size font (the mode 13h BIOS default). If you want to
 * alter the font used by the GUI routines, change this to point to one of your
 * own fonts. This font contains the standard ASCII (U+20 to U+7F), Latin-1
 * (U+A1 to U+FF), and Latin Extended-A (U+0100 to U+017F) character ranges.
 */
VALUE a4r_API_font(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  FONT *fnt = font;
  VALUE obj = Data_Wrap_Struct(cAPI_FONT, 0, 0, fnt);
  return obj;
}

/*
 * call-seq:
 *   font = fnt -> fnt
 *
 * See font.
 */
VALUE a4r_API_font_set(VALUE self, VALUE f)
{
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  font = fnt;
  return f;
}

/*
 * call-seq:
 *   text_length(f, str) -> int
 *
 * Returns the length (in pixels) of a string in the specified font. Example:
 *   width = text_length(font, "I love spam")
 *   ...
 *   bmp = create_bitmap(width, height)
 */
VALUE a4r_API_text_length(VALUE self, VALUE f, VALUE str)
{
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  return INT2FIX(text_length(fnt, StringValuePtr(str)));
}

/*
 * call-seq:
 *   text_height(f) -> int
 *
 * Returns the height (in pixels) of the specified font. Example:
 *   height = text_height(font)
 *   ...
 *   bmp = create_bitmap(width, height)
 */
VALUE a4r_API_text_height(VALUE self, VALUE f)
{
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  return INT2FIX(text_height(fnt));
}

/*
 * call-seq:
 *   textout_ex(bmp, f, s, x, y, color, bg) -> nil
 *
 * Writes the string 's' onto the bitmap at position x, y, using the specified
 * font, foreground color and background color. If the background color is -1,
 * then the text is written transparently. If the foreground color is -1 and a
 * color font is in use, it will be drawn using the colors from the original
 * font bitmap (the one you imported into the grabber program), which allows
 * multicolored text output. For high and true color fonts, the foreground color
 * is ignored and always treated as -1. Example:
 *   # Show the program's version in blue letters.
 *   textout_ex(screen, font, "v4.2.0-beta2", 10, 10,
 *              makecol(0, 0, 255), -1)
 */
VALUE a4r_API_textout_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textout_ex(b, fnt, StringValuePtr(s), FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg));
  return Qnil;
}

/*
 * call-seq:
 *   textout_centre_ex(bmp, f, s, x, y, color, bg) -> nil
 *
 * Like textout_ex, but interprets the x coordinate as the centre rather than
 * the left edge of the string. Example:
 *   # Important texts go in the middle.
 *   width = text_length("GAME OVER")
 *   textout_centre_ex(screen, font, "GAME OVER",
 *                     SCREEN_W / 2, SCREEN_H / 2,
 *                     makecol(255, 0, 0), makecol(0, 0, 0))
 */
VALUE a4r_API_textout_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textout_centre_ex(b, fnt, StringValuePtr(s), FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg));
  return Qnil;
}

/*
 * call-seq:
 *   textprintf_ex(bmp, f, x, y, color, by, fmt) -> nil
 *
 * Formatted text output, using a printf style format string. Due to an internal
 * limitation, this function can't be used for extremely long texts. If you
 * happen to reach this limit, you can work around it by using uszprintf and
 * textout_ex, which don't have any. Example:
 *   textprintf_ex(screen, font, 10, 10, makecol(255, 100, 200),
 *                 -1, "Score: %d" % player_score)
 */
VALUE a4r_API_textprintf_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt)
{
  // TODO: Make this actually work like printf with arbitrary number of parameters
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textprintf_ex(b, fnt, FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg), StringValuePtr(fmt));
  return Qnil;
}

/*
 * call-seq:
 *   textprintf_centre_ex(bmp, f, x, y, color, bg, fmt) -> nil
 *
 * Like textprintf_ex, but interprets the x coordinate as the centre rather than
 * the left edge of the string. This function shares the text length limitation
 * of textprintf_ex. Example:
 *   textprintf_centre_ex(screen, font, SCREEN_W / 2, 120,
 *                        makecol(0, 100, 243), -1,
 *                        "Your best score so far was %d!" %
 *                        total_max_points)
 */
VALUE a4r_API_textprintf_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt)
{
  // TODO: Make this actually work like printf with arbitrary number of parameters
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textprintf_centre_ex(b, fnt, FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg), StringValuePtr(fmt));
  return Qnil;
}

/*
 * call-seq:
 *   textprintf_right_ex(bmp, f, x, y, color, bg, fmt) -> nil
 *
 * Like textprintf_ex, but interprets the x coordinate as the right rather than
 * the left edge of the string. This function shares the text length limitation
 * of textprintf_ex. Example:
 *   textprintf_right_ex(screen, font, SCREEN_W - 10, 10,
 *                       makecol(200, 200, 20), -1,
 *                       "%d bullets left" % player_ammo)
 */
VALUE a4r_API_textprintf_right_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt)
{
  // TODO: Make this actually work like printf with arbitrary number of parameters
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textprintf_right_ex(b, fnt, FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg), StringValuePtr(fmt));
  return Qnil;
}
