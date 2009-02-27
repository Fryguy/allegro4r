#
# Example program (C version) for the Allegro library, by Evert Glebbeek.
#   (Ruby port by Jason Frey)
#
# This is a very simple program showing how to load and manipulate fonts.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

# you should always do this at the start of Allegro programs
exit 1 if allegro_init != 0

# set up the keyboard handler
install_keyboard

# set a graphics mode sized 320x200
if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
  if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
    exit 1
  end
end

# set the color palette
set_palette(desktop_palette)

# clear the screen to white
clear_to_color(screen, makecol(255, 255, 255))

# We will use the lower case letters from Allegro's normal font and the
# uppercase letters from the font in unifont.dat
f1 = load_font("unifont.dat", nil, nil)
if f1.nil?
  set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
  allegro_message("Cannot find unifont.dat in current directory.\n")
  exit 1
end

# Extract character ranges
f2 = extract_font_range(font, ' '[0], ?A - 1)
f3 = extract_font_range(f1, ?A, ?Z);
f4 = extract_font_range(font, ?Z + 1, ?z)

# Merge fonts
Allegro4r::API.font = merge_fonts(f4, f5 = merge_fonts(f2, f3))

# Destroy temporary fonts
destroy_font(f1)
destroy_font(f2)
destroy_font(f3)
destroy_font(f4)
destroy_font(f5)

# you don't need to do this, but on some platforms (eg. Windows) things
# will be drawn more quickly if you always acquire the screen before
# trying to draw onto it.
acquire_screen

# write some text to the screen with black letters and transparent
# background
textout_centre_ex(screen, font, "Hello, world!", SCREEN_W()/2, SCREEN_H()/2, makecol(0, 0, 0), -1)

# you must always release bitmaps before calling any input functions
release_screen

# wait for a key press
readkey
