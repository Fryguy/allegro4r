#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_install_keyboard(VALUE self)
{
  return INT2FIX(install_keyboard());
}

static VALUE al_keypressed(VALUE self)
{
  return keypressed() ? Qtrue : Qfalse;
}

static VALUE al_readkey(VALUE self)
{
  return INT2FIX(readkey());
}
