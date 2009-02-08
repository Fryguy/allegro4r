#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_font(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  FONT *fnt = font;
  VALUE obj = Data_Wrap_Struct(cFONT, 0, 0, fnt);
  return obj;
}

static VALUE a4r_textout_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textout_centre_ex(b, fnt, StringValuePtr(s), FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg));
  return Qnil;
}
