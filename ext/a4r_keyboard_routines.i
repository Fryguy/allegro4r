#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_install_keyboard(VALUE self)
{
  return INT2FIX(install_keyboard());
}

static VALUE a4r_keypressed(VALUE self)
{
  return keypressed() ? Qtrue : Qfalse;
}

static VALUE a4r_readkey(VALUE self)
{
  return INT2FIX(readkey());
}

static VALUE a4r_clear_keybuf(VALUE self)
{
  clear_keybuf();
  return Qnil;
}
