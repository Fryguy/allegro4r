require 'mkmf'
ext_name = 'allegro4r'
dir_config('allegro')
have_library('alleg')
create_makefile(ext_name)