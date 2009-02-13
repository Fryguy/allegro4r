#include "allegro4r.h"

VALUE a4r_bmp_select(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  bmp_select(bmp);
  return Qnil;
}

VALUE a4r_bmp_read8(VALUE self, VALUE addr)
{
  return rb_str_new((char*)&(bmp_read8(NUM2ULONG(addr))), sizeof(uint8_t));
}

VALUE a4r_bmp_read32(VALUE self, VALUE addr)
{
  return rb_str_new((char*)&(bmp_read32(NUM2ULONG(addr))), sizeof(uint32_t));
}

VALUE a4r_bmp_write8(VALUE self, VALUE addr, VALUE c)
{
  bmp_write8(NUM2ULONG(addr), *((uint8_t*)StringValuePtr(c)));
  return Qnil;
}

VALUE a4r_bmp_write32(VALUE self, VALUE addr, VALUE c)
{
  bmp_write32(NUM2ULONG(addr), *((uint32_t*)StringValuePtr(c)));
  return Qnil;
}

VALUE a4r_bmp_write_line(VALUE self, VALUE bmp, VALUE line)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return ULONG2NUM(bmp_write_line(bitmap, FIX2INT(line)));
}

VALUE a4r_bmp_read_line(VALUE self, VALUE bmp, VALUE line)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return ULONG2NUM(bmp_read_line(bitmap, FIX2INT(line)));
}

VALUE a4r_bmp_unwrite_line(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  bmp_unwrite_line(bitmap);
  return Qnil;
}
