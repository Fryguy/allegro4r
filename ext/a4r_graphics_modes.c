#include "allegro4r.h"

/*
 * call-seq:
 *   set_gfx_mode(card, w, h, v_w, v_h) -> int
 *
 * Switches into graphics mode. The card parameter should usually be one of the
 * Allegro magic drivers (read introduction of chapter "Graphics modes") or see
 * the platform specific documentation for a list of the available drivers. The
 * w and h parameters specify what screen resolution you want. The color depth
 * of the graphic mode has to be specified before calling this function with
 * set_color_depth.
 *
 * The v_w and v_h parameters specify the minimum virtual screen size, in case
 * you need a large virtual screen for hardware scrolling or page flipping. You
 * should set them to zero if you don't care about the virtual screen size.
 *
 * When you call set_gfx_mode, the v_w and v_h parameters represent the minimum
 * size of virtual screen that is acceptable for your program. The range of
 * possible sizes is usually very restricted, and Allegro may end up creating a
 * virtual screen much larger than the one you request. Allowed sizes are driver
 * dependent and some drivers do not allow virtual screens that are larger than
 * the visible screen at all: don't assume that whatever you pass will always
 * work.
 *
 * In mode-X the virtual width can be any multiple of eight greater than or
 * equal to the physical screen width, and the virtual height will be set
 * accordingly (the VGA has 256k of vram, so the virtual height will be
 * 256*1024/virtual_width).
 *
 * Currently, using a big virtual screen for page flipping is considered bad
 * practice. There are platforms which don't support virtual screens bigger than
 * the physical screen but can create different video pages to flip back and
 * forth. This means that, if you want page flipping and aren't going to use
 * hardware scrolling, you should call set_gfx_mode with (0,0) as the virtual
 * screen size and later create the different video pages with
 * create_video_bitmap. Otherwise your program will be limited to the platforms
 * supporting hardware scrolling.
 *
 * After you select a graphics mode, the physical and virtual screen sizes can
 * be checked with the macros SCREEN_W, SCREEN_H, VIRTUAL_W, and VIRTUAL_H.
 *
 * Return value: Returns zero on success. On failure returns a negative number
 * and stores a description of the problem in allegro_error.
 */
VALUE a4r_set_gfx_mode(VALUE self, VALUE card, VALUE w, VALUE h, VALUE v_w, VALUE v_h)
{
  return INT2FIX(set_gfx_mode(NUM2INT(card), FIX2INT(w), FIX2INT(h), FIX2INT(v_w), FIX2INT(v_h)));
}

/*
 * call-seq:
 *   show_video_bitmap(bitmap) -> int
 *
 * Attempts to page flip the hardware screen to display the specified video
 * bitmap object, which must be the same size as the physical screen, and should
 * have been obtained by calling the create_video_bitmap function.
 *
 * Allegro will handle any necessary vertical retrace synchronisation when page
 * flipping, so you don't need to call vsync before it. This means that
 * show_video_bitmap has the same time delay effects as vsync by default. This
 * can be adjusted with the "disable_vsync" config key in the [graphics] section
 * of allegro.cfg. Example:
 *   video_page = Array.new
 *   ...
 *   # Create pages for page flipping
 *   video_page[0] = create_video_bitmap(SCREEN_W, SCREEN_H)
 *   video_page[1] = create_video_bitmap(SCREEN_W, SCREEN_H)
 *   current_page = 0
 *   ...
 *   # draw the screen and flip pages
 *   draw_screen(video_page[current_page])
 *   show_video_bitmap(video_page[current_page])
 *   current_page = (current_page + 1) % 2
 *   ...
 *
 * Return value: Returns zero on success and non-zero on failure.
 */
VALUE a4r_show_video_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  Data_Get_Struct(bitmap, BITMAP, bmp);
  return INT2FIX(show_video_bitmap(bmp));
}

/*
 * call-seq:
 *   vsync -> nil
 *
 * Waits for a vertical retrace to begin. The retrace happens when the electron
 * beam in your monitor has reached the bottom of the screen and is moving back
 * to the top ready for another scan. During this short period the graphics card
 * isn't sending any data to the monitor, so you can do things to it that aren't
 * possible at other times, such as altering the palette without causing
 * flickering (snow). Allegro will automatically wait for a retrace before
 * altering the palette or doing any hardware scrolling, though, so you don't
 * normally need to bother with this function.
 */
VALUE a4r_vsync(VALUE self)
{
  vsync();
  return Qnil;
}
