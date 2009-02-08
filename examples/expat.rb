#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates the use of patterned drawing and sub-bitmaps.
#

require 'allegro4r'
include Allegro4r::API

def draw_pattern(bitmap, message, color)
  acquire_bitmap(bitmap)

  # create a pattern bitmap
  pattern = create_bitmap(text_length(font, message), text_height(font))
  clear_to_color(pattern, bitmap_mask_color(pattern))
  textout_ex(pattern, font, message, 0, 0, palette_color[255], bitmap_mask_color(screen))

  # cover the bitmap with the pattern
  drawing_mode(DRAW_MODE_MASKED_PATTERN, pattern, 0, 0)
  rectfill(bitmap, 0, 0, bitmap.w, bitmap.h, palette_color[color])
  solid_mode

  # destroy the pattern bitmap
  destroy_bitmap(pattern)

  release_bitmap(bitmap)
end

begin
  exit 1 if allegro_init != 0
  install_keyboard

  if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
    if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
      allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
      exit 1
    end
  end

  set_palette(desktop_palette)
  clear_to_color(screen, makecol(255, 255, 255))

  # first cover the whole screen with a pattern
  draw_pattern(screen, "<screen>", 255)

  # draw the pattern onto a memory bitmap and then blit it to the screen
  bitmap = create_bitmap(128, 32)
  clear_to_color(bitmap, makecol(255, 255, 255))
  draw_pattern(bitmap, "<memory>", 1)
  masked_blit(bitmap, screen, 0, 0, 32, 32, 128, 32)
  destroy_bitmap(bitmap)

  # or we could use a sub-bitmap. These share video memory with their
  # parent, so the drawing will be visible without us having to blit it
  # across onto the screen.
  bitmap = create_sub_bitmap(screen, 224, 64, 64, 128)
  rectfill(screen, 224, 64, 286, 192, makecol(255, 255, 255))
  draw_pattern(bitmap, "<subbmp>", 4)
  destroy_bitmap(bitmap)

  readkey
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
