#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_set_gfx_mode(VALUE self, VALUE card, VALUE w, VALUE h, VALUE v_w, VALUE v_h)
{
  return INT2FIX(set_gfx_mode(NUM2INT(card), FIX2INT(w), FIX2INT(h), FIX2INT(v_w), FIX2INT(v_h)));
}

static VALUE a4r_show_video_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  return INT2FIX(show_video_bitmap(bmp));
}

static VALUE a4r_vsync(VALUE self)
{
  vsync();
  return Qnil;
}
