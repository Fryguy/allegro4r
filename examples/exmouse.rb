#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to get mouse input. The
# first part of the test retrieves the raw mouse input data
# and displays it on the screen without using any mouse
# cursor. When you press a key the standard arrow-like mouse
# cursor appears.  You are not restricted to this shape,
# and a second key press modifies the cursor to be several
# concentric colored circles. They are not joined together,
# so you can still see bits of what's behind when you move the
# cursor over the printed text message.
#

require 'allegro4r'
include Allegro4r::API

def print_all_buttons
  fc = makecol(0, 0, 0)
  bc = makecol(255, 255, 255)
  textprintf_right_ex(screen, font, 320, 50, fc, bc, "buttons")
  (0...8).each do |i|
    x = 320
    y = 60 + i * 10
    if (mouse_b & (1 << i)) != 0
      textprintf_right_ex(screen, font, x, y, fc, bc, "%2d" % (1 + i))
    else
      textprintf_right_ex(screen, font, x, y, fc, bc, "  ")
    end
  end
end

mickeyx = 0
mickeyy = 0
c = 0

begin
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

  # Detect mouse presence
  if install_mouse < 0
    textout_centre_ex(screen, font, "No mouse detected, but you need one!", SCREEN_W()/2, SCREEN_H()/2, makecol(0, 0, 0), makecol(255, 255, 255))
    readkey
    exit 0
  end

  textprintf_centre_ex(screen, font, SCREEN_W()/2, 8, makecol(0, 0, 0), makecol(255, 255, 255), "Driver: %s" % mouse_driver.name)

  loop do
    # On most platforms (eg. DOS) things will still work correctly
    # without this call, but it is a good idea to include it in any
    # programs that you want to be portable, because on some platforms
    # you may not be able to get any mouse input without it.
    poll_mouse

    acquire_screen

    # the mouse position is stored in the variables mouse_x and mouse_y
    textprintf_ex(screen, font, 16, 48, makecol(0, 0, 0), makecol(255, 255, 255), "mouse_x = %-5d" % mouse_x)
    textprintf_ex(screen, font, 16, 64, makecol(0, 0, 0), makecol(255, 255, 255), "mouse_y = %-5d" % mouse_y)

    # or you can use this function to measure the speed of movement.
    # Note that we only call it every fourth time round the loop:
    # there's no need for that other than to slow the numbers down
    # a bit so that you will have time to read them...
    c += 1
    mickeyx, mickeyy = get_mouse_mickeys if (c & 3) == 0

    textprintf_ex(screen, font, 16,  88, makecol(0, 0, 0), makecol(255, 255, 255), "mickey_x = %-7d" % mickeyx)
    textprintf_ex(screen, font, 16, 104, makecol(0, 0, 0), makecol(255, 255, 255), "mickey_y = %-7d" % mickeyy)

    # the mouse button state is stored in the variable mouse_b
    if (mouse_b & 1) != 0
      textout_ex(screen, font, "left button is pressed ", 16, 128, makecol(0, 0, 0), makecol(255, 255, 255))
    else
      textout_ex(screen, font, "left button not pressed", 16, 128, makecol(0, 0, 0), makecol(255, 255, 255))
    end

    if (mouse_b & 2) != 0
      textout_ex(screen, font, "right button is pressed ", 16, 144, makecol(0, 0, 0), makecol(255, 255, 255))
    else
      textout_ex(screen, font, "right button not pressed", 16, 144, makecol(0, 0, 0), makecol(255, 255, 255))
    end

    if (mouse_b & 4) != 0
      textout_ex(screen, font, "middle button is pressed ", 16, 160, makecol(0, 0, 0), makecol(255, 255, 255))
    else
      textout_ex(screen, font, "middle button not pressed", 16, 160, makecol(0, 0, 0), makecol(255, 255, 255))
    end

    # the wheel position is stored in the variable mouse_z
    textprintf_ex(screen, font, 16, 184, makecol(0, 0, 0), makecol(255, 255, 255), "mouse_z = %-5d mouse_w = %-5d" % [mouse_z, mouse_w])

    print_all_buttons
    
    release_screen
    
    vsync
    
    break if keypressed
  end

  clear_keybuf
  
  # To display a mouse pointer, call show_mouse(). There are several
  # things you should be aware of before you do this, though. For one,
  # it won't work unless you call install_timer() first. For another,
  # you must never draw anything onto the screen while the mouse
  # pointer is visible. So before you draw anything, be sure to turn
  # the mouse off with show_mouse(NULL), and turn it back on again when
  # you are done.
  clear_to_color(screen, makecol(255, 255, 255))
  textout_centre_ex(screen, font, "Press a key to change cursor", SCREEN_W()/2, SCREEN_H()/2, makecol(0, 0, 0), makecol(255, 255, 255))
  show_mouse(screen)
  readkey
  show_mouse(nil)

  # create a custom mouse cursor bitmap...
  custom_cursor = create_bitmap(32, 32)
  clear_to_color(custom_cursor, bitmap_mask_color(screen))
  (0...8).each do |c|
    circle(custom_cursor, 16, 16, c * 2, palette_color[c])
  end

  # select the custom cursor and set the focus point to the middle of it
  set_mouse_sprite(custom_cursor)
  set_mouse_sprite_focus(16, 16)

  clear_to_color(screen, makecol(255, 255, 255))
  textout_centre_ex(screen, font, "Press a key to quit", SCREEN_W()/2, SCREEN_H()/2, makecol(0, 0, 0), makecol(255, 255, 255))
  show_mouse(screen)
  readkey
  show_mouse(nil)

  destroy_bitmap(custom_cursor)
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
