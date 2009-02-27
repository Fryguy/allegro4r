#include "allegro4r.h"

/*
 * call-seq:
 *   itofix(x) -> num
 *
 * Converts an integer to fixed point. This is the same thing as x<<16. Remember
 * that overflows (trying to convert an integer greater than 32767) and
 * underflows (trying to convert an integer lesser than -32768) are not detected
 * even in debug builds! The values simply "wrap around". Example:
 *   # This conversion is OK.
 *   number = itofix(100)
 *   ASSERT(fixtoi(number) == 100)
 *   number = itofix(64000)
 *   # This check will fail in debug builds.
 *   ASSERT(fixtoi(number) == 64000)
 *
 * Return value: Returns the value of the integer converted to fixed point
 * ignoring overflows.
 */
VALUE a4r_API_itofix(VALUE self, VALUE x)
{
  return LONG2NUM(itofix(FIX2INT(x)));
}

/*
 * call-seq:
 *   ftofix(x) -> num
 *
 * Converts a floating point value to fixed point. Unlike itofix, this function
 * clamps values which could overflow the type conversion, setting 'errno' to
 * ERANGE in the process if this happens. Example:
 *   number = itofix(-40000)
 *   ASSERT(fixfloor(number) == -32768)
 *   number = itofix(64000)
 *   ASSERT(fixfloor(number) == 32767)
 *   ASSERT(errno == 0) # This will fail.
 *
 * Return value: Returns the value of the floating point value converted to
 * fixed point clamping overflows (and setting 'errno').
 */
VALUE a4r_API_ftofix(VALUE self, VALUE x)
{
  return LONG2NUM(ftofix(NUM2DBL(x)));
}

/*
 * call-seq:
 *   fixtof(x) -> float
 *
 * Converts fixed point to floating point. Example:
 *   # This will put 33.33333 into 'result'.
 *   result = fixtof(itofix(100) / 3)
 *   # This will put 16.66666 into 'result'.
 *   result = fixtof(itofix(100) / 6)
 */
VALUE a4r_API_fixtof(VALUE self, VALUE x)
{
  return rb_float_new(fixtof(NUM2LONG(x)));
}

/*
 * call-seq:
 *   fixmul(x, y) -> float
 *
 * A fixed point value can be multiplied or divided by an integer with the
 * normal '*' and '/' operators. To multiply two fixed point values, though, you
 * must use this function.
 *
 * If an overflow occurs, 'errno' will be set and the maximum possible value
 * will be returned, but 'errno' is not cleared if the operation is successful.
 * This means that if you are going to test for overflow you should set
 * 'errno=0' before calling fixmul. Example
 *   # This will put 30000 into 'result'.
 *   result = fixmul(itofix(10), itofix(3000))
 *   # But this overflows, and sets 'errno'.
 *   result = fixmul(itofix(100), itofix(3000))
 *   ASSERT(errno == 0)
 *
 * Return value: Returns the clamped result of multiplying 'x' by 'y', setting
 * 'errno' to ERANGE if there was an overflow.
 */
VALUE a4r_API_fixmul(VALUE self, VALUE x, VALUE y)
{
  return rb_float_new(fixmul(NUM2LONG(x), NUM2LONG(y)));
}

/*
 * call-seq:
 *   fixsqrt(x) -> float
 *
 * This finds out the non negative square root of 'x'. If 'x' is negative,
 * 'errno' is set to EDOM and the function returns zero.
 */
VALUE a4r_API_fixsqrt(VALUE self, VALUE x)
{
  return rb_float_new(fixsqrt(NUM2LONG(x)));
}
