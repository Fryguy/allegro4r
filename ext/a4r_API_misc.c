#include "allegro4r.h"

/*
 * call-seq:
 *   MIN(x, y) -> num
 *
 */
VALUE a4r_API_MIN(VALUE self, VALUE x, VALUE y)
{
  return INT2NUM(MIN(NUM2INT(x), NUM2INT(y)));
}

/*
 * call-seq:
 *   ABS(x) -> num
 *
 */
VALUE a4r_API_ABS(VALUE self, VALUE x)
{
  return INT2NUM(ABS(NUM2INT(x)));
}

/*
 * call-seq:
 *   AL_RAND -> num
 *
 * On platforms that require it, this macro does a simple shift transformation
 * of the libc rand() function, in order to improve the perceived randomness of
 * the output series in the lower 16 bits. Where not required, it directly
 * translates into a rand() call.
 */
VALUE a4r_API_AL_RAND(VALUE self)
{
  return INT2NUM(AL_RAND());
}

/*
 * call-seq:
 *   gfx_driver -> gfx_driver
 *
 * Global reference to the graphics driver.
 */
VALUE a4r_API_gfx_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  GFX_DRIVER *driver = gfx_driver;
  VALUE obj = Data_Wrap_Struct(cAPI_GFX_DRIVER, 0, 0, driver);
  return obj;
}

/*
 * call-seq:
 *   mouse_driver -> mouse_driver
 *
 * Global reference to the mouse driver.
 */
VALUE a4r_API_mouse_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  MOUSE_DRIVER *driver = mouse_driver;
  VALUE obj = Data_Wrap_Struct(cAPI_MOUSE_DRIVER, 0, 0, driver);
  return obj;
}

/*
 * call-seq:
 *   timer_driver -> timer_driver
 *
 * Global reference to the timer driver.
 */
VALUE a4r_API_timer_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  TIMER_DRIVER *driver = timer_driver;
  VALUE obj = Data_Wrap_Struct(cAPI_TIMER_DRIVER, 0, 0, driver);
  return obj;
}

/*
 * call-seq:
 *   keyboard_driver -> keyboard_driver
 *
 * Global reference to the keyboard driver.
 */
VALUE a4r_API_keyboard_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  KEYBOARD_DRIVER *driver = keyboard_driver;
  VALUE obj = Data_Wrap_Struct(cAPI_KEYBOARD_DRIVER, 0, 0, driver);
  return obj;
}

/*
 * call-seq:
 *   joystick_driver -> joystick_driver
 *
 * Global reference to the joystick driver.
 */
VALUE a4r_API_joystick_driver(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  JOYSTICK_DRIVER *driver = joystick_driver;
  VALUE obj = Data_Wrap_Struct(cAPI_JOYSTICK_DRIVER, 0, 0, driver);
  return obj;
}
