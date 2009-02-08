#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

static VALUE a4r_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height)
{
  BITMAP *bmp_source, *bmp_dest;
  Data_Get_Struct(source, BITMAP, bmp_source);
  Data_Get_Struct(dest, BITMAP, bmp_dest);
  blit(bmp_source, bmp_dest, FIX2INT(source_x), FIX2INT(source_y), FIX2INT(dest_x), FIX2INT(dest_y), FIX2INT(width), FIX2INT(height));
  return Qnil;
}

static VALUE a4r_masked_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height)
{
  BITMAP *bmp_source, *bmp_dest;
  Data_Get_Struct(source, BITMAP, bmp_source);
  Data_Get_Struct(dest, BITMAP, bmp_dest);
  masked_blit(bmp_source, bmp_dest, FIX2INT(source_x), FIX2INT(source_y), FIX2INT(dest_x), FIX2INT(dest_y), FIX2INT(width), FIX2INT(height));
  return Qnil;
}
