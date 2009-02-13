#include "allegro4r.h"

VALUE a4r_makecol(VALUE self, VALUE r, VALUE g, VALUE b)
{
  return INT2FIX(makecol(FIX2INT(r), FIX2INT(g), FIX2INT(b)));
}

VALUE a4r_palette_color(VALUE self)
{
  // TODO: Cache the array, and only update if changed, or use hooked variable?
  VALUE ary = rb_ary_new2(PAL_SIZE);
  int x;
  for (x = 0; x < PAL_SIZE; x++)
    rb_ary_store(ary, x, INT2FIX(pallete_color[x]));
  return ary;
}
