#include "allegro4r.h"

/*
 * call-seq:
 *   ji.flags -> int
 *
 * Status flags for this joystick
 */
VALUE a4r_API_JOYSTICK_INFO_flags(VALUE self)
{
  JOYSTICK_INFO *ji;
  Data_Get_Struct(self, JOYSTICK_INFO, ji);
  return INT2NUM(ji->flags);
}

/*
 * call-seq:
 *   ji.num_sticks -> int
 *
 * How many stick inputs?
 */
VALUE a4r_API_JOYSTICK_INFO_num_sticks(VALUE self)
{
  JOYSTICK_INFO *ji;
  Data_Get_Struct(self, JOYSTICK_INFO, ji);
  return INT2FIX(ji->num_sticks);
}

/*
 * call-seq:
 *   ji.num_buttons -> int
 *
 * How many buttons?
 */
VALUE a4r_API_JOYSTICK_INFO_num_buttons(VALUE self)
{
  JOYSTICK_INFO *ji;
  Data_Get_Struct(self, JOYSTICK_INFO, ji);
  return INT2FIX(ji->num_buttons);
}

/*
 * call-seq:
 *   ji.stick -> ary
 *
 * Stick state information
 */
VALUE a4r_API_JOYSTICK_INFO_stick(VALUE self)
{
  JOYSTICK_INFO *ji;
  Data_Get_Struct(self, JOYSTICK_INFO, ji);

  VALUE ret = rb_ary_new2(ji->num_sticks);
  long x;
  for (x = 0; x < ji->num_sticks; x++)
  {
    VALUE obj = Data_Wrap_Struct(cAPI_JOYSTICK_STICK_INFO, 0, 0, &(ji->stick[x]));
    rb_ary_store(ret, x, obj);
  }

  return ret;
}

/*
 * call-seq:
 *   ji.button -> ary
 *
 * Button state information
 */
VALUE a4r_API_JOYSTICK_INFO_button(VALUE self)
{
  JOYSTICK_INFO *ji;
  Data_Get_Struct(self, JOYSTICK_INFO, ji);

  VALUE ret = rb_ary_new2(ji->num_buttons);
  long x;
  for (x = 0; x < ji->num_buttons; x++)
  {
    VALUE obj = Data_Wrap_Struct(cAPI_JOYSTICK_BUTTON_INFO, 0, 0, &(ji->button[x]));
    rb_ary_store(ret, x, obj);
  }

  return ret;
}
