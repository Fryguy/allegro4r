require 'mkmf'
ext_name = 'allegro4r'
dir_config('allegro')
raise "Allegro libraries are not found." unless have_library('alleg')

if RUBY_PLATFORM !~ /mingw/
  $LDFLAGS << ' ' + `allegro-config --libs`.chomp
  $CFLAGS << ' ' + `allegro-config --cflags`.chomp
end

create_makefile(ext_name)