#include "allegro4r.h"

/*
 * call-seq:
 *   load_font(filename, pal, param) -> a_fnt or nil
 *
 * Loads a font from a file. At present, this supports loading fonts from a GRX
 * format .fnt file, a 8x8 or 8x16 BIOS format .fnt file, a datafile or any
 * bitmap format that can be loaded by load_bitmap.
 *
 * If the font contains palette information, then the palette is returned in the
 * second parameter, which should be an array of 256 RGB structures (a PALETTE).
 * The pal argument may be nil. In this case, the palette data, if present, is
 * simply not returned.
 *
 * The third parameter can be used to pass specific information to a custom
 * loader routine. Normally, you can just leave this as nil. Note that another
 * way of loading fonts is embedding them into a datafile and using the datafile
 * related functions.
 *
 * Example:
 *   myfont = load_font("my_font.pcx", palette, nil)
 *   abort_on_error("Couldn't load font!") if myfont.nil?
 *   ...
 *   textout_centre_ex(screen, myfont, "This is my own pretty font!",
 *     SCREEN_W / 2, SCREEN_H / 2, white, black)
 *   ...
 *   destroy_font(myfont)
 *
 * Returns a reference to the font or nil on error. Remember that you are
 * responsible for destroying the font when you are finished with it to avoid
 * memory leaks.
 */
VALUE a4r_API_load_font(VALUE self, VALUE filename, VALUE pal, VALUE param)
{
  PALETTE *palette;
  RGB *rgb;
  if (pal == Qnil)
    rgb = NULL;
  else
  {
    Data_Get_Struct(pal, PALETTE, palette);
    rgb = *palette;
  }

  void *p;
  if (param == Qnil)
    p = NULL;
  else
    p = StringValuePtr(param);

  FONT *font = load_font(StringValuePtr(filename), rgb, p);
  if (font == NULL)
    return Qnil;

  VALUE obj = Data_Wrap_Struct(cAPI_FONT, 0, 0, font);
  return obj;
}

/*
 * call-seq:
 *   destroy_font(f) -> nil
 *
 * Frees the memory being used by a font structure. Don't use this on the
 * default global Allegro font or any text routines using it could crash. You
 * should use this only on fonts you have loaded manually after you are done
 * with them, to prevent memory leaks in your program.
 */
VALUE a4r_API_destroy_font(VALUE self, VALUE f)
{
  FONT *font;
  Data_Get_Struct(f, FONT, font);
  destroy_font(font);
  return Qnil;
}

/*
 * call-seq:
 *   extract_font_range(f, begin, end) -> a_fnt or nil
 *
 * This function extracts a character range from a font and returns a new font
 * that contains only the range of characters selected by this function. You can
 * pass -1 for either the lower or upper bound if you want to select all
 * characters from the start or to the end of the font. Example:
 *   # Create a font of only capital letters
 *   capitals = extract_font_range(myfont, ?A, ?Z)
 *
 *   # Create a copy of the font
 *   fontcopy = extract_font_range(myfont, -1, -1)
 *   ...
 *   destroy_font(capitals)
 *   destroy_font(fontcopy)
 *
 * Returns a reference to the new font or nil on error. Remember that you are
 * responsible for destroying the font when you are finished with it to avoid
 * memory leaks.
 */
VALUE a4r_API_extract_font_range(VALUE self, VALUE f, VALUE begin, VALUE end)
{
  FONT *from, *to;
  Data_Get_Struct(f, FONT, from);
  to = extract_font_range(from, FIX2INT(begin), FIX2INT(end));
  if (to == NULL)
    return Qnil;
  VALUE obj = Data_Wrap_Struct(cAPI_FONT, 0, 0, to);
  return obj;
}

/*
 * call-seq:
 *   merge_fonts(f1, f2) -> a_fnt or nil
 *
 * This function merges the character ranges from two fonts and returns a new
 * font containing all characters in the old fonts. In general, you cannot merge
 * fonts of different types (eg, TrueType fonts and bitmapped fonts), but as a
 * special case, this function can promote a monochrome bitmapped font to a
 * color font and merge those. Example:
 *   # Create a font that contains the capatials from
 *   # the fancy font but other characters from myfont
 *   lower_range = extract_font_range(myfont, -1, ?A - 1)
 *   upper_range = extract_font_range(myfont, ?Z + 1, -1)
 *   capitals = extract_font_range(myfancy_font, ?A, ?Z)
 *
 *   tempfont = merge_fonts(lower_range, capitals)
 *   combined_font = merge_fonts(tempfont, upper_range);
 *
 *   # Clean up temporary fonts
 *   destroy_font(lower_range)
 *   destroy_font(upper_range)
 *   destroy_font(capitals)
 *   destroy_font(tempfont)
 *
 * Returns a reference to the new font or nil on error. Remember that you are
 * responsible for destroying the font when you are finished with it to avoid
 * memory leaks.
 */
VALUE a4r_API_merge_fonts(VALUE self, VALUE f1, VALUE f2)
{
  FONT *font1, *font2, *ret;
  Data_Get_Struct(f1, FONT, font1);
  Data_Get_Struct(f2, FONT, font2);
  ret = merge_fonts(font1, font2);
  if (ret == NULL)
    return Qnil;
  VALUE obj = Data_Wrap_Struct(cAPI_FONT, 0, 0, ret);
  return obj;
}
