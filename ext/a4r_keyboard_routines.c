#include "allegro4r.h"

VALUE a4r_install_keyboard(VALUE self)
{
  return INT2FIX(install_keyboard());
}

VALUE a4r_keypressed(VALUE self)
{
  return keypressed() ? Qtrue : Qfalse;
}

VALUE a4r_readkey(VALUE self)
{
  return INT2FIX(readkey());
}

VALUE a4r_clear_keybuf(VALUE self)
{
  clear_keybuf();
  return Qnil;
}
