#include "allegro4r.h"

/*
 * call-seq:
 *   ustrzncpy(src, n) -> str
 *
 * This function is like ustrzcpy except that no more than 'n' characters from
 * 'src' are copied into 'dest'. If 'src' is shorter than 'n' characters, null
 * characters are appended to 'dest' as padding until 'n' characters have been
 * written. In any case, 'dest' is guaranteed to be null-terminated.
 *
 * Note that, even for empty strings, your destination string must have at least
 * enough bytes to store the terminating null character of the string, and your
 * parameter 'size' must reflect this. Otherwise, the debug version of Allegro
 * will abort at an assertion, and the release version of Allegro will overrun
 * the destination buffer.
 *
 * Return value: The return value is the value of 'dest'.
 *
 * *** The Ruby method signature differs from the Allegro method signature. The
 * Allegro signature takes a dest by reference, and a size, but the Ruby
 * signature returns a string containing the dest.  The returned string will
 * have null characters appended as per the description above.
 */
VALUE a4r_ustrzncpy(VALUE self, VALUE src, VALUE n)
{
  int size = FIX2INT(n) + 1;
  char *dest = ALLOC_N(char, size);
  ustrzncpy(dest, size, StringValuePtr(src), size);
  VALUE s = rb_str_new(dest, size - 1);
  free(dest);
  return s;
}

/*
 * call-seq:
 *   usprintf(format) -> str
 *
 * This function writes formatted data into the output buffer. A NULL character
 * is written to mark the end of the string. You should try to avoid this
 * function because it is very easy to overflow the destination buffer. Use
 * uszprintf instead.
 *
 * Return value: Returns the number of characters written, not including the
 * terminating null character.
 *
 * *** The Ruby method differs from the Allegro method. The Allegro signature
 * takes a dest but the Ruby signature returns a string containing the dest.
 */
VALUE a4r_usprintf(VALUE self, VALUE format)
{
  return format;
}
