#include "allegro4r.h"

/*
 * call-seq:
 *   install_mouse -> int
 *
 * Installs the Allegro mouse handler. You must do this before using any other
 * mouse functions.
 *
 * Return value: Returns -1 on failure, zero if the mouse handler is already
 * installed (in which case this function does nothing) and the number of
 * buttons on the mouse if the mouse handler has successfully been installed
 * (ie. this is the first time a handler is installed or you have removed the
 * previous one).
 *
 * Note that the number of mouse buttons returned by this function is more an
 * indication than a physical reality. With most devices there is no way of
 * telling how many buttons there are, and any user can override the number of
 * mouse buttons returned by this function with a custom configuration file and
 * the variable num_buttons. Even if this value is overridden by the user, the
 * global mouse variables will still report whatever the hardware is sending.
 */
VALUE a4r_install_mouse(VALUE self)
{
  return INT2FIX(install_mouse());
}

/*
 * call-seq:
 *   poll_mouse -> int
 *
 * Wherever possible, Allegro will read the mouse input asynchronously (ie. from
 * inside an interrupt handler), but on some platforms that may not be possible,
 * in which case you must call this routine at regular intervals to update the
 * mouse state variables. To help you test your mouse polling code even if you
 * are programming on a platform that doesn't require it, after the first time
 * that you call this function Allegro will switch into polling mode, so from
 * that point onwards you will have to call this routine in order to get any
 * mouse input at all, regardless of whether the current driver actually needs
 * to be polled or not.
 *
 * Return value: Returns zero on success, or a negative number on failure (ie.
 * no mouse driver installed).
 */
VALUE a4r_poll_mouse(VALUE self)
{
  return INT2FIX(poll_mouse());
}

/*
 * call-seq:
 *   mouse_x -> int
 *
 * Global variables containing the current mouse position and button state.
 * Wherever possible these values will be updated asynchronously, but if
 * mouse_needs_poll returns true, you must manually call poll_mouse to update
 * them with the current input state. The 'mouse_x' and 'mouse_y' positions are
 * integers ranging from zero to the bottom right corner of the screen. The
 * 'mouse_z' and 'mouse_w' variables hold the current vertical and horizontal
 * wheel position, when using an input driver that supports wheel mice. The
 * 'mouse_b' variable is a bitfield indicating the state of each button: bit 0
 * is the left button, bit 1 the right, and bit 2 the middle button. Additional
 * non standard mouse buttons might be available as higher bits in this
 * variable. Usage example:
 *   printf("Left button is pressed\n") if (mouse_b & 1) > 0
 *
 *   printf("Right button is not pressed\n") if (mouse_b & 2) != 0
 *
 * The 'mouse_pos' variable has the current X coordinate in the upper 16 bits
 * and the Y in the lower 16 bits. This may be useful in tight polling loops
 * where a mouse interrupt could occur between your reading of the two separate
 * variables, since you can copy this value into a local variable with a single
 * instruction and then split it up at your leisure. Example:
 *   pos = mouse_pos
 *   x = pos >> 16
 *   y = pos & 0x0000ffff
 */
VALUE a4r_mouse_x(VALUE self)
{
  return INT2FIX(mouse_x);
}

/*
 * call-seq:
 *   mouse_y -> int
 *
 * See mouse_x.
 */
VALUE a4r_mouse_y(VALUE self)
{
  return INT2FIX(mouse_y);
}

/*
 * call-seq:
 *   mouse_z -> int
 *
 * See mouse_x.
 */
VALUE a4r_mouse_z(VALUE self)
{
  return INT2FIX(mouse_z);
}

/*
 * call-seq:
 *   mouse_w -> int
 *
 * See mouse_x.
 */
VALUE a4r_mouse_w(VALUE self)
{
  return INT2FIX(mouse_w);
}

/*
 * call-seq:
 *   mouse_b -> int
 *
 * See mouse_x.
 */
VALUE a4r_mouse_b(VALUE self)
{
  return INT2FIX(mouse_b);
}

/*
 * call-seq:
 *   show_mouse(bmp) -> nil
 *
 * Tells Allegro to display a mouse pointer on the screen. This will only work
 * if the timer module has been installed. The mouse pointer will be drawn onto
 * the specified bitmap, which should normally be 'screen' (see later for
 * information about bitmaps). To hide the mouse pointer, call show_mouse(nil).
 *
 * Warning: if you draw anything onto the screen while the pointer is visible, a
 * mouse movement interrupt could occur in the middle of your drawing operation.
 * If this happens the mouse buffering and graphics drawing code will get
 * confused and will leave 'mouse droppings' all over the screen. To prevent
 * this, you must make sure you turn off the mouse pointer whenever you draw
 * onto the screen. This is not needed if you are using a hardware cursor.
 *
 * Note: you must not be showing a mouse pointer on a bitmap at the time that
 * the bitmap is destroyed with destroy_bitmap, e.g. call show_mouse(nil) before
 * destroying the bitmap. This does not apply to 'screen' since you never
 * destroy 'screen' with destroy_bitmap.
 */
VALUE a4r_show_mouse(VALUE self, VALUE bmp)
{
  BITMAP *b;
  if (bmp == Qnil)
    b = NULL;
  else
    Data_Get_Struct(bmp, BITMAP, b);
  show_mouse(b);
  return Qnil;
}

/*
 * call_seq:
 *   get_mouse_mickeys -> [int_x, int_y]
 *
 * Measures how far the mouse has moved since the last call to this function.
 * The values of mickeyx and mickeyy will become negative if the mouse is moved
 * left or up, respectively. The mouse will continue to generate movement
 * mickeys even when it reaches the edge of the screen, so this form of input
 * can be useful for games that require an infinite range of mouse movement.
 *
 * Note that the infinite movement may not work in windowed mode, since under
 * some platforms the mouse would leave the window, and may not work at all if
 * the hardware cursor is in use.
 *
 * *** The Ruby method signature differs from the Allegro method signature. The
 * Allegro signature take int_x and int_y by reference, but the Ruby signature
 * returns an array containing the values of int_x and int_y.
 */
VALUE a4r_get_mouse_mickeys(VALUE self)
{
  int x, y;
  get_mouse_mickeys(&x, &y);
  return rb_ary_new3(2, INT2FIX(x), INT2FIX(y));
}

/*
 * call-seq:
 *   set_mouse_sprite(bmp) -> nil
 *
 * You don't like Allegro's mouse pointer? No problem. Use this function to
 * supply an alternative of your own. If you change the pointer and then want to
 * get Allegro's lovely arrow back again, call set_mouse_sprite(nil).
 *
 * As a bonus, set_mouse_sprite(nil) uses the current palette in choosing colors
 * for the arrow. So if your arrow mouse sprite looks ugly after changing the
 * palette, call set_mouse_sprite(nil).
 */
VALUE a4r_set_mouse_sprite(VALUE self, VALUE bmp)
{
  BITMAP *b;
  if (bmp == Qnil)
    b = NULL;
  else
    Data_Get_Struct(bmp, BITMAP, b);
  set_mouse_sprite(b);
  return Qnil;
}

/*
 * call-seq:
 *   set_mouse_sprite_focus(x, y) -> nil
 *
 * The mouse focus is the bit of the pointer that represents the actual mouse
 * position, ie. the (mouse_x, mouse_y) position. By default this is the top
 * left corner of the arrow, but if you are using a different mouse pointer you
 * might need to alter it.
 */
VALUE a4r_set_mouse_sprite_focus(VALUE self, VALUE x, VALUE y)
{
  set_mouse_sprite_focus(FIX2INT(x), FIX2INT(y));
  return Qnil;
}
