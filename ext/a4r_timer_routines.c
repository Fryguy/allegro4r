#include "allegro4r.h"

/*
 * call-seq:
 *   install_timer -> int
 *
 * Installs the Allegro timer interrupt handler. You must do this before
 * installing any user timer routines, and also before displaying a mouse
 * pointer, playing FLI animations or MIDI music, and using any of the GUI
 * routines.
 *
 * Return value: Returns zero on success, or a negative number on failure (but
 * you may decide not to check the return value as this function is very
 * unlikely to fail).
 */
VALUE a4r_install_timer(VALUE self)
{
  return INT2FIX(install_timer());
}

/*
 * call-seq:
 *   install_int(name, speed) -> int
 *
 * Installs a user timer handler, with the speed given as the number of
 * milliseconds between ticks. This is the same thing as install_int_ex(name,
 * MSEC_TO_TIMER(speed)). If you call this routine without having first
 * installed the timer module, install_timer will be called automatically.
 * Calling again this routine with the same timer handler as parameter allows
 * you to adjust its speed.
 *
 * Return value: Returns zero on success, or a negative number if there is no
 * room to add a new user timer.
 *
 * *** The Ruby method differs from the Allegro method. The Allegro method takes
 * a function pointer as the first parameter, which it will use as the timer
 * interrupt callback.  The Ruby method takes a name which will be used to
 * identify a predefined counter routine which will be used as the interrupt
 * callback. To get the value for that counter, call timer_counter_get with the
 * name.
 */
VALUE a4r_install_int(VALUE self, VALUE name, VALUE speed)
{
  VALUE t_speed = LONG2NUM(MSEC_TO_TIMER(FIX2INT(speed)));
  return a4r_install_int_ex(self, name, t_speed);
}

/*
 * call-seq:
 *   install_int_ex(name, speed) -> int
 *
 * Adds a function to the list of user timer handlers or, if it is already
 * installed, retroactively adjusts its speed (i.e makes as though the speed
 * change occurred precisely at the last tick). The speed is given in hardware
 * clock ticks, of which there are 1193181 a second. You can convert from other
 * time formats to hardware clock ticks with the macros:
 *   SECS_TO_TIMER(secs)  - give the number of seconds between each tick
 *   MSEC_TO_TIMER(msec)  - give the number of milliseconds between ticks
 *   BPS_TO_TIMER(bps)    - give the number of ticks each second
 *   BPM_TO_TIMER(bpm)    - give the number of ticks per minute
 *
 * There can only be sixteen timers in use at a time, and some other parts of
 * Allegro (the GUI code, the mouse pointer display routines, rest, the FLI
 * player, and the MIDI player) need to install handlers of their own, so you
 * should avoid using too many at the same time. If you call this routine
 * without having first installed the timer module, install_timer will be called
 * automatically. 
 *
 * Return value: Returns zero on success, or a negative number if there is no
 * room to add a new user timer.
 *
 * *** The Ruby method differs from the Allegro method. The Allegro method takes
 * a function pointer as the first parameter, which it will use as the timer
 * interrupt callback.  The Ruby method takes a name which will be used to
 * identify a predefined counter routine which will be used as the interrupt
 * callback. To get the value for that counter, call timer_counter_get with the
 * name.
 */
VALUE a4r_install_int_ex(VALUE self, VALUE name, VALUE speed)
{
  VALUE i = find_timer_counter(name);
  if (i == Qnil)
  {
    i = find_free_timer_counter();
    rb_hash_aset(timer_counter_names, name, i);
    timer_counters[FIX2INT(i)] = 0;
  }

  return INT2FIX(install_param_int_ex(&timer_counter_incr, (void *)&(timer_counters[FIX2INT(i)]), NUM2INT(speed)));
}

/*
 * call-seq:
 *   LOCK_VARIABLE(variable_name) -> nil
 *
 * Due to interrupts, you are required to lock all the memory used by your timer
 * routines. See the description of install_int_ex for a more detailed
 * explanation and usage example.
 *
 * *** The Ruby method differs from the Allegro method. Due to the use of
 * predefined timer routines, LOCK_VARIABLE and LOCK_FUNCTION do nothing, and
 * are here simply for API consistency. They will raise warnings if the Ruby
 * script is run with -w.
 */
