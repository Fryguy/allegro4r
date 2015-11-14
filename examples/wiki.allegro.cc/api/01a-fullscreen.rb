# https://wiki.allegro.cc/index.php?title=Creating_a_fullscreen_display_with_maximum/minimum_resolution
require 'allegro4r'
include Allegro4r::API
include Allegro4r::API::Image
include Allegro4r::API::Primitives

def main
  disp_data = ALLEGRODISPLAYMODE.new

  al_init # I'm not checking the return value for simplicity.
  al_init_image_addon
  al_init_primitives_addon

  al_get_display_mode(al_get_num_display_modes - 1, disp_data)

  al_set_new_display_flags(ALLEGRO_FULLSCREEN)
  display = al_create_display(disp_data[:width], disp_data[:height])

  al_rest(3)
  al_destroy_display(display)
end

run_main(method(:main))
