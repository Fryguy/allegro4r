#include "allegro.h"
#include "winalleg.h"
#include "ruby.h"

static VALUE t_init(VALUE self)
{
  install_allegro(SYSTEM_AUTODETECT, &errno, NULL);
  return self;
}

static VALUE t_allegro_exit(VALUE self)
{
  allegro_exit();
  return self;
}

VALUE cAllegro;
void Init_allegro4r()
{
  cAllegro = rb_define_class("Allegro4r", rb_cObject);
  rb_define_method(cAllegro, "initialize", t_init, 0);
  rb_define_method(cAllegro, "allegro_exit", t_allegro_exit, 0);
}

/* needed if Allegro is built as a shared library */
int main()
{
	return 0;
}
END_OF_MAIN()
