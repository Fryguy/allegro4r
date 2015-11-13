# http://wiki.allegro.cc/index.php?title=Allegro_5_Tutorial/Displays
require 'allegro4r'
include Allegro4r::API

def main
  raise "failed to initialize allegro!" unless al_init

  display = al_create_display(640, 480)
  raise "failed to create display!" if display.null?

  al_clear_to_color(al_map_rgb(50, 50, 0))
  al_flip_display
  al_rest(2)
  al_destroy_display(display)
end

run_main(method(:main))
