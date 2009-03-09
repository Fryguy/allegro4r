#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to play MIDI files.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

paused = false
done = false

exit 1 if allegro_init != 0

if ARGV.length != 1
  allegro_message("Usage: 'ruby exmidi.rb filename.mid'\n")
  exit 1
end

install_keyboard
install_timer

# install a MIDI sound driver
if install_sound(DIGI_AUTODETECT, MIDI_AUTODETECT, nil) != 0
  allegro_message("Error initialising sound system\n%s\n" % allegro_error)
  exit 1
end

# read in the MIDI file
the_music = load_midi(ARGV[0])
if the_music.nil?
  allegro_message("Error reading MIDI file '%s'\n" % ARGV[0])
  exit 1
end
length = get_midi_length(the_music)
beats = -midi_pos # get_midi_length updates midi_pos to the negative
                  # number of beats (quarter notes) in the midi.

if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
  if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
    exit 1
  end
end

# try to continue in the background
if set_display_switch_mode(SWITCH_BACKGROUND)
  set_display_switch_mode(SWITCH_BACKAMNESIA)
end

set_palette(desktop_palette)
background_color = makecol(255, 255, 255)
text_color = makecol(0, 0, 0)
clear_to_color(screen, background_color)
th = text_height(font)
x = SCREEN_W() / 2

textprintf_centre_ex(screen, font, x, SCREEN_H() / 3, text_color, -1, "Driver: %s" % midi_driver.name)
textprintf_centre_ex(screen, font, x, SCREEN_H() / 2, text_color, -1, "Playing %s" % get_filename(ARGV[0]))

# start up the MIDI file
play_midi(the_music, true)

y = 2 * SCREEN_H() / 3
tw = text_length(font, "0000:00 / 0000:00")
# wait for a key press
while !done
  # P key pauses/resumes, any other key exits.
  while keypressed
    k = readkey & 255
    if k == ?p
      paused = !paused
      if paused
        midi_pause
        textprintf_centre_ex(screen, font, x, y + th * 3, text_color, -1, "P A U S E D")
      else
        midi_resume
        rectfill(screen, x - tw / 2, y + th * 3, x + tw / 2, y + th * 4, background_color)
      end
    else
      done = true
    end
  end
  pos = midi_time
  beat = midi_pos
  rectfill(screen, x - tw / 2, y, x + tw / 2, y + th * 2, background_color)
  textprintf_centre_ex(screen, font, x, y, text_color, -1, "%d:%02d / %d:%02d" % [pos / 60, pos % 60, length / 60, length % 60])
  textprintf_centre_ex(screen, font, x, y + th, text_color, -1, "beat %d / %d" % [beat, beats])
  # We have nothing else to do.
  rest(100)
end

# destroy the MIDI file
destroy_midi(the_music)