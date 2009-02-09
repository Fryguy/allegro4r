#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_MIN(VALUE self, VALUE x, VALUE y)
{
  return INT2NUM(MIN(NUM2INT(x), NUM2INT(y)));
}

static VALUE a4r_ABS(VALUE self, VALUE x)
{
  return INT2NUM(ABS(NUM2INT(x)));
}

static VALUE a4r_AL_RAND(VALUE self)
{
  return INT2NUM(AL_RAND());
}
