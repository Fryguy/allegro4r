#include "allegro4r.h"

/*
 * call-seq:
 *   bmp_select(bmp) -> nil
 *
 */
VALUE a4r_API_bmp_select(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  bmp_select(bmp);
  return Qnil;
}

/*
 * call-seq:
 *   bmp_read8(addr) -> str
 *
 */
VALUE a4r_API_bmp_read8(VALUE self, VALUE addr)
{
  return rb_str_new((char*)&(bmp_read8(NUM2ULONG(addr))), sizeof(uint8_t));
}

/*
 * call-seq:
 *   bmp_read32(addr) -> str
 *
 */
VALUE a4r_API_bmp_read32(VALUE self, VALUE addr)
{
  return rb_str_new((char*)&(bmp_read32(NUM2ULONG(addr))), sizeof(uint32_t));
}

/*
 * call-seq:
 *   bmp_write8(addr, c) -> nil
 *
 */
VALUE a4r_API_bmp_write8(VALUE self, VALUE addr, VALUE c)
{
  bmp_write8(NUM2ULONG(addr), *((uint8_t*)StringValuePtr(c)));
  return Qnil;
}

/*
 * call-seq:
 *   bmp_write32(addr, c) -> nil
 *
 */
VALUE a4r_API_bmp_write32(VALUE self, VALUE addr, VALUE c)
{
  bmp_write32(NUM2ULONG(addr), *((uint32_t*)StringValuePtr(c)));
  return Qnil;
}

/*
 * call-seq:
 *   bmp_write_line(bmp, line) -> num
 *
 * Selects the line of a bitmap that you are going to draw onto.
 *
 * Return value: Returns the address of the selected line for writing.
 */
VALUE a4r_API_bmp_write_line(VALUE self, VALUE bmp, VALUE line)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return ULONG2NUM(bmp_write_line(bitmap, FIX2INT(line)));
}

/*
 * call-seq:
 *   bmp_read_line(bmp, line) -> num
 *
 * Selects the line of a bitmap that you are going to read from.
 *
 * Return value: Returns the address of the selected line for reading.
 */
VALUE a4r_API_bmp_read_line(VALUE self, VALUE bmp, VALUE line)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return ULONG2NUM(bmp_read_line(bitmap, FIX2INT(line)));
}

/*
 * call-seq:
 *   bmp_unwrite_line(bmp, line) -> nil
 *
 * Releases the bitmap memory after you are finished with it. You only need to
 * call this once at the end of a drawing operation, even if you have called
 * bmp_write_line or bmp_read_line several times before it.
 */
VALUE a4r_API_bmp_unwrite_line(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  bmp_unwrite_line(bitmap);
  return Qnil;
}
