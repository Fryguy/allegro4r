#include "allegro4r.h"

/*
 * call-seq:
 *   install_joystick(type) -> int
 *
 * Installs Allegro's joystick handler, and calibrates the centre position
 * values. The type parameter should usually be JOY_TYPE_AUTODETECT, or see the
 * platform specific documentation for a list of the available drivers. You must
 * call this routine before using any other joystick functions, and you should
 * make sure that all joysticks are in the middle position at the time. Example:
 *   textout_centre_ex(screen, font,
 *                     "Center the joystick and press a key",
 *                     SCREEN_W()/2, SCREEN_H()/2, red_color, -1)
 *   readkey
 *   if install_joystick(JOY_TYPE_AUTODETECT) != 0
 *     abort_on_error("Error initialising joystick!")
 *   end
 *
 * Return value: Returns zero on success. As soon as you have installed the
 * joystick module, you will be able to read the button state and digital
 * (on/off toggle) direction information, which may be enough for some games. If
 * you want to get full analogue input, though, you need to use the
 * calibrate_joystick functions to measure the exact range of the inputs: see
 * below.
 */
VALUE a4r_install_joystick(VALUE self, VALUE type)
{
  return INT2FIX(install_joystick(FIX2INT(type)));
}

/*
 * call-seq:
 *   poll_joystick -> int
 *
 * The joystick handler is not interrupt driven, so you need to call this
 * function every now and again to update the global position values. Example:
 *   loop do
 *     # Get joystick input
 *     poll_joystick
 *
 *     # Process input for the first joystick
 *     if joy[0].button[0].b
 *       first_button_pressed
 *     end
 *
 *     if joy[0].button[1].b
 *       second_button_pressed
 *     end
 *     ...
 *     break if done
 *   end
 *
 * Return value: Returns zero on success or a negative number on failure
 * (usually because no joystick driver was installed).
 */
VALUE a4r_poll_joystick(VALUE self)
{
  return INT2FIX(poll_joystick());
}

/*
 * call-seq:
 *   num_joysticks -> int
 *
 * Global variable containing the number of active joystick devices. The current
 * drivers support a maximum of eight controllers.
 */
VALUE a4r_num_joysticks(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return INT2FIX(num_joysticks);
}

/*
 * call-seq:
 *   joy -> ary
 *
 * Global array of joystick state information, which is updated by the
 * poll_joystick function. Only the first num_joysticks elements will contain
 * meaningful information. Joystick info is described by the JOYSTICK_INFO
 * class.
 * 
 * The button status is stored in the JOYSTICK_BUTTON_INFO class.
 *
 * You may wish to display the button names as part of an input configuration
 * screen to let the user choose what game function will be performed by each
 * button, but in simpler situations you can safely assume that the first two
 * elements in the button array will always be the main trigger controls.
 *
 * Each joystick will provide one or more stick inputs, of varying types. These
 * can be digital controls which snap to specific positions (eg. a gamepad
 * controller, the coolie hat on a Flightstick Pro or Wingman Extreme, or a
 * normal joystick which hasn't yet been calibrated), or they can be full
 * analogue inputs with a smooth range of motion. Sticks may also have different
 * numbers of axes, for example a normal directional control has two, but the
 * Flightstick Pro throttle is only a single axis, and it is possible that the
 * system could be extended in the future to support full 3d controllers. A
 * stick input is described by the JOYSTICK_STICK_INFO class.
 *
 * A single joystick may provide several different stick inputs, but you can
 * safely assume that the first element in the stick array will always be the
 * main directional controller.
 *
 * Information about each of the stick axis is stored in the subclass
 * JOYSTICK_AXIS_INFO.
 *
 * This provides both analogue input in the pos field (ranging from -128 to 128
 * or from 0 to 255, depending on the type of the control), and digital values
 * in the d1 and d2 fields. For example, when describing the X-axis position,
 * the pos field will hold the horizontal position of the joystick, d1 will be
 * set if it is moved left, and d2 will be set if it is moved right. Allegro
 * will fill in all these values regardless of whether it is using a digital or
 * analogue joystick, emulating the pos field for digital inputs by snapping it
 * to the min, middle, and maximum positions, and emulating the d1 and d2 values
 * for an analogue stick by comparing the current position with the centre
 * point.
 *
 * The joystick flags field may contain any combination of the bit flags:
 *
 * JOYFLAG_DIGITAL
 * This control is currently providing digital input.
 *
 * JOYFLAG_ANALOGUE
 * This control is currently providing analogue input.
 *
 * JOYFLAG_CALIB_DIGITAL
 * This control will be capable of providing digital input once it has been
 * calibrated, but is not doing this at the moment.
 *
 * JOYFLAG_CALIB_ANALOGUE
 * This control will be capable of providing analogue input once it has been
 * calibrated, but is not doing this at the moment.
 *
 * JOYFLAG_CALIBRATE
 * Indicates that this control needs to be calibrated. Many devices require
 * multiple calibration steps, so you should call the calibrate_joystick
 * function from a loop until this flag is cleared.
 *
 * JOYFLAG_SIGNED
 * Indicates that the analogue axis position is in signed format, ranging from
 * -128 to 128. This is the case for all 2d directional controls.
 *
 * JOYFLAG_UNSIGNED
 * Indicates that the analogue axis position is in unsigned format, ranging from
 * 0 to 255. This is the case for all 1d throttle controls.
 *
 * Note for people who spell funny: in case you don't like having to type
 * "analogue", there are some aliases h that will allow you to write "analog"
 * instead.
 */
VALUE a4r_joy(VALUE self)
{
  VALUE ret = rb_ary_new2(num_joysticks);
  long x;
  for (x = 0; x < num_joysticks; x++)
  {
    VALUE obj = Data_Wrap_Struct(cJOYSTICK_INFO, 0, 0, &(joy[x]));
    rb_ary_store(ret, x, obj);
  }

  return ret;
}

/*
 * call-seq:
 *   calibrate_joystick_name(n) -> str
 *
 * Pass the number of the joystick you want to calibrate as the parameter.
 *
 * Return value: Returns a text description for the next type of calibration
 * that will be done on the specified joystick, or nil if no more calibration is
 * required.
 */
VALUE a4r_calibrate_joystick_name(VALUE self, VALUE n)
{
  const char *s = calibrate_joystick_name(FIX2INT(n));
  if (s == NULL)
    return Qnil;
  else
    return rb_str_new2(s);
}

/*
 * call-seq:
 *   calibrate_joystick(n) -> int
 *
 * Most joysticks need to be calibrated before they can provide full analogue
 * input. This function performs the next operation in the calibration series
 * for the specified stick, assuming that the joystick has been positioned in
 * the manner described by a previous call to calibrate_joystick_name, returning
 * zero on success. For example, a simple routine to fully calibrate all the
 * joysticks might look like:
 *   (0...num_joysticks).each do |i|
 *     while joy[i].flags & JOYFLAG_CALIBRATE != 0
 *       msg = calibrate_joystick_name(i)
 *       textprintf_ex(..., "%s, and press a key\n" % msg)
 *       readkey
 *       if calibrate_joystick(i) != 0
 *         textprintf_ex(..., "oops!\n")
 *         readkey
 *         exit 1
 *       end
 *     end
 *   end
 *
 * Return value: Returns zero on success, non-zero if the calibration could not
 * be performed successfully.
 */
VALUE a4r_calibrate_joystick(VALUE self, VALUE n)
{
  return INT2FIX(calibrate_joystick(FIX2INT(n)));
}
