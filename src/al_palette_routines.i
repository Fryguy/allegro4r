#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_set_palette(VALUE self, VALUE p)
{
  // TODO: Check data type of palette?
  PALETTE *pal;
  Data_Get_Struct(p, PALETTE, pal);
  set_palette(*pal);
  return Qnil;
}

static VALUE al_get_palette(VALUE self, VALUE p)
{
  // TODO: Check data type of p?
  PALETTE *pal;
  Data_Get_Struct(p, PALETTE, pal);
  get_palette(*pal);
  return Qnil;
}

static VALUE al_black_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &black_palette;
  VALUE obj = Data_Wrap_Struct(cPALETTE, 0, 0, pal);
  return obj;
}

static VALUE al_desktop_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &desktop_palette;
  VALUE obj = Data_Wrap_Struct(cPALETTE, 0, 0, pal);
  return obj;
}
