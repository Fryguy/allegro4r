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
 *      Main header file for the Allegro4r Ruby binding to the Allegro library.
 *
 *      By Jason Frey.
 */

#ifndef __ALLEGRO4R_H__
#define __ALLEGRO4R_H__

#include <allegro.h>

#if defined _WIN32 || defined __CYGWIN__
#include <winalleg.h>
#endif

#include <ruby.h>

extern ID CALL_ID;

// Allegro4r modules and classes
extern VALUE mAllegro4r;
extern VALUE mAllegro4r_API;

extern VALUE cAPI_BITMAP;
extern VALUE cAPI_JOYSTICK_INFO;
extern VALUE cAPI_JOYSTICK_BUTTON_INFO;
extern VALUE cAPI_JOYSTICK_STICK_INFO;
extern VALUE cAPI_JOYSTICK_AXIS_INFO;
extern VALUE cAPI_PALETTE;
extern VALUE cAPI_RGB;
extern VALUE cAPI_FONT;

extern VALUE cAPI_GFX_DRIVER;
extern VALUE cAPI_MOUSE_DRIVER;
extern VALUE cAPI_TIMER_DRIVER;
extern VALUE cAPI_KEYBOARD_DRIVER;
extern VALUE cAPI_JOYSTICK_DRIVER;

// Method definitions for structures and types defined by Allegro

//   BITMAP
extern VALUE a4r_API_BITMAP_h_get(VALUE self);
extern VALUE a4r_API_BITMAP_w_get(VALUE self);

//   JOYSTICK_INFO
extern VALUE a4r_API_JOYSTICK_INFO_flags(VALUE self);
extern VALUE a4r_API_JOYSTICK_INFO_num_sticks(VALUE self);
extern VALUE a4r_API_JOYSTICK_INFO_num_buttons(VALUE self);
extern VALUE a4r_API_JOYSTICK_INFO_stick(VALUE self);
extern VALUE a4r_API_JOYSTICK_INFO_button(VALUE self);

//   JOYSTICK_BUTTON_INFO
extern VALUE a4r_API_JOYSTICK_BUTTON_INFO_b(VALUE self);
extern VALUE a4r_API_JOYSTICK_BUTTON_INFO_name(VALUE self);

//   JOYSTICK_STICK_INFO
extern VALUE a4r_API_JOYSTICK_STICK_INFO_flags(VALUE self);
extern VALUE a4r_API_JOYSTICK_STICK_INFO_num_axis(VALUE self);
extern VALUE a4r_API_JOYSTICK_STICK_INFO_axis(VALUE self);
extern VALUE a4r_API_JOYSTICK_STICK_INFO_name(VALUE self);

//   JOYSTICK_AXIS_INFO
extern VALUE a4r_API_JOYSTICK_AXIS_INFO_pos(VALUE self);
extern VALUE a4r_API_JOYSTICK_AXIS_INFO_d1(VALUE self);
extern VALUE a4r_API_JOYSTICK_AXIS_INFO_d2(VALUE self);
extern VALUE a4r_API_JOYSTICK_AXIS_INFO_name(VALUE self);

//   PALETTE
extern void a4r_API_PALETTE_free(void *palette);
extern VALUE a4r_API_PALETTE_alloc(VALUE klass);
extern VALUE a4r_API_PALETTE_initialize_copy(VALUE copy, VALUE orig);
extern VALUE a4r_API_PALETTE_getter(VALUE self, VALUE index);
extern VALUE a4r_API_PALETTE_setter(VALUE self, VALUE index, VALUE val);

//   RGB
extern void a4r_API_RGB_free(void *rgb);
extern VALUE a4r_API_RGB_alloc(VALUE klass);
extern VALUE a4r_API_RGB_initialize_copy(VALUE copy, VALUE orig);
extern VALUE a4r_API_RGB_r_get(VALUE self);
extern VALUE a4r_API_RGB_r_set(VALUE self, VALUE val);
extern VALUE a4r_API_RGB_g_get(VALUE self);
extern VALUE a4r_API_RGB_g_set(VALUE self, VALUE val);
extern VALUE a4r_API_RGB_b_get(VALUE self);
extern VALUE a4r_API_RGB_b_set(VALUE self, VALUE val);

//   GFX_DRIVER
extern VALUE a4r_API_GFX_DRIVER_name_get(VALUE self);

//   MOUSE_DRIVER
extern VALUE a4r_API_MOUSE_DRIVER_name_get(VALUE self);

//   TIMER_DRIVER
extern VALUE a4r_API_TIMER_DRIVER_name_get(VALUE self);

//   KEYBOARD_DRIVER
extern VALUE a4r_API_KEYBOARD_DRIVER_name_get(VALUE self);

//   JOYSTICK_DRIVER
extern VALUE a4r_API_JOYSTICK_DRIVER_name_get(VALUE self);

// Ruby methods for routines defined by Allegro

