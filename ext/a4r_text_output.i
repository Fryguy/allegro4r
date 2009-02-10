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

static VALUE a4r_text_length(VALUE self, VALUE f, VALUE str)
{
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  return INT2FIX(text_length(fnt, StringValuePtr(str)));
}

static VALUE a4r_text_height(VALUE self, VALUE f)
{
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  return INT2FIX(text_height(fnt));
}

static VALUE a4r_textout_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textout_ex(b, fnt, StringValuePtr(s), FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg));
  return Qnil;
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

static VALUE a4r_textprintf_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt)
{
  // TODO: Make this actually work like printf with arbitrary number of parameters
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textprintf_ex(b, fnt, FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg), StringValuePtr(fmt));
  return Qnil;
}
