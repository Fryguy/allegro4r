#include "allegro4r.h"

VALUE a4r_install_timer(VALUE self)
{
  return INT2FIX(install_timer());
}

VALUE a4r_retrace_count(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return INT2FIX(retrace_count);
}
