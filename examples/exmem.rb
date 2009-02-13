#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates the use of memory bitmaps. It creates
# a small temporary bitmap in memory, draws some circles onto it,
# and then blits lots of copies of it onto the screen.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

begin
  exit 1 if allegro_init != 0
  install_keyboard

  if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
    if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
      set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
      allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
      exit 1
    end
  end

  set_palette(desktop_palette)

  # make a memory bitmap sized 20x20
  memory_bitmap = create_bitmap(20, 20)

  # draw some circles onto it
  clear_bitmap(memory_bitmap)
  (0..15).each do |x|
    circle(memory_bitmap, 10, 10, x, palette_color[x])
  end

  # blit lots of copies of it onto the screen
  acquire_screen

  (0...SCREEN_H()).step(20) do |y|
    (0...SCREEN_W()).step(20) do |x|
      blit(memory_bitmap, screen, 0, 0, x, y, 20, 20)
    end
  end

  release_screen

  # free the memory bitmap
  destroy_bitmap(memory_bitmap)

  readkey
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
