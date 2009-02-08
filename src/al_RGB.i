#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static void al_RGB_free(void *rgb)
{
  free((RGB*)rgb);
}

static VALUE al_RGB_alloc(VALUE klass)
{
  RGB *rgb;
  VALUE obj = Data_Make_Struct(klass, RGB, 0, al_RGB_free, rgb);
  return obj;
}

static VALUE al_RGB_initialize_copy(VALUE copy, VALUE orig)
{
  if (copy == orig)
    return copy;

  // TODO: Bring back this check.  We do Data_Wrap_Structs in other places,
  //   which is causing this to have two structs with different free methods
/*
  if (TYPE(orig) != T_DATA || RDATA(orig)->dfree != (RUBY_DATA_FUNC)al_RGB_free)
    rb_raise(rb_eTypeError, "wrong argument type");
*/

  RGB *orig_rgb, *copy_rgb;
  Data_Get_Struct(orig, RGB, orig_rgb);
  Data_Get_Struct(copy, RGB, copy_rgb);
  MEMCPY(copy_rgb, orig_rgb, RGB, 1);
  return copy;
}

static VALUE al_RGB_r_get(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->r);
}

static VALUE al_RGB_r_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->r = NUM2CHR(val);
  return val;
}

static VALUE al_RGB_g_get(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->g);
}

static VALUE al_RGB_g_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->g = NUM2CHR(val);
  return val;
}

static VALUE al_RGB_b_get(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  return CHR2FIX(rgb->b);
}

static VALUE al_RGB_b_set(VALUE self, VALUE val)
{
  // TODO: val validation
  RGB *rgb;
  Data_Get_Struct(self, RGB, rgb);
  rgb->b = NUM2CHR(val);
  return val;
}
