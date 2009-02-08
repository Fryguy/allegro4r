#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE al_screen(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  BITMAP *bmp = screen;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE al_SCREEN_W(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_W);
}

static VALUE al_SCREEN_H(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_H);
}

static VALUE al_create_bitmap(VALUE self, VALUE width, VALUE height)
{
  // TODO: Change to call destroy_bitmap on free?
  BITMAP *bmp = create_bitmap(FIX2INT(width), FIX2INT(height));
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE al_destroy_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  destroy_bitmap(bmp);
  return Qnil;
}

static VALUE al_acquire_screen(VALUE self)
{
  acquire_screen();
  return Qnil;
}

static VALUE al_release_screen(VALUE self)
{
  release_screen();
  return Qnil;
}
