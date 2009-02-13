#
# Example program (C Version) for the Allegro library, by Shawn Hargreaves.
#   (Ruby port by Jason Frey)
#
# This program demonstrates how to write directly to video memory.
# It implements a simple fire effect, first by calling getpixel() and
# putpixel(), then by accessing video memory directly a byte at a
# time, and finally using block memory copy operations.
#

require 'rubygems'
require 'allegro4r'
include Allegro4r::API

# The fire is formed from several 'hotspots' which are moved randomly
# across the bottom of the screen.
FIRE_HOTSPOTS = 48
$hotspot = Array.new(FIRE_HOTSPOTS, 0)

# This function updates the bottom line of the screen with a pattern
# of varying intensities which are then moved upwards and faded out
# by the code in main.
def draw_bottom_line_of_fire
  # zero the buffer
  (0...SCREEN_W()).each do |c|
    $temp[c] = 0
  end

  (0...FIRE_HOTSPOTS).each do |c|
    ($hotspot[c] - 20...$hotspot[c] + 20).each do |c2|
      if c2 >= 0 && c2 < SCREEN_W()
        $temp[c2] = MIN($temp[c2] + 20 - ABS($hotspot[c] - c2), 192)
      end
    end

    # move the hotspots
    $hotspot[c] += (AL_RAND() & 7) - 3
    if $hotspot[c] < 0
      $hotspot[c] += SCREEN_W()
    elsif $hotspot[c] >= SCREEN_W()
      $hotspot[c] -= SCREEN_W()
    end
  end

  # display the buffer
  (0...SCREEN_W()).each do |c|
    putpixel(screen, c, SCREEN_H() - 1, $temp[c])
  end
end

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

  begin
    $temp = "\0" * SCREEN_W()
  rescue NoMemoryError
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0)
    allegro_message("Not enough memory? This is a joke right!?!\n")
    exit 0
  end

  (0...FIRE_HOTSPOTS).each do |c|
    $hotspot[c] = AL_RAND() % SCREEN_W()
  end

  # fill our palette with a gradually altering sequence of colors
  (0...64).each do |c|
    palette[c].r = c;
    palette[c].g = 0;
    palette[c].b = 0;
  end
  (64...128).each do |c|
    palette[c].r = 63;
    palette[c].g = c - 64;
    palette[c].b = 0;
  end
  (128...192).each do |c|
    palette[c].r = 63;
    palette[c].g = 63;
    palette[c].b = c - 128;
  end
  (192...256).each do |c|
    palette[c].r = 63;
    palette[c].g = 63;
    palette[c].b = 63;
  end

  set_palette(palette)

  textout_ex(screen, font, "Using get/putpixel", 0, 0, makecol(255,255,255), makecol(0, 0, 0))

  # using getpixel and putpixel is slow :-)
  while !keypressed
    acquire_screen

    draw_bottom_line_of_fire

    (64...SCREEN_H() - 1).each do |y|
      # read line
      (0...SCREEN_W()).each do |x|
        c = getpixel(screen, x, y + 1)

        c -= 1 if c > 0

        putpixel(screen, x, y, c)
      end
    end
    release_screen
  end

  clear_keybuf
  textout_ex(screen, font, "Using direct memory writes", 0, 0, makecol(255,255,255), makecol(0, 0, 0))

  # It is much faster if we access the screen memory directly. This
  # time we read an entire line of the screen into our own buffer,
  # modify it there, and then write the whole line back in one go.
  # That is to avoid having to keep switching back and forth between
  # different scanlines: if we only copied one pixel at a time, we
  # would have to call bmp_write_line for every single pixel rather
  # than just twice per line.
  while !keypressed
    acquire_screen
    draw_bottom_line_of_fire

    bmp_select(screen)

    (64...SCREEN_H() - 1).each do |y|
      # get an address for reading line y+1
      address = bmp_read_line(screen, y + 1)

      # read line with farptr functions
      (0...SCREEN_W()).each do |x|
        $temp[x] = bmp_read8(address + x)
      end

      # adjust it
      (0...SCREEN_W()).each do |x|
        $temp[x] -= 1 if $temp[x] > 0
      end

      # get an address for writing line y
      address = bmp_write_line(screen, y)

      # write line with farptr functions
      (0...SCREEN_W()).each do |x|
        bmp_write8(address + x, $temp[x,1])
      end
    end

    bmp_unwrite_line(screen)
    release_screen
  end

  clear_keybuf
  textout_ex(screen, font, "Using block data transfers", 0, 0, makecol(255,255,255), makecol(0, 0, 0))

  # It is even faster if we transfer the data in 32 bit chunks, rather
  # than only one pixel at a time. This method may not work on really
  # unusual machine architectures, but should be ok on just about
  # anything that you are practically likely to come across.
  while !keypressed
    acquire_screen
    draw_bottom_line_of_fire

    bmp_select(screen)

    (64...SCREEN_H() - 1).each do |y|
      # get an address for reading line y+1
      address = bmp_read_line(screen, y + 1)

      # read line in 32 bit chunks
      (0...SCREEN_W()).step(4) do |x|    # JF - sizeof(uint32_t)
        $temp[x...x + 4] = bmp_read32(address + x)
      end

      # adjust it
      (0...SCREEN_W()).each do |x|
        $temp[x] -= 1 if $temp[x] > 0
      end

      # get an address for writing line y
      address = bmp_write_line(screen, y)

      # write line in 32 bit chunks
      (0...SCREEN_W()).step(4) do |x|    # JF - sizeof(uint32_t)
        bmp_write32(address + x, $temp[x...x + 4])
      end
    end

    bmp_unwrite_line(screen)
    release_screen
  end
ensure
  # JF - you must ensure allegro_exit is called to prevent Ruby from crashing
  allegro_exit
end
