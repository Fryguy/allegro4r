#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to play samples. You have to
# use this example from the command line to specify as first
# parameter a WAV or VOC sound file to play. If the file is
# loaded successfully, the sound will be played in an infinite
# loop. While it is being played, you can use the left and right
# arrow keys to modify the panning of the sound. You can also
# use the up and down arrow keys to modify the pitch.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

pan = 128
pitch = 1000

exit 1 if allegro_init != 0

if ARGV.length != 1
  allegro_message("Usage: 'ruby exsample.rb filename.[wav|voc]'\n")
  exit 1
end

install_keyboard
install_timer

# install a digital sound driver
if install_sound(DIGI_AUTODETECT, MIDI_NONE, nil) != 0
  allegro_message("Error initialising sound system\n%s\n" % allegro_error)
  exit 1
end

# read in the WAV file
the_sample = load_sample(ARGV[0])
if the_sample.nil?
  allegro_message("Error reading WAV file '%s'\n" % ARGV[0])
  exit 1
end

if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
  if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
    exit 1
  end
end

set_palette(desktop_palette)
clear_to_color(screen, makecol(255,255,255))

textprintf_centre_ex(screen, font, SCREEN_W()/2, SCREEN_H()/3, makecol(0, 0, 0), -1, "Driver: %s" % digi_driver.name)
textprintf_centre_ex(screen, font, SCREEN_W()/2, SCREEN_H()/2, makecol(0, 0, 0), -1, "Playing %s" % ARGV[0])
textprintf_centre_ex(screen, font, SCREEN_W()/2, SCREEN_H()*2/3, makecol(0, 0, 0), -1, "Use the arrow keys to adjust it")

# start up the sample
play_sample(the_sample, 255, pan, pitch, true)

loop do
  poll_keyboard

  # alter the pan position?
  if key[KEY_LEFT] && pan > 0
    pan -= 1
  elsif key[KEY_RIGHT] && pan < 255
    pan += 1
  end

  # alter the pitch?
  if key[KEY_UP] && pitch < 16384
    pitch = ((pitch * 513) / 512) + 1
  elsif key[KEY_DOWN] && pitch > 64
    pitch = ((pitch * 511) / 512) - 1
  end

  # adjust the sample
  adjust_sample(the_sample, 255, pan, pitch, true)

  # delay a bit
  rest(2)

  break unless !key[KEY_ESC] && !key[KEY_SPACE]
end

# destroy the sample
destroy_sample(the_sample)