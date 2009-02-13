#include "allegro4r.h"

VALUE a4r_itofix(VALUE self, VALUE x)
{
  return LONG2NUM(itofix(FIX2INT(x)));
}

VALUE a4r_ftofix(VALUE self, VALUE x)
{
  return LONG2NUM(ftofix(NUM2DBL(x)));
}

VALUE a4r_fixtof(VALUE self, VALUE x)
{
  return rb_float_new(fixtof(NUM2LONG(x)));
}

VALUE a4r_fixmul(VALUE self, VALUE x, VALUE y)
{
  return rb_float_new(fixmul(NUM2LONG(x), NUM2LONG(y)));
}

VALUE a4r_fixsqrt(VALUE self, VALUE x)
{
  return rb_float_new(fixsqrt(NUM2LONG(x)));
}
