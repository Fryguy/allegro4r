#include "allegro4r.h"

/*
 * call-seq:
 *   get_filename(path) -> str
 *
 * Finds out the filename portion of a completely specified file path. Both '\'
 * and '/' are recognized as directory separators under DOS and Windows.
 * However, only '/' is recognized as directory separator under other platforms.
 * Example:
 *   name = get_executable_name
 *   allegro_message("Running '%s'\n" % get_filename(name))
 *
 * Note that Allegro won't perform any IO operations during the verification.
 * This means that if you have '/a/path/like/this/', which doesn't have a
 * filename, the function will return an empty string. However, if you have
 * '/a/path/like/this', Allegro will return 'this', even if it is a valid
 * directory.
 *
 * Return value: Returns a string with the filename, or the beginning of 'path'
 * if no valid filename is found (eg. you are processing a path with backslashes
 * under Unix).
 */
VALUE a4r_API_get_filename(VALUE self, VALUE path)
{
  return rb_str_new2(get_filename(StringValuePtr(path)));
}
