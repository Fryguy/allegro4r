/*     ______   ___    ___                               __ __
 *    /\  _  \ /\_ \  /\_ \                             /\ \\ \
 *    \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___\ \ \\ \    _ __
 *     \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\ \ \\ \_ /\`'__\
 *      \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \ \__ ,__\ \ \/
 *       \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/\/_/\_\_/\ \_\
 *        \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/    \/_/   \/_/
 *                                       /\____/
 *                                       \_/__/
 *
 *      Main file for the Allegro4r Ruby binding to the Allegro library.
 *
 *      By Jason Frey.
 */

#include <allegro.h>
#include <winalleg.h>
#include <ruby.h>

// Allegro4r modules and classes
static VALUE modAllegro4r;
static VALUE modAllegro4r_API;
static VALUE cBITMAP;
static VALUE cPALETTE;
static VALUE cRGB;
static VALUE cFONT;

// Object definitions for structures and types defined by Allegro
#include "a4r_BITMAP.i"
#include "a4r_PALETTE.i"
#include "a4r_RGB.i"

// Ruby methods for routines defined by Allegro
#include "a4r_using_allegro.i"
#include "a4r_mouse_routines.i"
#include "a4r_keyboard_routines.i"
#include "a4r_graphic_modes.i"
#include "a4r_bitmap_objects.i"
#include "a4r_palette_routines.i"
#include "a4r_truecolor_pixel_formats.i"
#include "a4r_drawing_primitives.i"
#include "a4r_blitting_and_sprites.i"
#include "a4r_text_output.i"
#include "a4r_transparency_and_patterned_drawing.i"

