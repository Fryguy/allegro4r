#include "allegro4r.h"

VALUE a4r_allegro_init(VALUE self)
{
  return INT2FIX(allegro_init());
}

VALUE a4r_allegro_exit(VALUE self)
{
  allegro_exit();
  return Qnil;
}

VALUE a4r_allegro_error(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return rb_str_new2(allegro_error);
}

VALUE a4r_allegro_message(VALUE self, VALUE text)
{
  // TODO: Allow parameter possing a lo printf for direct API consistency or force string only?
  allegro_message(StringValuePtr(text));
  return Qnil;
}