//   Misc
extern VALUE a4r_API_MIN(VALUE self, VALUE x, VALUE y);
extern VALUE a4r_API_ABS(VALUE self, VALUE x);
extern VALUE a4r_API_AL_RAND(VALUE self);
extern VALUE a4r_API_gfx_driver(VALUE self);
extern VALUE a4r_API_mouse_driver(VALUE self);
extern VALUE a4r_API_timer_driver(VALUE self);
extern VALUE a4r_API_keyboard_driver(VALUE self);
extern VALUE a4r_API_joystick_driver(VALUE self);

//   Using Allegro
extern VALUE a4r_API_allegro_init(VALUE self);
extern VALUE a4r_API_allegro_exit(VALUE self);
extern VALUE a4r_API_allegro_error(VALUE self);
extern VALUE a4r_API_allegro_message(VALUE self, VALUE text);

//   Unicode routines
extern VALUE a4r_API_usprintf(VALUE self, VALUE format);
extern VALUE a4r_API_ustrzncpy(VALUE self, VALUE src, VALUE n);

//   Mouse routines
extern VALUE a4r_API_install_mouse(VALUE self);
extern VALUE a4r_API_poll_mouse(VALUE self);
extern VALUE a4r_API_mouse_x(VALUE self);
extern VALUE a4r_API_mouse_y(VALUE self);
extern VALUE a4r_API_mouse_z(VALUE self);
extern VALUE a4r_API_mouse_w(VALUE self);
extern VALUE a4r_API_mouse_b(VALUE self);
extern VALUE a4r_API_show_mouse(VALUE self, VALUE bmp);
extern VALUE a4r_API_get_mouse_mickeys(VALUE self);
extern VALUE a4r_API_set_mouse_sprite(VALUE self, VALUE bmp);
extern VALUE a4r_API_set_mouse_sprite_focus(VALUE self, VALUE x, VALUE y);

//   Timer routines
extern VALUE a4r_API_install_timer(VALUE self);
extern VALUE a4r_API_install_int(VALUE self, VALUE proc, VALUE speed);
extern VALUE a4r_API_install_int_ex(VALUE self, VALUE proc, VALUE speed);
extern VALUE a4r_API_LOCK_VARIABLE(VALUE self, VALUE variable_name);
extern VALUE a4r_API_LOCK_FUNCTION(VALUE self, VALUE function_name);
extern VALUE a4r_API_retrace_count(VALUE self);
extern VALUE a4r_API_rest(VALUE self, VALUE time);
extern VALUE a4r_API_SECS_TO_TIMER(VALUE self, VALUE secs);
extern VALUE a4r_API_MSEC_TO_TIMER(VALUE self, VALUE msec);
extern VALUE a4r_API_BPS_TO_TIMER(VALUE self, VALUE bps);
extern VALUE a4r_API_BPM_TO_TIMER(VALUE self, VALUE bpm);

//     Predefined timer interrupt routines
#define MAX_TIMER_COUNTERS 10
extern volatile int timer_counters[MAX_TIMER_COUNTERS];
extern VALUE timer_counter_names;

extern void timer_counter_incr(void *param);
extern VALUE find_timer_counter(VALUE name);
extern VALUE find_free_timer_counter();
extern VALUE a4r_API_timer_counter_get(VALUE self, VALUE name);

//   Keyboard routines
extern VALUE a4r_API_install_keyboard(VALUE self);
extern VALUE a4r_API_key(VALUE self);
extern VALUE a4r_API_key_shifts(VALUE self);
extern VALUE a4r_API_keypressed(VALUE self);
extern VALUE a4r_API_readkey(VALUE self);
extern VALUE a4r_API_ureadkey(VALUE self, VALUE scancode);
extern VALUE a4r_API_scancode_to_name(VALUE self, VALUE scancode);
extern VALUE a4r_API_keyboard_callback_set(VALUE self, VALUE proc);
extern VALUE a4r_API_keyboard_lowlevel_callback_set(VALUE self, VALUE proc);
extern VALUE a4r_API_clear_keybuf(VALUE self);

// Predefined keyboard callback routines
extern VALUE keyboard_callback_proc;
extern VALUE keyboard_lowlevel_callback_proc;
extern int keyboard_callback_method(int key);
extern void keyboard_lowlevel_callback_method(int scancode);

//   Joystick routines
extern VALUE a4r_API_install_joystick(VALUE self, VALUE type);
extern VALUE a4r_API_poll_joystick(VALUE self);
extern VALUE a4r_API_num_joysticks(VALUE self);
extern VALUE a4r_API_joy(VALUE self);
extern VALUE a4r_API_calibrate_joystick_name(VALUE self, VALUE n);
extern VALUE a4r_API_calibrate_joystick(VALUE self, VALUE n);

//   Graphics modes
extern VALUE a4r_API_set_gfx_mode(VALUE self, VALUE card, VALUE w, VALUE h, VALUE v_w, VALUE v_h);
extern VALUE a4r_API_show_video_bitmap(VALUE self, VALUE bitmap);
extern VALUE a4r_API_vsync(VALUE self);

