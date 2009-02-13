#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program moves a circle across the screen, first with a
# double buffer and then using page flips.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

begin
  exit 1 if allegro_init != 0
  install_timer
  install_keyboard

  # Some platforms do page flipping by making one large screen that you
  # can then scroll, while others give you several smaller, unique
  # surfaces. If you use the create_video_bitmap() function, the same
  # code can work on either kind of platform, but you have to be careful
  # how you set the video mode in the first place. We want two pages of
  # 320x200 video memory, but if we just ask for that, on DOS Allegro
  # might use a VGA driver that won't later be able to give us a second
  # page of vram. But if we ask for the full 320x400 virtual screen that
  # we want, the call will fail when using DirectX drivers that can't do
  # this. So we try two different mode sets, first asking for the 320x400
  # size, and if that doesn't work, for 320x200.
  if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 400) != 0
    if set_gfx_mode(GFX_AUTODETECT, 320, 200, 0, 0) != 0
      if set_gfx_mode(GFX_SAFE, 320, 200, 0, 0) != 0
        set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
        allegro_message("Unable to set any graphic mode\n%s\n" % allegro_error)
        exit 1
      end
    end
  end

  set_palette(desktop_palette)

  # allocate the memory buffer
  buffer = create_bitmap(SCREEN_W(), SCREEN_H())

  # first with a double buffer...
  clear_keybuf
  c = retrace_count + 32
  while retrace_count - c <= SCREEN_W() + 32
    clear_to_color(buffer, makecol(255, 255, 255))
    circlefill(buffer, retrace_count - c, SCREEN_H()/2, 32, makecol(0, 0, 0))
    textprintf_ex(buffer, font, 0, 0, makecol(0, 0, 0), -1, "Double buffered (%s)" % gfx_driver.name)
    blit(buffer, screen, 0, 0, 0, 0, SCREEN_W(), SCREEN_H())

    break if keypressed
  end

  destroy_bitmap(buffer)

  # now create two video memory bitmaps for the page flipping
  page1 = create_video_bitmap(SCREEN_W(), SCREEN_H())
  page2 = create_video_bitmap(SCREEN_W(), SCREEN_H())

  if page1.nil? || page2.nil?
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Unable to create two video memory pages\n")
    exit 1
  end

  active_page = page2

  # do the animation using page flips...
  clear_keybuf
  (-32..SCREEN_W() + 32).each do |c|
    clear_to_color(active_page, makecol(255, 255, 255))
    circlefill(active_page, c, SCREEN_H()/2, 32, makecol(0, 0, 0))
    textprintf_ex(active_page, font, 0, 0, makecol(0, 0, 0), -1, "Page flipping (%s)" % gfx_driver.name)
    show_video_bitmap(active_page)

    if (active_page == page1)
      active_page = page2
    else
      active_page = page1
    end

    break if keypressed
  end

  destroy_bitmap(page1)
  destroy_bitmap(page2)
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
