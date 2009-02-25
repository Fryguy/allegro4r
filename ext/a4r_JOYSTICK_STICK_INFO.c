#include "allegro4r.h"

/*
 * Document-class: Allegro4r::API::JOYSTICK_STICK_INFO
 *
 * Stores the contents of joystick stick information.
 *
 * Read chapter "Joystick routines" for a description on how to obtain/use this
 * structure.
 */
VALUE cJOYSTICK_STICK_INFO;

/*
 * call-seq:
 *   jsi.flags -> int
 *
 * Status flags for this input
 */
VALUE a4r_JOYSTICK_STICK_INFO_flags(VALUE self)
{
  JOYSTICK_STICK_INFO *jsi;
  Data_Get_Struct(self, JOYSTICK_STICK_INFO, jsi);
  return INT2NUM(jsi->flags);
}

/*
 * call-seq:
 *   jsi.num_axis -> int
 *
 * How many axes do we have? (note the misspelling)
 */
VALUE a4r_JOYSTICK_STICK_INFO_num_axis(VALUE self)
{
  JOYSTICK_STICK_INFO *jsi;
  Data_Get_Struct(self, JOYSTICK_STICK_INFO, jsi);
  return INT2FIX(jsi->num_axis);
}

/*
 * call-seq:
 *   jsi.axis -> ary
 *
 * Axis state information
 */
VALUE a4r_JOYSTICK_STICK_INFO_axis(VALUE self)
{
  JOYSTICK_STICK_INFO *jsi;
  Data_Get_Struct(self, JOYSTICK_STICK_INFO, jsi);

  VALUE ret = rb_ary_new2(jsi->num_axis);
  long x;
  for (x = 0; x < jsi->num_axis; x++)
  {
    VALUE obj = Data_Wrap_Struct(cJOYSTICK_AXIS_INFO, 0, 0, &(jsi->axis[x]));
    rb_ary_store(ret, x, obj);
  }

  return ret;
}

/*
 * call-seq:
 *   jsi.name -> str
 *
 * Description of this input
 */
VALUE a4r_JOYSTICK_STICK_INFO_name(VALUE self)
{
  JOYSTICK_STICK_INFO *jsi;
  Data_Get_Struct(self, JOYSTICK_STICK_INFO, jsi);
  return rb_str_new2(jsi->name);
}
