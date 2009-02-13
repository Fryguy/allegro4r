#include "allegro4r.h"

VALUE a4r_load_font(VALUE self, VALUE filename, VALUE pal, VALUE param)
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

  VALUE obj = Data_Wrap_Struct(cFONT, 0, 0, font);
  return obj;
}

VALUE a4r_destroy_font(VALUE self, VALUE f)
{
  FONT *font;
  Data_Get_Struct(f, FONT, font);
  destroy_font(font);
  return Qnil;
}

VALUE a4r_extract_font_range(VALUE self, VALUE f, VALUE begin, VALUE end)
{
  FONT *from, *to;
  Data_Get_Struct(f, FONT, from);
  to = extract_font_range(from, FIX2INT(begin), FIX2INT(end));
  VALUE obj = Data_Wrap_Struct(cFONT, 0, 0, to);
  return obj;
}

VALUE a4r_merge_fonts(VALUE self, VALUE f1, VALUE f2)
{
  FONT *font1, *font2, *ret;
  Data_Get_Struct(f1, FONT, font1);
  Data_Get_Struct(f2, FONT, font2);
  ret = merge_fonts(font1, font2);
  VALUE obj = Data_Wrap_Struct(cFONT, 0, 0, ret);
  return obj;
}
