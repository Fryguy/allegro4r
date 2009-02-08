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
#include "al_PALETTE.i"
#include "al_RGB.i"

// Ruby methods for routines defined by Allegro
#include "al_using_allegro.i"
#include "al_mouse_routines.i"
#include "al_keyboard_routines.i"
#include "al_graphic_modes.i"
#include "al_bitmap_objects.i"
#include "al_palette_routines.i"
#include "al_truecolor_pixel_formats.i"
#include "al_drawing_primitives.i"
#include "al_blitting_and_sprites.i"
#include "al_text_output.i"

void Init_allegro4r()
{
  modAllegro4r = rb_define_module("Allegro4r");
  modAllegro4r_API = rb_define_module_under(modAllegro4r, "API");

  rb_define_module_function(modAllegro4r_API, "allegro_init", al_allegro_init, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_exit", al_allegro_exit, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_error", al_allegro_error, 0);
  rb_define_module_function(modAllegro4r_API, "allegro_message", al_allegro_message, 1);

  cBITMAP = rb_define_class_under(modAllegro4r_API, "BITMAP", rb_cObject);

  cPALETTE = rb_define_class_under(modAllegro4r_API, "PALETTE", rb_cObject);
  rb_define_alloc_func(cPALETTE, al_PALETTE_alloc);
  rb_define_method(cPALETTE, "initialize_copy", al_PALETTE_initialize_copy, 1);
  rb_define_method(cPALETTE, "[]", al_PALETTE_getter, 1);
  rb_define_method(cPALETTE, "[]=", al_PALETTE_setter, 2);

  cRGB = rb_define_class_under(modAllegro4r_API, "RGB", rb_cObject);
  rb_define_alloc_func(cRGB, al_RGB_alloc);
  rb_define_method(cRGB, "initialize_copy", al_RGB_initialize_copy, 1);
  rb_define_method(cRGB, "r", al_RGB_r_get, 0);
  rb_define_method(cRGB, "r=", al_RGB_r_set, 1);
  rb_define_method(cRGB, "g", al_RGB_g_get, 0);
  rb_define_method(cRGB, "g=", al_RGB_g_set, 1);
  rb_define_method(cRGB, "b", al_RGB_b_get, 0);
  rb_define_method(cRGB, "b=", al_RGB_b_set, 1);

  cFONT = rb_define_class_under(modAllegro4r_API, "FONT", rb_cObject);

  rb_define_module_function(modAllegro4r_API, "install_mouse", al_install_mouse, 0);
  rb_define_module_function(modAllegro4r_API, "show_mouse", al_show_mouse, 1);

  rb_define_module_function(modAllegro4r_API, "install_keyboard", al_install_keyboard, 0);
  rb_define_module_function(modAllegro4r_API, "keypressed", al_keypressed, 0);
  rb_define_module_function(modAllegro4r_API, "readkey", al_readkey, 0);

  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT", INT2FIX(GFX_AUTODETECT));
  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT_FULLSCREEN", INT2FIX(GFX_AUTODETECT_FULLSCREEN));
  rb_define_const(modAllegro4r_API, "GFX_AUTODETECT_WINDOWED", INT2FIX(GFX_AUTODETECT_WINDOWED));
  rb_define_const(modAllegro4r_API, "GFX_SAFE", INT2NUM(GFX_SAFE));
  rb_define_const(modAllegro4r_API, "GFX_TEXT", INT2FIX(GFX_TEXT));
  rb_define_module_function(modAllegro4r_API, "set_gfx_mode", al_set_gfx_mode, 5);

  rb_define_module_function(modAllegro4r_API, "screen", al_screen, 0);
  rb_define_module_function(modAllegro4r_API, "SCREEN_W", al_SCREEN_W, 0);
  rb_define_module_function(modAllegro4r_API, "SCREEN_H", al_SCREEN_H, 0);
  rb_define_module_function(modAllegro4r_API, "create_bitmap", al_create_bitmap, 2);
  rb_define_module_function(modAllegro4r_API, "destroy_bitmap", al_destroy_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "acquire_screen", al_acquire_screen, 0);
  rb_define_module_function(modAllegro4r_API, "release_screen", al_release_screen, 0);

  rb_define_module_function(modAllegro4r_API, "set_palette", al_set_palette, 1);
  rb_define_module_function(modAllegro4r_API, "get_palette", al_get_palette, 1);
  rb_define_module_function(modAllegro4r_API, "desktop_palette", al_desktop_palette, 0);
  rb_define_module_function(modAllegro4r_API, "black_palette", al_black_palette, 0);

  rb_define_module_function(modAllegro4r_API, "makecol", al_makecol, 3);
  rb_define_module_function(modAllegro4r_API, "palette_color", al_palette_color, 0);

  rb_define_module_function(modAllegro4r_API, "clear_bitmap", al_clear_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "clear_to_color", al_clear_to_color, 2);
  rb_define_module_function(modAllegro4r_API, "circle", al_circle, 5);
  rb_define_module_function(modAllegro4r_API, "circlefill", al_circlefill, 5);

  rb_define_module_function(modAllegro4r_API, "blit", al_blit, 8);

  rb_define_module_function(modAllegro4r_API, "font", al_font, 0);
  rb_define_module_function(modAllegro4r_API, "textout_centre_ex", al_textout_centre_ex, 7);
}

// needed if Allegro is built as a shared library
int main()
{
  return 0;
}
END_OF_MAIN()
