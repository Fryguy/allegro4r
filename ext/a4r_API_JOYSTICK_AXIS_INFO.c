#include "allegro4r.h"

/*
 * call-seq:
 *   jai.pos -> int
 *
 * Analogue axis position
 */
VALUE a4r_API_JOYSTICK_AXIS_INFO_pos(VALUE self)
{
  JOYSTICK_AXIS_INFO *jai;
  Data_Get_Struct(self, JOYSTICK_AXIS_INFO, jai);
  return INT2FIX(jai->pos);
}

/*
 * call-seq:
 *   jai.d1 -> true or false
 *
 * Digital axis position
 */
VALUE a4r_API_JOYSTICK_AXIS_INFO_d1(VALUE self)
{
  JOYSTICK_AXIS_INFO *jai;
  Data_Get_Struct(self, JOYSTICK_AXIS_INFO, jai);
  return jai->d1 ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   jai.d2 -> true or false
 *
 * Digital axis position
 */
VALUE a4r_API_JOYSTICK_AXIS_INFO_d2(VALUE self)
{
  JOYSTICK_AXIS_INFO *jai;
  Data_Get_Struct(self, JOYSTICK_AXIS_INFO, jai);
  return jai->d2 ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   jai.name -> int
 *
 * Description of this axis
 */
VALUE a4r_API_JOYSTICK_AXIS_INFO_name(VALUE self)
{
  JOYSTICK_AXIS_INFO *jai;
  Data_Get_Struct(self, JOYSTICK_AXIS_INFO, jai);
  return rb_str_new2(jai->name);
}
