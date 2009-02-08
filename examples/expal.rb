#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to manipulate the palette. It draws
# a set of concentric circles onto the screen and animates them by
# cycling the palette.
#

require 'allegro4r'
include Allegro4r::API

begin
  palette = PALETTE.new

  exit 1 if allegro_init != 0
  install_keyboard
  if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
    if set_gfx_mode(GFX_AUTODETECT, 640, 480, 0, 0) != 0
      allegro_message("Error setting graphics mode\n%s\n" % allegro_error)
      exit 1
    end
  end

  # first set the palette to black to hide what we are doing
  set_palette(black_palette)

  # draw some circles onto the screen
  acquire_screen

  255.downto(1) do |c|
    circlefill(screen, SCREEN_W()/2, SCREEN_H()/2, c, c)
  end

  release_screen

  install_mouse
  show_mouse(screen)

  # fill our palette with a gradually altering sequence of colors
  (0...64).each do |c|
    palette[c].r = c;
    palette[c].g = 0;
    palette[c].b = 0;
  end
  (64...128).each do |c|
    palette[c].r = 127 - c;
    palette[c].g = c - 64;
    palette[c].b = 0;
  end
  (128...192).each do |c|
    palette[c].r = 0;
    palette[c].g = 191 - c;
    palette[c].b = c - 128;
  end
  (192...256).each do |c|
    palette[c].r = 0;
    palette[c].g = 0;
    palette[c].b = 255 - c;
  end

  # animate the image by rotating the palette
  while !keypressed do
    temp = palette[255].dup
    255.downto(1) do |c|
      palette[c] = palette[c - 1]
    end
    palette[0] = temp
    set_palette(palette)
  end
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end


