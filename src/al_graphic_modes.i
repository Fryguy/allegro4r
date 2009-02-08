#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_set_gfx_mode(VALUE self, VALUE card, VALUE w, VALUE h, VALUE v_w, VALUE v_h)
{
  return INT2FIX(set_gfx_mode(NUM2INT(card), FIX2INT(w), FIX2INT(h), FIX2INT(v_w), FIX2INT(v_h)));
}
