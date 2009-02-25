#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::JOYSTICK_BUTTON_INFO
 *
 * Stores the contents of joystick button information.
 *
 * Read chapter "Joystick routines" for a description on how to obtain/use this
 * structure.
 */
VALUE cJOYSTICK_BUTTON_INFO;

/*
 * call-seq:
 *   jbi.b -> true or false
 *
 * Boolean on/off flag
 */
VALUE a4r_JOYSTICK_BUTTON_INFO_b(VALUE self)
{
  JOYSTICK_BUTTON_INFO *jbi;
  Data_Get_Struct(self, JOYSTICK_BUTTON_INFO, jbi);
  return jbi->b ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   jbi.name -> str
 *
 * Description of this button
 */
VALUE a4r_JOYSTICK_BUTTON_INFO_name(VALUE self)
{
  JOYSTICK_BUTTON_INFO *jbi;
  Data_Get_Struct(self, JOYSTICK_BUTTON_INFO, jbi);
  return rb_str_new2(jbi->name);
}
