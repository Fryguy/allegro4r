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

#include "allegro4r.h"

ID CALL_ID;

/*
 * Document-class: Allegro4r
 *
 * The Allegro4r module.
 */
VALUE mAllegro4r;

/*
 * Document-class: Allegro4r::API
 *
 * The Allegro4r::API module.
 */
VALUE mAllegro4r_API;

/*
 * Document-class: Allegro4r::API::FONT
 *
 * The Allegro4r::API::FONT class.
 */
VALUE cFONT;

void Init_allegro4r()
{
  CALL_ID = rb_intern("call");

  mAllegro4r = rb_define_module("Allegro4r");
  mAllegro4r_API = rb_define_module_under(mAllegro4r, "API");

  cBITMAP = rb_define_class_under(mAllegro4r_API, "BITMAP", rb_cObject); // in a4r_BITMAP.c
  rb_define_method(cBITMAP, "h", a4r_BITMAP_h_get, 0); // in a4r_BITMAP.c
  rb_define_method(cBITMAP, "w", a4r_BITMAP_w_get, 0); // in a4r_BITMAP.c

  cPALETTE = rb_define_class_under(mAllegro4r_API, "PALETTE", rb_cObject); // in a4r_PALETTE.c
  rb_define_alloc_func(cPALETTE, a4r_PALETTE_alloc); // in a4r_PALETTE.c
  rb_define_method(cPALETTE, "initialize_copy", a4r_PALETTE_initialize_copy, 1); // in a4r_PALETTE.c
  rb_define_method(cPALETTE, "[]", a4r_PALETTE_getter, 1); // in a4r_PALETTE.c
  rb_define_method(cPALETTE, "[]=", a4r_PALETTE_setter, 2); // in a4r_PALETTE.c

  cRGB = rb_define_class_under(mAllegro4r_API, "RGB", rb_cObject); // in a4r_RGB.c
  rb_define_alloc_func(cRGB, a4r_RGB_alloc); // in a4r_RGB.c
  rb_define_method(cRGB, "initialize_copy", a4r_RGB_initialize_copy, 1); // in a4r_RGB.c
  rb_define_method(cRGB, "r", a4r_RGB_r_get, 0); // in a4r_RGB.c
  rb_define_method(cRGB, "r=", a4r_RGB_r_set, 1); // in a4r_RGB.c
  rb_define_method(cRGB, "g", a4r_RGB_g_get, 0); // in a4r_RGB.c
  rb_define_method(cRGB, "g=", a4r_RGB_g_set, 1); // in a4r_RGB.c
  rb_define_method(cRGB, "b", a4r_RGB_b_get, 0); // in a4r_RGB.c
  rb_define_method(cRGB, "b=", a4r_RGB_b_set, 1); // in a4r_RGB.c

  cFONT = rb_define_class_under(mAllegro4r_API, "FONT", rb_cObject);

  cGFX_DRIVER = rb_define_class_under(mAllegro4r_API, "GFX_DRIVER", rb_cObject); // in a4r_GFX_DRIVER.c
  rb_define_method(cGFX_DRIVER, "name", a4r_GFX_DRIVER_name_get, 0); // in a4r_GFX_DRIVER.c

  cMOUSE_DRIVER = rb_define_class_under(mAllegro4r_API, "MOUSE_DRIVER", rb_cObject); // in a4r_MOUSE_DRIVER.c
  rb_define_method(cMOUSE_DRIVER, "name", a4r_MOUSE_DRIVER_name_get, 0); // in a4r_MOUSE_DRIVER.c

  cTIMER_DRIVER = rb_define_class_under(mAllegro4r_API, "TIMER_DRIVER", rb_cObject); // in a4r_TIMER_DRIVER.c
  rb_define_method(cTIMER_DRIVER, "name", a4r_TIMER_DRIVER_name_get, 0); // in a4r_TIMER_DRIVER.c

  cKEYBOARD_DRIVER = rb_define_class_under(mAllegro4r_API, "KEYBOARD_DRIVER", rb_cObject); // in a4r_KEYBOARD_DRIVER.c
  rb_define_method(cKEYBOARD_DRIVER, "name", a4r_KEYBOARD_DRIVER_name_get, 0); // in a4r_KEYBOARD_DRIVER.c
  
  rb_define_module_function(mAllegro4r_API, "MIN", a4r_MIN, 2); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "ABS", a4r_ABS, 1); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "AL_RAND", a4r_AL_RAND, 0); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "gfx_driver", a4r_gfx_driver, 0); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "mouse_driver", a4r_mouse_driver, 0); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "timer_driver", a4r_timer_driver, 0); // in a4r_misc.c
  rb_define_module_function(mAllegro4r_API, "keyboard_driver", a4r_keyboard_driver, 0); // in a4r_misc.c

  rb_define_module_function(mAllegro4r_API, "allegro_init", a4r_allegro_init, 0); // in a4r_using_allegro.c
  rb_define_module_function(mAllegro4r_API, "allegro_exit", a4r_allegro_exit, 0); // in a4r_using_allegro.c
  rb_define_module_function(mAllegro4r_API, "allegro_error", a4r_allegro_error, 0); // in a4r_using_allegro.c
  rb_define_module_function(mAllegro4r_API, "allegro_message", a4r_allegro_message, 1); // in a4r_using_allegro.c

  rb_define_module_function(mAllegro4r_API, "ustrzncpy", a4r_ustrzncpy, 2); // in a4r_unicode_routines.c
  rb_define_module_function(mAllegro4r_API, "usprintf", a4r_usprintf, 1); // in a4r_unicode_routines.c

  rb_define_module_function(mAllegro4r_API, "install_mouse", a4r_install_mouse, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "poll_mouse", a4r_poll_mouse, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "mouse_x", a4r_mouse_x, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "mouse_y", a4r_mouse_y, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "mouse_z", a4r_mouse_z, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "mouse_w", a4r_mouse_w, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "mouse_b", a4r_mouse_b, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "show_mouse", a4r_show_mouse, 1); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "get_mouse_mickeys", a4r_get_mouse_mickeys, 0); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "set_mouse_sprite", a4r_set_mouse_sprite, 1); // in a4r_mouse_routines.c
  rb_define_module_function(mAllegro4r_API, "set_mouse_sprite_focus", a4r_set_mouse_sprite_focus, 2); // in a4r_mouse_routines.c

  rb_define_module_function(mAllegro4r_API, "install_timer", a4r_install_timer, 0); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "install_int", a4r_install_int, 2); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "install_int_ex", a4r_install_int_ex, 2); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "LOCK_VARIABLE", a4r_LOCK_VARIABLE, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "LOCK_FUNCTION", a4r_LOCK_FUNCTION, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "retrace_count", a4r_retrace_count, 0); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "rest", a4r_rest, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "SECS_TO_TIMER", a4r_SECS_TO_TIMER, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "MSEC_TO_TIMER", a4r_MSEC_TO_TIMER, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "BPS_TO_TIMER", a4r_BPS_TO_TIMER, 1); // in a4r_timer_routines.c
  rb_define_module_function(mAllegro4r_API, "BPM_TO_TIMER", a4r_BPM_TO_TIMER, 1); // in a4r_timer_routines.c

  timer_counter_names = rb_hash_new();
  rb_global_variable(&timer_counter_names);
  LOCK_VARIABLE(timer_counters)
  LOCK_FUNCTION(timer_counter_incr)
  rb_define_module_function(mAllegro4r_API, "timer_counter_get", a4r_timer_counter_get, 1); // in a4r_timer_routines.c

  rb_define_module_function(mAllegro4r_API, "install_keyboard", a4r_install_keyboard, 0); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "key", a4r_key, 0); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "key_shifts", a4r_key_shifts, 0); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "keypressed", a4r_keypressed, 0); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "readkey", a4r_readkey, 0); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "ureadkey", a4r_ureadkey, 1); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "scancode_to_name", a4r_scancode_to_name, 1); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "keyboard_callback=", a4r_keyboard_callback_set, 1); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "keyboard_lowlevel_callback=", a4r_keyboard_lowlevel_callback_set, 1); // in a4r_keyboard_routines.c
  rb_define_module_function(mAllegro4r_API, "clear_keybuf", a4r_clear_keybuf, 0); // in a4r_keyboard_routines.c

  rb_global_variable(&keyboard_callback_proc);
  rb_global_variable(&keyboard_lowlevel_callback_proc);
  LOCK_VARIABLE(keyboard_callback_proc)
  LOCK_VARIABLE(keyboard_lowlevel_callback_proc)
  LOCK_FUNCTION(keyboard_callback_method)
  LOCK_FUNCTION(keyboard_lowlevel_callback_method)

  rb_define_module_function(mAllegro4r_API, "set_gfx_mode", a4r_set_gfx_mode, 5); // in a4r_graphics_modes.c
  rb_define_module_function(mAllegro4r_API, "show_video_bitmap", a4r_show_video_bitmap, 1); // in a4r_graphics_modes.c
  rb_define_module_function(mAllegro4r_API, "vsync", a4r_vsync, 0); // in a4r_graphics_modes.c

  rb_define_module_function(mAllegro4r_API, "screen", a4r_screen, 0); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "SCREEN_W", a4r_SCREEN_W, 0); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "SCREEN_H", a4r_SCREEN_H, 0); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "create_bitmap", a4r_create_bitmap, 2); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "create_sub_bitmap", a4r_create_sub_bitmap, 5); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "create_video_bitmap", a4r_create_video_bitmap, 2); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "destroy_bitmap", a4r_destroy_bitmap, 1); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "bitmap_mask_color", a4r_bitmap_mask_color, 1); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "acquire_bitmap", a4r_acquire_bitmap, 1); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "release_bitmap", a4r_release_bitmap, 1); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "acquire_screen", a4r_acquire_screen, 0); // in a4r_bitmap_objects.c
  rb_define_module_function(mAllegro4r_API, "release_screen", a4r_release_screen, 0); // in a4r_bitmap_objects.c

  rb_define_module_function(mAllegro4r_API, "set_palette", a4r_set_palette, 1); // in a4r_palette_routines.c
  rb_define_module_function(mAllegro4r_API, "get_palette", a4r_get_palette, 1); // in a4r_palette_routines.c
  rb_define_module_function(mAllegro4r_API, "desktop_palette", a4r_desktop_palette, 0); // in a4r_palette_routines.c
  rb_define_module_function(mAllegro4r_API, "black_palette", a4r_black_palette, 0); // in a4r_palette_routines.c

  rb_define_module_function(mAllegro4r_API, "makecol", a4r_makecol, 3); // in a4r_truecolor_pixel_formats.c
  rb_define_module_function(mAllegro4r_API, "palette_color", a4r_palette_color, 0); // in a4r_truecolor_pixel_formats.c

  rb_define_module_function(mAllegro4r_API, "clear_bitmap", a4r_clear_bitmap, 1); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "clear_to_color", a4r_clear_to_color, 2); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "putpixel", a4r_putpixel, 4); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "getpixel", a4r_getpixel, 3); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "rectfill", a4r_rectfill, 6); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "circle", a4r_circle, 5); // in a4r_drawing_primitives.c
  rb_define_module_function(mAllegro4r_API, "circlefill", a4r_circlefill, 5); // in a4r_drawing_primitives.c

  rb_define_module_function(mAllegro4r_API, "blit", a4r_blit, 8); // in a4r_blitting_and_sprites.c
  rb_define_module_function(mAllegro4r_API, "masked_blit", a4r_masked_blit, 8); // in a4r_blitting_and_sprites.c

  rb_define_module_function(mAllegro4r_API, "load_font", a4r_load_font, 3); // in a4r_fonts.c
  rb_define_module_function(mAllegro4r_API, "destroy_font", a4r_destroy_font, 1); // in a4r_fonts.c
  rb_define_module_function(mAllegro4r_API, "extract_font_range", a4r_extract_font_range, 3); // in a4r_fonts.c
  rb_define_module_function(mAllegro4r_API, "merge_fonts", a4r_merge_fonts, 2); // in a4r_fonts.c

  rb_define_module_function(mAllegro4r_API, "font", a4r_font, 0); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "font=", a4r_font_set, 1); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "text_length", a4r_text_length, 2); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "text_height", a4r_text_height, 1); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "textout_ex", a4r_textout_ex, 7); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "textout_centre_ex", a4r_textout_centre_ex, 7); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "textprintf_ex", a4r_textprintf_ex, 7); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "textprintf_centre_ex", a4r_textprintf_centre_ex, 7); // in a4r_text_output.c
  rb_define_module_function(mAllegro4r_API, "textprintf_right_ex", a4r_textprintf_right_ex, 7); // in a4r_text_output.c

  rb_define_module_function(mAllegro4r_API, "drawing_mode", a4r_drawing_mode, 4); // in a4r_transparency_and_patterned_drawing.c
  rb_define_module_function(mAllegro4r_API, "solid_mode", a4r_solid_mode, 0); // in a4r_transparency_and_patterned_drawing.c

  rb_define_module_function(mAllegro4r_API, "bmp_select", a4r_bmp_select, 1); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_read8", a4r_bmp_read8, 1); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_read32", a4r_bmp_read32, 1); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_write8", a4r_bmp_write8, 2); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_write32", a4r_bmp_write32, 2); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_write_line", a4r_bmp_write_line, 2); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_read_line", a4r_bmp_read_line, 2); // in a4r_direct_access_to_video_memory.c
  rb_define_module_function(mAllegro4r_API, "bmp_unwrite_line", a4r_bmp_unwrite_line, 1); // in a4r_direct_access_to_video_memory.c

  rb_define_module_function(mAllegro4r_API, "itofix", a4r_itofix, 1); // in a4r_fixed_point_math_routines.c
  rb_define_module_function(mAllegro4r_API, "ftofix", a4r_ftofix, 1); // in a4r_fixed_point_math_routines.c
  rb_define_module_function(mAllegro4r_API, "fixtof", a4r_fixtof, 1); // in a4r_fixed_point_math_routines.c
  rb_define_module_function(mAllegro4r_API, "fixmul", a4r_fixmul, 2); // in a4r_fixed_point_math_routines.c
  rb_define_module_function(mAllegro4r_API, "fixsqrt", a4r_fixsqrt, 1); // in a4r_fixed_point_math_routines.c

  /*
   * GFX_AUTODETECT: Allegro will try to set the specified resolution with the
   * current color depth in fullscreen mode. Failing that, it will try to repeat
   * the same operation in windowed mode.
   */
  rb_define_const(mAllegro4r_API, "GFX_AUTODETECT", INT2FIX(GFX_AUTODETECT));
  /*
   * GFX_AUTODETECT_FULLSCREEN: Allegro will try to set the specified resolution
   * with the current color depth in fullscreen mode.
   */
  rb_define_const(mAllegro4r_API, "GFX_AUTODETECT_FULLSCREEN", INT2FIX(GFX_AUTODETECT_FULLSCREEN));
  /*
   * GFX_AUTODETECT_WINDOWED: Allegro will try to set the specified resolution
   * with the current color depth in a windowed mode.
   */
  rb_define_const(mAllegro4r_API, "GFX_AUTODETECT_WINDOWED", INT2FIX(GFX_AUTODETECT_WINDOWED));
  /*
   * GFX_SAFE: Allegro will try to set the specified resolution. Failing that,
   * it will fall back upon whatever mode is known to be reliable on the current
   * platform. If it absolutely cannot set any graphics mode at all, there's no
   * possible video output on the machine.
   */
  rb_define_const(mAllegro4r_API, "GFX_SAFE", INT2NUM(GFX_SAFE));
  /*
   * GFX_TEXT: Closes any previously opened graphics mode, and in those
   * environments that have text modes, sets one previously used or the closest
   * match to that (usually 80x25).
   */
  rb_define_const(mAllegro4r_API, "GFX_TEXT", INT2FIX(GFX_TEXT));

  /* DRAW_MODE_SOLID: The default, solid color drawing */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_SOLID", INT2FIX(DRAW_MODE_SOLID));
  /* DRAW_MODE_XOR: Exclusive-or drawing */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_XOR", INT2FIX(DRAW_MODE_XOR));
  /* DRAW_MODE_COPY_PATTERN: Multicolored pattern fill */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_COPY_PATTERN", INT2FIX(DRAW_MODE_COPY_PATTERN));
  /* DRAW_MODE_SOLID_PATTERN: Single color pattern fill */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_SOLID_PATTERN", INT2FIX(DRAW_MODE_SOLID_PATTERN));
  /* DRAW_MODE_MASKED_PATTERN: Masked pattern fill */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_MASKED_PATTERN", INT2FIX(DRAW_MODE_MASKED_PATTERN));
  /* DRAW_MODE_TRANS: Translucent color blending */
  rb_define_const(mAllegro4r_API, "DRAW_MODE_TRANS", INT2FIX(DRAW_MODE_TRANS));

  /* KB_SHIFT_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_SHIFT_FLAG", INT2FIX(KB_SHIFT_FLAG));
  /* KB_CTRL_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_CTRL_FLAG", INT2FIX(KB_CTRL_FLAG));
  /* KB_ALT_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_ALT_FLAG", INT2FIX(KB_ALT_FLAG));
  /* KB_LWIN_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_LWIN_FLAG", INT2FIX(KB_LWIN_FLAG));
  /* KB_RWIN_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_RWIN_FLAG", INT2FIX(KB_RWIN_FLAG));
  /* KB_MENU_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_MENU_FLAG", INT2FIX(KB_MENU_FLAG));
  /* KB_COMMAND_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_COMMAND_FLAG", INT2FIX(KB_COMMAND_FLAG));
  /* KB_SCROLOCK_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_SCROLOCK_FLAG", INT2FIX(KB_SCROLOCK_FLAG));
  /* KB_NUMLOCK_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_NUMLOCK_FLAG", INT2FIX(KB_NUMLOCK_FLAG));
  /* KB_CAPSLOCK_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_CAPSLOCK_FLAG", INT2FIX(KB_CAPSLOCK_FLAG));
  /* KB_INALTSEQ_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_INALTSEQ_FLAG", INT2FIX(KB_INALTSEQ_FLAG));
  /* KB_ACCENT1_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_ACCENT1_FLAG", INT2FIX(KB_ACCENT1_FLAG));
  /* KB_ACCENT2_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_ACCENT2_FLAG", INT2FIX(KB_ACCENT2_FLAG));
  /* KB_ACCENT3_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_ACCENT3_FLAG", INT2FIX(KB_ACCENT3_FLAG));
  /* KB_ACCENT4_FLAG: */
  rb_define_const(mAllegro4r_API, "KB_ACCENT4_FLAG", INT2FIX(KB_ACCENT4_FLAG));
  /* KEY_A: */
  rb_define_const(mAllegro4r_API, "KEY_A", INT2FIX(KEY_A));
  /* KEY_B: */
  rb_define_const(mAllegro4r_API, "KEY_B", INT2FIX(KEY_B));
  /* KEY_C: */
  rb_define_const(mAllegro4r_API, "KEY_C", INT2FIX(KEY_C));
  /* KEY_D: */
  rb_define_const(mAllegro4r_API, "KEY_D", INT2FIX(KEY_D));
  /* KEY_E: */
  rb_define_const(mAllegro4r_API, "KEY_E", INT2FIX(KEY_E));
  /* KEY_F: */
  rb_define_const(mAllegro4r_API, "KEY_F", INT2FIX(KEY_F));
  /* KEY_G: */
  rb_define_const(mAllegro4r_API, "KEY_G", INT2FIX(KEY_G));
  /* KEY_H: */
  rb_define_const(mAllegro4r_API, "KEY_H", INT2FIX(KEY_H));
  /* KEY_I: */
  rb_define_const(mAllegro4r_API, "KEY_I", INT2FIX(KEY_I));
  /* KEY_J: */
  rb_define_const(mAllegro4r_API, "KEY_J", INT2FIX(KEY_J));
  /* KEY_K: */
  rb_define_const(mAllegro4r_API, "KEY_K", INT2FIX(KEY_K));
  /* KEY_L: */
  rb_define_const(mAllegro4r_API, "KEY_L", INT2FIX(KEY_L));
  /* KEY_M: */
  rb_define_const(mAllegro4r_API, "KEY_M", INT2FIX(KEY_M));
  /* KEY_N: */
  rb_define_const(mAllegro4r_API, "KEY_N", INT2FIX(KEY_N));
  /* KEY_O: */
  rb_define_const(mAllegro4r_API, "KEY_O", INT2FIX(KEY_O));
  /* KEY_P: */
  rb_define_const(mAllegro4r_API, "KEY_P", INT2FIX(KEY_P));
  /* KEY_Q: */
  rb_define_const(mAllegro4r_API, "KEY_Q", INT2FIX(KEY_Q));
  /* KEY_R: */
  rb_define_const(mAllegro4r_API, "KEY_R", INT2FIX(KEY_R));
  /* KEY_S: */
  rb_define_const(mAllegro4r_API, "KEY_S", INT2FIX(KEY_S));
  /* KEY_T: */
  rb_define_const(mAllegro4r_API, "KEY_T", INT2FIX(KEY_T));
  /* KEY_U: */
  rb_define_const(mAllegro4r_API, "KEY_U", INT2FIX(KEY_U));
  /* KEY_V: */
  rb_define_const(mAllegro4r_API, "KEY_V", INT2FIX(KEY_V));
  /* KEY_W: */
  rb_define_const(mAllegro4r_API, "KEY_W", INT2FIX(KEY_W));
  /* KEY_X: */
  rb_define_const(mAllegro4r_API, "KEY_X", INT2FIX(KEY_X));
  /* KEY_Y: */
  rb_define_const(mAllegro4r_API, "KEY_Y", INT2FIX(KEY_Y));
  /* KEY_Z: */
  rb_define_const(mAllegro4r_API, "KEY_Z", INT2FIX(KEY_Z));
  /* KEY_0: */
  rb_define_const(mAllegro4r_API, "KEY_0", INT2FIX(KEY_0));
  /* KEY_1: */
  rb_define_const(mAllegro4r_API, "KEY_1", INT2FIX(KEY_1));
  /* KEY_2: */
  rb_define_const(mAllegro4r_API, "KEY_2", INT2FIX(KEY_2));
  /* KEY_3: */
  rb_define_const(mAllegro4r_API, "KEY_3", INT2FIX(KEY_3));
  /* KEY_4: */
  rb_define_const(mAllegro4r_API, "KEY_4", INT2FIX(KEY_4));
  /* KEY_5: */
  rb_define_const(mAllegro4r_API, "KEY_5", INT2FIX(KEY_5));
  /* KEY_6: */
  rb_define_const(mAllegro4r_API, "KEY_6", INT2FIX(KEY_6));
  /* KEY_7: */
  rb_define_const(mAllegro4r_API, "KEY_7", INT2FIX(KEY_7));
  /* KEY_8: */
  rb_define_const(mAllegro4r_API, "KEY_8", INT2FIX(KEY_8));
  /* KEY_9: */
  rb_define_const(mAllegro4r_API, "KEY_9", INT2FIX(KEY_9));
  /* KEY_0_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_0_PAD", INT2FIX(KEY_0_PAD));
  /* KEY_1_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_1_PAD", INT2FIX(KEY_1_PAD));
  /* KEY_2_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_2_PAD", INT2FIX(KEY_2_PAD));
  /* KEY_3_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_3_PAD", INT2FIX(KEY_3_PAD));
  /* KEY_4_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_4_PAD", INT2FIX(KEY_4_PAD));
  /* KEY_5_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_5_PAD", INT2FIX(KEY_5_PAD));
  /* KEY_6_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_6_PAD", INT2FIX(KEY_6_PAD));
  /* KEY_7_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_7_PAD", INT2FIX(KEY_7_PAD));
  /* KEY_8_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_8_PAD", INT2FIX(KEY_8_PAD));
  /* KEY_9_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_9_PAD", INT2FIX(KEY_9_PAD));
  /* KEY_F1: */
  rb_define_const(mAllegro4r_API, "KEY_F1", INT2FIX(KEY_F1));
  /* KEY_F2: */
  rb_define_const(mAllegro4r_API, "KEY_F2", INT2FIX(KEY_F2));
  /* KEY_F3: */
  rb_define_const(mAllegro4r_API, "KEY_F3", INT2FIX(KEY_F3));
  /* KEY_F4: */
  rb_define_const(mAllegro4r_API, "KEY_F4", INT2FIX(KEY_F4));
  /* KEY_F5: */
  rb_define_const(mAllegro4r_API, "KEY_F5", INT2FIX(KEY_F5));
  /* KEY_F6: */
  rb_define_const(mAllegro4r_API, "KEY_F6", INT2FIX(KEY_F6));
  /* KEY_F7: */
  rb_define_const(mAllegro4r_API, "KEY_F7", INT2FIX(KEY_F7));
  /* KEY_F8: */
  rb_define_const(mAllegro4r_API, "KEY_F8", INT2FIX(KEY_F8));
  /* KEY_F9: */
  rb_define_const(mAllegro4r_API, "KEY_F9", INT2FIX(KEY_F9));
  /* KEY_F10: */
  rb_define_const(mAllegro4r_API, "KEY_F10", INT2FIX(KEY_F10));
  /* KEY_F11: */
  rb_define_const(mAllegro4r_API, "KEY_F11", INT2FIX(KEY_F11));
  /* KEY_F12: */
  rb_define_const(mAllegro4r_API, "KEY_F12", INT2FIX(KEY_F12));
  /* KEY_ESC: */
  rb_define_const(mAllegro4r_API, "KEY_ESC", INT2FIX(KEY_ESC));
  /* KEY_TILDE: */
  rb_define_const(mAllegro4r_API, "KEY_TILDE", INT2FIX(KEY_TILDE));
  /* KEY_MINUS: */
  rb_define_const(mAllegro4r_API, "KEY_MINUS", INT2FIX(KEY_MINUS));
  /* KEY_EQUALS: */
  rb_define_const(mAllegro4r_API, "KEY_EQUALS", INT2FIX(KEY_EQUALS));
  /* KEY_BACKSPACE: */
  rb_define_const(mAllegro4r_API, "KEY_BACKSPACE", INT2FIX(KEY_BACKSPACE));
  /* KEY_TAB: */
  rb_define_const(mAllegro4r_API, "KEY_TAB", INT2FIX(KEY_TAB));
  /* KEY_OPENBRACE: */
  rb_define_const(mAllegro4r_API, "KEY_OPENBRACE", INT2FIX(KEY_OPENBRACE));
  /* KEY_CLOSEBRACE: */
  rb_define_const(mAllegro4r_API, "KEY_CLOSEBRACE", INT2FIX(KEY_CLOSEBRACE));
  /* KEY_ENTER: */
  rb_define_const(mAllegro4r_API, "KEY_ENTER", INT2FIX(KEY_ENTER));
  /* KEY_COLON: */
  rb_define_const(mAllegro4r_API, "KEY_COLON", INT2FIX(KEY_COLON));
  /* KEY_QUOTE: */
  rb_define_const(mAllegro4r_API, "KEY_QUOTE", INT2FIX(KEY_QUOTE));
  /* KEY_BACKSLASH: */
  rb_define_const(mAllegro4r_API, "KEY_BACKSLASH", INT2FIX(KEY_BACKSLASH));
  /* KEY_BACKSLASH2: */
  rb_define_const(mAllegro4r_API, "KEY_BACKSLASH2", INT2FIX(KEY_BACKSLASH2));
  /* KEY_COMMA: */
  rb_define_const(mAllegro4r_API, "KEY_COMMA", INT2FIX(KEY_COMMA));
  /* KEY_STOP: */
  rb_define_const(mAllegro4r_API, "KEY_STOP", INT2FIX(KEY_STOP));
  /* KEY_SLASH: */
  rb_define_const(mAllegro4r_API, "KEY_SLASH", INT2FIX(KEY_SLASH));
  /* KEY_SPACE: */
  rb_define_const(mAllegro4r_API, "KEY_SPACE", INT2FIX(KEY_SPACE));
  /* KEY_INSERT: */
  rb_define_const(mAllegro4r_API, "KEY_INSERT", INT2FIX(KEY_INSERT));
  /* KEY_DEL: */
  rb_define_const(mAllegro4r_API, "KEY_DEL", INT2FIX(KEY_DEL));
  /* KEY_HOME: */
  rb_define_const(mAllegro4r_API, "KEY_HOME", INT2FIX(KEY_HOME));
  /* KEY_END: */
  rb_define_const(mAllegro4r_API, "KEY_END", INT2FIX(KEY_END));
  /* KEY_PGUP: */
  rb_define_const(mAllegro4r_API, "KEY_PGUP", INT2FIX(KEY_PGUP));
  /* KEY_PGDN: */
  rb_define_const(mAllegro4r_API, "KEY_PGDN", INT2FIX(KEY_PGDN));
  /* KEY_LEFT: */
  rb_define_const(mAllegro4r_API, "KEY_LEFT", INT2FIX(KEY_LEFT));
  /* KEY_RIGHT: */
  rb_define_const(mAllegro4r_API, "KEY_RIGHT", INT2FIX(KEY_RIGHT));
  /* KEY_UP: */
  rb_define_const(mAllegro4r_API, "KEY_UP", INT2FIX(KEY_UP));
  /* KEY_DOWN: */
  rb_define_const(mAllegro4r_API, "KEY_DOWN", INT2FIX(KEY_DOWN));
  /* KEY_SLASH_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_SLASH_PAD", INT2FIX(KEY_SLASH_PAD));
  /* KEY_ASTERISK: */
  rb_define_const(mAllegro4r_API, "KEY_ASTERISK", INT2FIX(KEY_ASTERISK));
  /* KEY_MINUS_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_MINUS_PAD", INT2FIX(KEY_MINUS_PAD));
  /* KEY_PLUS_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_PLUS_PAD", INT2FIX(KEY_PLUS_PAD));
  /* KEY_DEL_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_DEL_PAD", INT2FIX(KEY_DEL_PAD));
  /* KEY_ENTER_PAD: */
  rb_define_const(mAllegro4r_API, "KEY_ENTER_PAD", INT2FIX(KEY_ENTER_PAD));
  /* KEY_PRTSCR: */
  rb_define_const(mAllegro4r_API, "KEY_PRTSCR", INT2FIX(KEY_PRTSCR));
  /* KEY_PAUSE: */
  rb_define_const(mAllegro4r_API, "KEY_PAUSE", INT2FIX(KEY_PAUSE));
  /* KEY_ABNT_C1: */
  rb_define_const(mAllegro4r_API, "KEY_ABNT_C1", INT2FIX(KEY_ABNT_C1));
  /* KEY_YEN: */
  rb_define_const(mAllegro4r_API, "KEY_YEN", INT2FIX(KEY_YEN));
  /* KEY_KANA: */
  rb_define_const(mAllegro4r_API, "KEY_KANA", INT2FIX(KEY_KANA));
  /* KEY_CONVERT: */
  rb_define_const(mAllegro4r_API, "KEY_CONVERT", INT2FIX(KEY_CONVERT));
  /* KEY_NOCONVERT: */
  rb_define_const(mAllegro4r_API, "KEY_NOCONVERT", INT2FIX(KEY_NOCONVERT));
  /* KEY_AT: */
  rb_define_const(mAllegro4r_API, "KEY_AT", INT2FIX(KEY_AT));
  /* KEY_CIRCUMFLEX: */
  rb_define_const(mAllegro4r_API, "KEY_CIRCUMFLEX", INT2FIX(KEY_CIRCUMFLEX));
  /* KEY_COLON2: */
  rb_define_const(mAllegro4r_API, "KEY_COLON2", INT2FIX(KEY_COLON2));
  /* KEY_KANJI: */
  rb_define_const(mAllegro4r_API, "KEY_KANJI", INT2FIX(KEY_KANJI));
  /* KEY_EQUALS_PAD: MacOS X*/
  rb_define_const(mAllegro4r_API, "KEY_EQUALS_PAD", INT2FIX(KEY_EQUALS_PAD));
  /* KEY_BACKQUOTE: MacOS X*/
  rb_define_const(mAllegro4r_API, "KEY_BACKQUOTE", INT2FIX(KEY_BACKQUOTE));
  /* KEY_SEMICOLON: MacOS X*/
  rb_define_const(mAllegro4r_API, "KEY_SEMICOLON", INT2FIX(KEY_SEMICOLON));
  /* KEY_COMMAND: MacOS X*/
  rb_define_const(mAllegro4r_API, "KEY_COMMAND", INT2FIX(KEY_COMMAND));
  /* KEY_UNKNOWN1: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN1", INT2FIX(KEY_UNKNOWN1));
  /* KEY_UNKNOWN2: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN2", INT2FIX(KEY_UNKNOWN2));
  /* KEY_UNKNOWN3: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN3", INT2FIX(KEY_UNKNOWN3));
  /* KEY_UNKNOWN4: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN4", INT2FIX(KEY_UNKNOWN4));
  /* KEY_UNKNOWN5: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN5", INT2FIX(KEY_UNKNOWN5));
  /* KEY_UNKNOWN6: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN6", INT2FIX(KEY_UNKNOWN6));
  /* KEY_UNKNOWN7: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN7", INT2FIX(KEY_UNKNOWN7));
  /* KEY_UNKNOWN8: */
  rb_define_const(mAllegro4r_API, "KEY_UNKNOWN8", INT2FIX(KEY_UNKNOWN8));
  /* KEY_MODIFIERS: */
  rb_define_const(mAllegro4r_API, "KEY_MODIFIERS", INT2FIX(KEY_MODIFIERS));
  /* KEY_LSHIFT: */
  rb_define_const(mAllegro4r_API, "KEY_LSHIFT", INT2FIX(KEY_LSHIFT));
  /* KEY_RSHIFT: */
  rb_define_const(mAllegro4r_API, "KEY_RSHIFT", INT2FIX(KEY_RSHIFT));
  /* KEY_LCONTROL: */
  rb_define_const(mAllegro4r_API, "KEY_LCONTROL", INT2FIX(KEY_LCONTROL));
  /* KEY_RCONTROL: */
  rb_define_const(mAllegro4r_API, "KEY_RCONTROL", INT2FIX(KEY_RCONTROL));
  /* KEY_ALT: */
  rb_define_const(mAllegro4r_API, "KEY_ALT", INT2FIX(KEY_ALT));
  /* KEY_ALTGR: */
  rb_define_const(mAllegro4r_API, "KEY_ALTGR", INT2FIX(KEY_ALTGR));
  /* KEY_LWIN: */
  rb_define_const(mAllegro4r_API, "KEY_LWIN", INT2FIX(KEY_LWIN));
  /* KEY_RWIN: */
  rb_define_const(mAllegro4r_API, "KEY_RWIN", INT2FIX(KEY_RWIN));
  /* KEY_MENU: */
  rb_define_const(mAllegro4r_API, "KEY_MENU", INT2FIX(KEY_MENU));
  /* KEY_SCRLOCK: */
  rb_define_const(mAllegro4r_API, "KEY_SCRLOCK", INT2FIX(KEY_SCRLOCK));
  /* KEY_NUMLOCK: */
  rb_define_const(mAllegro4r_API, "KEY_NUMLOCK", INT2FIX(KEY_NUMLOCK));
  /* KEY_CAPSLOCK: */
  rb_define_const(mAllegro4r_API, "KEY_CAPSLOCK", INT2FIX(KEY_CAPSLOCK));
  /* KEY_MAX: */
  rb_define_const(mAllegro4r_API, "KEY_MAX", INT2FIX(KEY_MAX));
}

// needed if Allegro is built as a shared library
int main()
{
  return 0;
}
END_OF_MAIN()