VALUE a4r_LOCK_VARIABLE(VALUE self, VALUE variable_name)
{
  rb_warning("Allegro4r::API::LOCK_VARIABLE does nothing.");
  return Qnil;
}

/*
 * call-seq:
 *   LOCK_FUNCTION(function_name) -> nil
 *
 * See LOCK_VARIABLE.
 */
VALUE a4r_LOCK_FUNCTION(VALUE self, VALUE function_name)
{
  rb_warning("Allegro4r::API::LOCK_FUNCTION does nothing.");
  return Qnil;
}

/*
 * call-seq:
 *   retrace_count -> int
 *
 * If the retrace simulator is installed, this count is incremented on each
 * vertical retrace; otherwise, if the refresh rate is known, the count is
 * incremented at the same rate (ignoring retraces); otherwise, it is
 * incremented 70 times a second. This provides a way of controlling the speed
 * of your program without installing user timer functions.
 */
VALUE a4r_retrace_count(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return INT2FIX(retrace_count);
}

/*
 * call-seq:
 *   rest(time) -> nil
 *
 * This function waits for the specified number of milliseconds.
 *
 * Passing 0 as parameter will not wait, but just yield. This can be useful in
 * order to "play nice" with other processes. Other values will cause CPU time
 * to be dropped on most platforms. This will look better to users, and also
 * does things like saving battery power and making fans less noisy.
 *
 * Note that calling this inside your active game loop is a bad idea, as you
 * never know when the OS will give you the CPU back, so you could end up
 * missing the vertical retrace and skipping frames. On the other hand, on
 * multitasking operating systems it is good form to give up the CPU for a while
 * if you will not be using it.
 */
VALUE a4r_rest(VALUE self, VALUE time)
{
  rest(NUM2UINT(time));
  return Qnil;
}

/*
 * call-seq:
 *   SECS_TO_TIMER(secs) -> num
 *
 * Give the number of seconds between each tick
 */
VALUE a4r_SECS_TO_TIMER(VALUE self, VALUE secs)
{
  return LONG2NUM(SECS_TO_TIMER(NUM2LONG(secs)));
}

/*
 * call-seq:
 *   MSEC_TO_TIMER(msec) -> num
 *
 * Give the number of milliseconds between ticks
 */
VALUE a4r_MSEC_TO_TIMER(VALUE self, VALUE msec)
{
  return LONG2NUM(MSEC_TO_TIMER(NUM2LONG(msec)));
}

/*
 * call-seq:
 *   BPS_TO_TIMER(bps) -> num
 *
 * Give the number of ticks each second
 */
VALUE a4r_BPS_TO_TIMER(VALUE self, VALUE bps)
{
  return LONG2NUM(BPS_TO_TIMER(NUM2LONG(bps)));
}

/*
 * call-seq:
 *   BPM_TO_TIMER(bpm) -> num
 *
 * Give the number of ticks per minute
 */
VALUE a4r_BPM_TO_TIMER(VALUE self, VALUE bpm)
{
  return LONG2NUM(BPM_TO_TIMER(NUM2LONG(bpm)));
}

/******************************************************************************/
// Predefined timer counter routines

VALUE timer_counter_names;
volatile int timer_counters[MAX_TIMER_COUNTERS];

void timer_counter_incr(void *param)
{
  *((int *)param) += 1;
}
END_OF_FUNCTION(timer_counter_incr)

VALUE find_timer_counter(VALUE name)
{
  return rb_hash_aref(timer_counter_names, name);
}

VALUE find_free_timer_counter()
{
  int i;
  ID f = rb_intern("has_value?");
  for (i = 0; i < MAX_TIMER_COUNTERS; i++)
    if (rb_funcall(timer_counter_names, f, 1, INT2FIX(i)) == Qfalse)
      break;

  if (i == MAX_TIMER_COUNTERS)
    return Qnil;
  return INT2FIX(i);
}

/*
 * call-seq:
 *   timer_counter_get(name) -> int
 *
 * Returns the value of the specified timer counter.
 * 
 * *** This is not an Allegro method. See the Ruby note under install_int_ex.
 */
VALUE a4r_timer_counter_get(VALUE self, VALUE name)
{
  VALUE i = find_timer_counter(name);
  if (i == Qnil)
    return i;
  return INT2FIX(timer_counters[FIX2INT(i)]);
}
