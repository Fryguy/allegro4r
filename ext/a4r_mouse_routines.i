#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_install_mouse(VALUE self)
{
  return INT2FIX(install_mouse());
}

static VALUE a4r_poll_mouse(VALUE self)
{
  return INT2FIX(poll_mouse());
}

static VALUE a4r_mouse_x(VALUE self)
{
  return INT2FIX(mouse_x);
}

static VALUE a4r_mouse_y(VALUE self)
{
  return INT2FIX(mouse_y);
}

static VALUE a4r_mouse_z(VALUE self)
{
  return INT2FIX(mouse_z);
}

static VALUE a4r_mouse_w(VALUE self)
{
  return INT2FIX(mouse_w);
}

static VALUE a4r_mouse_b(VALUE self)
{
  return INT2FIX(mouse_b);
}

static VALUE a4r_show_mouse(VALUE self, VALUE bmp)
{
  BITMAP *b;
  if (bmp == Qnil)
    b = NULL;
  else
    Data_Get_Struct(bmp, BITMAP, b);
  show_mouse(b);
  return Qnil;
}

static VALUE a4r_get_mouse_mickeys(VALUE self)
{
  int x, y;
  get_mouse_mickeys(&x, &y);
  return rb_ary_new3(2, INT2FIX(x), INT2FIX(y));
}

static VALUE a4r_set_mouse_sprite(VALUE self, VALUE bmp)
{
  BITMAP *b;
  if (bmp == Qnil)
    b = NULL;
  else
    Data_Get_Struct(bmp, BITMAP, b);
  set_mouse_sprite(b);
  return Qnil;
}

static VALUE a4r_set_mouse_sprite_focus(VALUE self, VALUE x, VALUE y)
{
  set_mouse_sprite_focus(FIX2INT(x), FIX2INT(y));
  return Qnil;
}
