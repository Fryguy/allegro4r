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

static VALUE modAllegro4r;
static VALUE modAllegro4r_API;
static VALUE cBITMAP;
static VALUE cPALETTE;
static VALUE cFONT;

// Using Allegro

static VALUE al_allegro_init(VALUE self)
{
  return INT2FIX(allegro_init());
}

static VALUE al_allegro_exit(VALUE self)
{
  allegro_exit();
  return Qnil;
}

static VALUE al_allegro_error(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return rb_str_new2(allegro_error);
}

static VALUE al_allegro_message(VALUE self, VALUE text)
{
  // TODO: Allow parameter possing a lo printf for direct API consistency or force string only?
  allegro_message(StringValuePtr(text));
  return Qnil;
}

// Structures and types defined by Allegro

// Keyboard routines

static VALUE al_install_keyboard(VALUE self)
{
  return INT2FIX(install_keyboard());
}

static VALUE al_readkey(VALUE self)
{
  return INT2FIX(readkey());
}

// Graphic modes

static VALUE al_set_gfx_mode(VALUE self, VALUE card, VALUE w, VALUE h, VALUE v_w, VALUE v_h)
{
  return INT2FIX(set_gfx_mode(NUM2INT(card), FIX2INT(w), FIX2INT(h), FIX2INT(v_w), FIX2INT(v_h)));
}

// Bitmap objects

static VALUE al_screen(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  BITMAP *bmp = screen;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE al_SCREEN_W(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_W);
}

static VALUE al_SCREEN_H(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_H);
}

static VALUE al_create_bitmap(VALUE self, VALUE width, VALUE height)
{
  // TODO: Change to call destroy_bitmap on free?
  BITMAP *bmp = create_bitmap(FIX2INT(width), FIX2INT(height));
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

static VALUE al_destroy_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  destroy_bitmap(bmp);
  return Qnil;
}

static VALUE al_acquire_screen(VALUE self)
{
  acquire_screen();
  return Qnil;
}

static VALUE al_release_screen(VALUE self)
{
  release_screen();
  return Qnil;
}

// Pallette routines

static VALUE al_set_palette(VALUE self, VALUE palette)
{
  // TODO: Check data type of palette?
  PALETTE *pal;
  Data_Get_Struct(palette, PALETTE, pal);
  set_palette(*pal);
  return Qnil;
}

static VALUE al_desktop_palette(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  PALETTE *pal = &desktop_palette;
  VALUE obj = Data_Wrap_Struct(cPALETTE, 0, 0, pal);
  return obj;
}

// Truecolor pixel formats

static VALUE al_makecol(VALUE self, VALUE r, VALUE g, VALUE b)
{
  return INT2FIX(makecol(FIX2INT(r), FIX2INT(g), FIX2INT(b)));
}

static VALUE al_palette_color(VALUE self)
{
  // TODO: Cache the array, and only update if changed, or use hooked variable?
  VALUE ary = rb_ary_new2(PAL_SIZE);
  int x;
  for (x = 0; x < PAL_SIZE; x++)
    rb_ary_store(ary, x, INT2FIX(pallete_color[x]));
  return ary;
}

// Drawing primitives

static VALUE al_clear_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_bitmap(bmp);
  return Qnil;
}

static VALUE al_clear_to_color(VALUE self, VALUE bitmap, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  clear_to_color(bmp, FIX2INT(color));
  return Qnil;
}

static VALUE al_circle(VALUE self, VALUE bitmap, VALUE x, VALUE y, VALUE radius, VALUE color)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  circle(bmp, FIX2INT(x), FIX2INT(y), FIX2INT(radius), FIX2INT(color));
  return Qnil;
}

// Blitting and sprites

static VALUE al_blit(VALUE self, VALUE source, VALUE dest, VALUE source_x, VALUE source_y, VALUE dest_x, VALUE dest_y, VALUE width, VALUE height)
{
  BITMAP *bmp_source, *bmp_dest;
  Data_Get_Struct(source, BITMAP, bmp_source);
  Data_Get_Struct(dest, BITMAP, bmp_dest);
  blit(bmp_source, bmp_dest, FIX2INT(source_x), FIX2INT(source_y), FIX2INT(dest_x), FIX2INT(dest_y), FIX2INT(width), FIX2INT(height));
  return Qnil;
}

// Text output

static VALUE al_font(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  FONT *fnt = font;
  VALUE obj = Data_Wrap_Struct(cFONT, 0, 0, fnt);
  return obj;
}

static VALUE al_textout_centre_ex(VALUE self, VALUE bmp, VALUE f, VALUE s, VALUE x, VALUE y, VALUE color, VALUE bg)
{
  BITMAP *b;
  Data_Get_Struct(bmp, BITMAP, b);
  FONT *fnt;
  Data_Get_Struct(f, FONT, fnt);
  textout_centre_ex(b, fnt, StringValuePtr(s), FIX2INT(x), FIX2INT(y), FIX2INT(color), FIX2INT(bg));
  return Qnil;
}

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
  cFONT = rb_define_class_under(modAllegro4r_API, "FONT", rb_cObject);

  rb_define_module_function(modAllegro4r_API, "install_keyboard", al_install_keyboard, 0);
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
  rb_define_module_function(modAllegro4r_API, "desktop_palette", al_desktop_palette, 0);

  rb_define_module_function(modAllegro4r_API, "makecol", al_makecol, 3);
  rb_define_module_function(modAllegro4r_API, "palette_color", al_palette_color, 0);

  rb_define_module_function(modAllegro4r_API, "clear_bitmap", al_clear_bitmap, 1);
  rb_define_module_function(modAllegro4r_API, "clear_to_color", al_clear_to_color, 2);
  rb_define_module_function(modAllegro4r_API, "circle", al_circle, 5);

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