void Init_allegro4r()
{
  modAllegro4r = rb_define_module("Allegro4r");
  modAllegro4r_API = rb_define_module_under(modAllegro4r, "API");

  cBITMAP = rb_define_class_under(modAllegro4r_API, "BITMAP", rb_cObject);
  rb_define_method(cBITMAP, "h", a4r_BITMAP_h_get, 0);
  rb_define_method(cBITMAP, "w", a4r_BITMAP_w_get, 0);

  cPALETTE = rb_define_class_under(modAllegro4r_API, "PALETTE", rb_cObject);
  rb_define_alloc_func(cPALETTE, a4r_PALETTE_alloc);
  rb_define_method(cPALETTE, "initialize_copy", a4r_PALETTE_initialize_copy, 1);
  rb_define_method(cPALETTE, "[]", a4r_PALETTE_getter, 1);
  rb_define_method(cPALETTE, "[]=", a4r_PALETTE_setter, 2);

  cRGB = rb_define_class_under(modAllegro4r_API, "RGB", rb_cObject);
  rb_define_alloc_func(cRGB, a4r_RGB_alloc);
  rb_define_method(cRGB, "initialize_copy", a4r_RGB_initialize_copy, 1);
  rb_define_method(cRGB, "r", a4r_RGB_r_get, 0);
  rb_define_method(cRGB, "r=", a4r_RGB_r_set, 1);
  rb_define_method(cRGB, "g", a4r_RGB_g_get, 0);
  rb_define_method(cRGB, "g=", a4r_RGB_g_set, 1);
  rb_define_method(cRGB, "b", a4r_RGB_b_get, 0);
  rb_define_method(cRGB, "b=", a4r_RGB_b_set, 1);

  cFONT = rb_define_class_under(modAllegro4r_API, "FONT", rb_cObject);

  rb_define_module_function(modAllegro4r_API, "allegro_init", a4r_allegro_init, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_exit", a4r_allegro_exit, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_error", a4r_allegro_error, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_message", a4r_allegro_message, 1);

  rb_define_module_function(modAllegro4r_API, "install_mouse", a4r_install_mouse, 0);
  rb_define_module_function(modAllegro4r_API, "show_mouse", a4r_show_mouse, 1);

  rb_define_module_function(modAllegro4r_API, "install_keyboard", a4r_install_keyboard, 0);
  rb_define_module_function(modAllegro4r_API, "keypressed", a4r_keypressed, 0);
  rb_define_module_function(modAllegro4r_API, "readkey", a4r_readkey, 0);

  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT", INT2FIX(GFX_AUTODETECT));
  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT_FULLSCREEN", INT2FIX(GFX_AUTODETECT_FULLSCREEN));
  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT_WINDOWED", INT2FIX(GFX_AUTODETECT_WINDOWED));
  rb_define_const(modAllegro4r_API, "GFX_SAFE", INT2NUM(GFX_SAFE));
  rb_define_const(modAllegro4r_API, "GFX_TEXT", INT2FIX(GFX_TEXT));
  rb_define_module_function(modAllegro4r_API, "set_gfx_mode", a4r_set_gfx_mode, 5);

  rb_define_module_function(modAllegro4r_API, "screen", a4r_screen, 0);
  rb_define_module_function(modAllegro4r_API, "SCREEN_W", a4r_SCREEN_W, 0);
  rb_define_module_function(modAllegro4r_API, "SCREEN_H", a4r_SCREEN_H, 0);
  rb_define_module_function(modAllegro4r_API, "create_bitmap", a4r_create_bitmap, 2);
  rb_define_module_function(modAllegro4r_API, "create_sub_bitmap", a4r_create_sub_bitmap, 5);
  rb_define_module_function(modAllegro4r_API, "destroy_bitmap", a4r_destroy_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "bitmap_mask_color", a4r_bitmap_mask_color, 1);
  rb_define_module_function(modAllegro4r_API, "acquire_bitmap", a4r_acquire_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "release_bitmap", a4r_release_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "acquire_screen", a4r_acquire_screen, 0);
  rb_define_module_function(modAllegro4r_API, "release_screen", a4r_release_screen, 0);

  rb_define_module_function(modAllegro4r_API, "set_palette", a4r_set_palette, 1);
  rb_define_module_function(modAllegro4r_API, "get_palette", a4r_get_palette, 1);
  rb_define_module_function(modAllegro4r_API, "desktop_palette", a4r_desktop_palette, 0);
  rb_define_module_function(modAllegro4r_API, "black_palette", a4r_black_palette, 0);

  rb_define_module_function(modAllegro4r_API, "makecol", a4r_makecol, 3);
  rb_define_module_function(modAllegro4r_API, "palette_color", a4r_palette_color, 0);

  rb_define_module_function(modAllegro4r_API, "clear_bitmap", a4r_clear_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "clear_to_color", a4r_clear_to_color, 2);
  rb_define_module_function(modAllegro4r_API, "rectfill", a4r_rectfill, 6);
  rb_define_module_function(modAllegro4r_API, "circle", a4r_circle, 5);
  rb_define_module_function(modAllegro4r_API, "circlefill", a4r_circlefill, 5);

  rb_define_module_function(modAllegro4r_API, "blit", a4r_blit, 8);
  rb_define_module_function(modAllegro4r_API, "masked_blit", a4r_masked_blit, 8);

  rb_define_module_function(modAllegro4r_API, "font", a4r_font, 0);
  rb_define_module_function(modAllegro4r_API, "text_length", a4r_text_length, 2);
  rb_define_module_function(modAllegro4r_API, "text_height", a4r_text_height, 1);
  rb_define_module_function(modAllegro4r_API, "textout_ex", a4r_textout_ex, 7);
  rb_define_module_function(modAllegro4r_API, "textout_centre_ex", a4r_textout_centre_ex, 7);

  rb_define_const(modAllegro4r_API, "DRAW_MODE_SOLID", INT2FIX(DRAW_MODE_SOLID));
  rb_define_const(modAllegro4r_API, "DRAW_MODE_XOR", INT2FIX(DRAW_MODE_XOR));
  rb_define_const(modAllegro4r_API, "DRAW_MODE_COPY_PATTERN", INT2FIX(DRAW_MODE_COPY_PATTERN));
  rb_define_const(modAllegro4r_API, "DRAW_MODE_SOLID_PATTERN", INT2FIX(DRAW_MODE_SOLID_PATTERN));
  rb_define_const(modAllegro4r_API, "DRAW_MODE_MASKED_PATTERN", INT2FIX(DRAW_MODE_MASKED_PATTERN));
  rb_define_const(modAllegro4r_API, "DRAW_MODE_TRANS", INT2FIX(DRAW_MODE_TRANS));
  rb_define_module_function(modAllegro4r_API, "drawing_mode", a4r_drawing_mode, 4);
  rb_define_module_function(modAllegro4r_API, "solid_mode", a4r_solid_mode, 0);
}

// needed if Allegro is built as a shared library

int main()
{
  return 0;
}
END_OF_MAIN()
