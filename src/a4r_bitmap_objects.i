#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_screen(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  BITMAP *bmp = screen;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE a4r_SCREEN_W(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_W);
}

static VALUE a4r_SCREEN_H(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_H);
}

static VALUE a4r_create_bitmap(VALUE self, VALUE width, VALUE height)
{
  // TODO: Change to call destroy_bitmap on free?
  BITMAP *bmp = create_bitmap(FIX2INT(width), FIX2INT(height));
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE a4r_create_sub_bitmap(VALUE self, VALUE parent, VALUE x, VALUE y, VALUE width, VALUE height)
{
  BITMAP *bmp;
  Data_Get_Struct(parent, BITMAP, bmp);
  BITMAP *ret = create_sub_bitmap(bmp, FIX2INT(x), FIX2INT(y), FIX2INT(width), FIX2INT(height));
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, ret);
  return obj;
}

static VALUE a4r_destroy_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  destroy_bitmap(bmp);
  return Qnil;
}

static VALUE a4r_bitmap_mask_color(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return INT2FIX(bitmap_mask_color(bitmap));
}

static VALUE a4r_acquire_bitmap(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  acquire_bitmap(bitmap);
  return Qnil;
}

static VALUE a4r_release_bitmap(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  release_bitmap(bitmap);
  return Qnil;
}

static VALUE a4r_acquire_screen(VALUE self)
{
  acquire_screen();
  return Qnil;
}

static VALUE a4r_release_screen(VALUE self)
{
  release_screen();
  return Qnil;
}
