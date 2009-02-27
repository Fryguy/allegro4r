#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to use the timer routines.
# These can be a bit of a pain, because you have to be sure
# you lock all the memory that is used inside your interrupt
# handlers.  The first part of the example shows a basic use of
# timing using the blocking function rest(). The second part
# shows how to use three timers with different frequencies in
# a non blocking way.
#
# JF - Counters based on timer interrupts cannot be done directly though Ruby,
# so instead, we can use predefined timer counters. They can be installed by
# name with install_int or install_int_ex. The values can be retrieved through
# timer_counter_get.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

exit 1 if allegro_init != 0
install_keyboard
install_timer

if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
  if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
    exit 1
  end
end

set_palette(desktop_palette)
clear_to_color(screen, makecol(255, 255, 255))

textprintf_centre_ex(screen, font, SCREEN_W()/2, 8, makecol(0, 0, 0), makecol(255, 255, 255), "Driver: %s" % timer_driver.name)

# use rest to delay for a specified number of milliseconds
textprintf_centre_ex(screen, font, SCREEN_W()/2, 48, makecol(0, 0, 0), makecol(255, 255, 255), "Timing five seconds:")

(1..5).each do |c|
  textprintf_centre_ex(screen, font, SCREEN_W()/2, 62 + c * 10, makecol(0, 0, 0), makecol(255, 255, 255), "%d" % c)
  rest(1000)
end

textprintf_centre_ex(screen, font, SCREEN_W()/2, 142, makecol(0, 0, 0), makecol(255, 255, 255), "Press a key to set up interrupts")
readkey

# JF - Since we are using predefined timer routines, LOCK_VARIABLE and
# LOCK_FUNCTION do nothing, and are here simply for API consistency. They will
# raise warnings if the Ruby script is run with -w.

# all variables and code used inside interrupt handlers must be locked
LOCK_VARIABLE(:x)
LOCK_VARIABLE(:y)
LOCK_VARIABLE(:z)
LOCK_FUNCTION(:inc_x)
LOCK_FUNCTION(:inc_y)
LOCK_FUNCTION(:inc_z)

# JF - install_int and install_int_ex take a name as their first parameter
# which can then be used to subsequent calls to timer_counter_get.

# the speed can be specified in milliseconds (this is once a second)
install_int(:inc_x, 1000)

# or in beats per second (this is 10 ticks a second)
install_int_ex(:inc_y, BPS_TO_TIMER(10))

# or in seconds (this is 10 seconds a tick)
install_int_ex(:inc_z, SECS_TO_TIMER(10))

# the interrupts are now active...
while !keypressed
  # JF - Get the values from the timer interrupt counters with
  # timer_counter_get
  x = timer_counter_get(:inc_x)
  y = timer_counter_get(:inc_y)
  z = timer_counter_get(:inc_z)

  textprintf_centre_ex(screen, font, SCREEN_W()/2, 176, makecol(0, 0, 0), makecol(255, 255, 255), "x=%d, y=%d, z=%d" % [x, y, z])
end
