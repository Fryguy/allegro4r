#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::PALETTE
 *
 * Allegro palettes are arrays of PAL_SIZE RGB entries.
 */
VALUE cPALETTE;

void a4r_PALETTE_free(void *palette)
{
  free((PALETTE*)palette);
}

/* :nodoc: */
VALUE a4r_PALETTE_alloc(VALUE klass)
{
  PALETTE *palette;
  VALUE obj = Data_Make_Struct(klass, PALETTE, 0, a4r_PALETTE_free, palette);
  return obj;
}

/* :nodoc: */
VALUE a4r_PALETTE_initialize_copy(VALUE copy, VALUE orig)
{
  if (copy == orig)
    return copy;

  if (TYPE(orig) != T_DATA || RDATA(orig)->dfree != (RUBY_DATA_FUNC)a4r_PALETTE_free)
    rb_raise(rb_eTypeError, "wrong argument type");

  PALETTE *orig_pal, *copy_pal;
  Data_Get_Struct(orig, PALETTE, orig_pal);
  Data_Get_Struct(copy, PALETTE, copy_pal);
  MEMCPY(copy_pal, orig_pal, PALETTE, 1);
  return copy;
}

/*
 * call-seq:
 *   palette[index] -> an_rgb
 *
 * Returns the RGB element at the specified index.
 */
VALUE a4r_PALETTE_getter(VALUE self, VALUE index)
{
  // TODO: Index validation && converting to "array" of RGBs
  PALETTE *palette;
  Data_Get_Struct(self, PALETTE, palette);
  RGB *rgb = &((*palette)[FIX2INT(index)]);
  VALUE obj = Data_Wrap_Struct(cRGB, 0, 0, rgb);
  return obj;
}

/*
 * call-seq:
 *   palette[index] = an_rgb -> an_rgb
 *
 * Sets the element at index to the specified RGB element.
 */
VALUE a4r_PALETTE_setter(VALUE self, VALUE index, VALUE val)
{
  // TODO: Index validation, val validation && converting to "array" of RGBs
  PALETTE *palette;
  Data_Get_Struct(self, PALETTE, palette);
  RGB *rgb;
  Data_Get_Struct(val, RGB, rgb);
  (*palette)[FIX2INT(index)] = *rgb;
  return val;
}