//   Bitmap objects
extern VALUE a4r_API_screen(VALUE self);
extern VALUE a4r_API_SCREEN_W(VALUE self);
extern VALUE a4r_API_SCREEN_H(VALUE self);
extern VALUE a4r_API_create_bitmap(VALUE self, VALUE width, VALUE height);
extern VALUE a4r_API_create_sub_bitmap(VALUE self, VALUE parent, VALUE x, VALUE y, VALUE width, VALUE height);
extern VALUE a4r_API_create_video_bitmap(VALUE self, VALUE width, VALUE height);
extern VALUE a4r_API_destroy_bitmap(VALUE self, VALUE bitmap);
extern VALUE a4r_API_bitmap_mask_color(VALUE self, VALUE bmp);
extern VALUE a4r_API_acquire_bitmap(VALUE self, VALUE bmp);
extern VALUE a4r_API_release_bitmap(VALUE self, VALUE bmp);
extern VALUE a4r_API_acquire_screen(VALUE self);
extern VALUE a4r_API_release_screen(VALUE self);

//   Palette routines
extern VALUE a4r_API_set_palette(VALUE self, VALUE p);
extern VALUE a4r_API_get_palette(VALUE self, VALUE p);
extern VALUE a4r_API_default_palette(VALUE self);
extern VALUE a4r_API_black_palette(VALUE self);
extern VALUE a4r_API_desktop_palette(VALUE self);

//   Truecolor pixel formats
extern VALUE a4r_API_makecol(VALUE self, VALUE r, VALUE g, VALUE b);
extern VALUE a4r_API_palette_color(VALUE self);

//   Drawing primitives
extern VALUE a4r_API_clear_bitmap(VALUE self, VALUE bitmap);
extern VALUE a4r_API_clear_to_color(VALUE self, VALUE bitmap, VALUE color);
extern VALUE a4r_API_putpixel(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE color);
extern VALUE a4r_API_getpixel(VALUE self, VALUE bmp, VALUE x, VALUE y);
extern VALUE a4r_API_rectfill(VALUE self, VALUE bmp, VALUE x1, VALUE y1, VALUE x2, VALUE y2, VALUE color);
extern VALUE a4r_API_circle(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color);
extern VALUE a4r_API_circlefill(VALUE self, VALUE bmp, VALUE x, VALUE y, VALUE radius, VALUE color);

//   Blitting and sprites
extern VALUE a4r_API_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height);
extern VALUE a4r_API_masked_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height);

//   Fonts
extern VALUE a4r_API_load_font(VALUE self, VALUE filename, VALUE pal, VALUE param);
extern VALUE a4r_API_destroy_font(VALUE self, VALUE f);
extern VALUE a4r_API_extract_font_range(VALUE self, VALUE f, VALUE begin, VALUE end);
extern VALUE a4r_API_merge_fonts(VALUE self, VALUE f1, VALUE f2);

//   Text output
extern VALUE a4r_API_font(VALUE self);
extern VALUE a4r_API_font_set(VALUE self, VALUE f);
extern VALUE a4r_API_text_length(VALUE self, VALUE f, VALUE str);
extern VALUE a4r_API_text_height(VALUE self, VALUE f);
extern VALUE a4r_API_textout_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg);
extern VALUE a4r_API_textout_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg);
extern VALUE a4r_API_textprintf_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt);
extern VALUE a4r_API_textprintf_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt);
extern VALUE a4r_API_textprintf_right_ex(VALUE self, VALUE bmp, VALUE f, VALUE x, VALUE y, VALUE color, VALUE bg, VALUE fmt);

//   Transparency and patterened drawing
extern VALUE a4r_API_drawing_mode(VALUE self, VALUE mode, VALUE pattern, VALUE x_anchor, VALUE y_anchor);
extern VALUE a4r_API_solid_mode(VALUE self);

//   Direct access to video memory
extern VALUE a4r_API_bmp_select(VALUE self, VALUE bmp);
extern VALUE a4r_API_bmp_read8(VALUE self, VALUE addr);
extern VALUE a4r_API_bmp_read32(VALUE self, VALUE addr);
extern VALUE a4r_API_bmp_write8(VALUE self, VALUE addr, VALUE c);
extern VALUE a4r_API_bmp_write32(VALUE self, VALUE addr, VALUE c);
extern VALUE a4r_API_bmp_write_line(VALUE self, VALUE bmp, VALUE line);
extern VALUE a4r_API_bmp_read_line(VALUE self, VALUE bmp, VALUE line);
extern VALUE a4r_API_bmp_unwrite_line(VALUE self, VALUE bmp);

//   Fixed point math routines
extern VALUE a4r_API_itofix(VALUE self, VALUE x);
extern VALUE a4r_API_ftofix(VALUE self, VALUE x);
extern VALUE a4r_API_fixtof(VALUE self, VALUE x);
extern VALUE a4r_API_fixmul(VALUE self, VALUE x, VALUE y);
extern VALUE a4r_API_fixsqrt(VALUE self, VALUE x);

#endif //__ALLEGRO4R_H__
