#include "allegro4r.h"

VALUE cRGB;

void a4r_RGB_free(void *rgb)
{
  free((RGB*)rgb);
}

VALUE a4r_RGB_alloc(VALUE klass)
{
  RGB *rgb;
  VALUE obj = Data_Make_Struct(klass, RGB, 0, a4r_RGB_free, rgb);
  return obj;
}

VALUE a4r_RGB_initialize_copy(VALUE copy, VALUE orig)
{
  if (copy == orig)
    return copy;

  // TODO: Bring back this check.  We do Data_Wrap_Structs in other places,
  //   which is causing this to have two structs with different free methods
/*
  if (TYPE(orig) != T_DATA || RDATA(orig)->dfree != (RUBY_DATA_FUNC)a4r_RGB_free)
    rb_raise(rb_eTypeError, "wrong argument type");
*/

  RGB *orig_rgb, *copy_rgb;
  Data_Get_Struct(orig, RGB, orig_rgb);
  Data_Get_Struct(copy, RGB, copy_rgb);
  MEMCPY(copy_rgb, orig_rgb, RGB, 1);
  return copy;
}

VALUE a4r_RGB_r_get(VALUE self)
{
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->r);
}

VALUE a4r_RGB_r_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->r = NUM2CHR(val);
  return val;
}

VALUE a4r_RGB_g_get(VALUE self)
{
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->g);
}

VALUE a4r_RGB_g_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->g = NUM2CHR(val);
  return val;
}

VALUE a4r_RGB_b_get(VALUE self)
{
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->b);
}

VALUE a4r_RGB_b_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->b = NUM2CHR(val);
  return val;
}
