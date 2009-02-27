#include "allegro4r.h"

/*
 * call-seq:
 *   jbi.b -> true or false
 *
 * Boolean on/off flag
 */
VALUE a4r_API_JOYSTICK_BUTTON_INFO_b(VALUE self)
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
VALUE a4r_API_JOYSTICK_BUTTON_INFO_name(VALUE self)
{
  JOYSTICK_BUTTON_INFO *jbi;
  Data_Get_Struct(self, JOYSTICK_BUTTON_INFO, jbi);
  return rb_str_new2(jbi->name);
}
