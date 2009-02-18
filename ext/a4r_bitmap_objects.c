#include "allegro4r.h"

/*
 * call-seq:
 *   screen -> a_bmp
 *
 * Global reference to a bitmap, sized VIRTUAL_W x VIRTUAL_H. This is created by
 * set_gfx_mode, and represents the hardware video memory. Only a part of this
 * bitmap will actually be visible, sized SCREEN_W x SCREEN_H. Normally this is
 * the top left corner of the larger virtual screen, so you can ignore the extra
 * invisible virtual size of the bitmap if you aren't interested in hardware
 * scrolling or page flipping. To move the visible window to other parts of the
 * screen bitmap, call scroll_screen. Initially the clipping rectangle will be
 * limited to the physical screen size, so if you want to draw onto a larger
 * virtual screen space outside this rectangle, you will need to adjust the
 * clipping.
 *
 * For example, to draw a pixel onto the screen you would write:
 *   putpixel(screen, x, y, color)
 *
 * Or to implement a double-buffered system:
 *   # Make a bitmap in RAM.
 *   bmp = create_bitmap(320, 200)
 *   # Clean the memory bitmap.
 *   clear_bitmap(bmp)
 *   # Draw onto the memory bitmap.
 *   putpixel(bmp, x, y, color)
 *   # Copy it to the screen.
 *   blit(bmp, screen, 0, 0, 0, 0, 320, 200)
 *
 * Warning: be very careful when using this reference at the same time as any
 * bitmaps created by the create_video_bitmap function (see the description of
 * this function for more detailed information). And never try to destroy it
 * with destroy_bitmap.
 */
VALUE a4r_screen(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  BITMAP *bmp = screen;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

/*
 * call-seq:
 *   SCREEN_W -> int
 *
 * Global defines that return the width and height of the screen, or zero if the
 * screen has not been initialised yet. Example:
 *   buf = "\0" * 100
 *   uszprintf(buf, buf.length, "The screen size is %d x %d pixels" %
 *     [SCREEN_W, SCREEN_H])
 */
VALUE a4r_SCREEN_W(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_W);
}

/*
 * call-seq:
 *   SCREEN_H -> int
 *
 * See SCREEN_W.
 */
VALUE a4r_SCREEN_H(VALUE self)
{
  // TODO: Convert to hooked or virtual variable?
  return INT2FIX(SCREEN_H);
}

/*
 * call-seq:
 *   create_bitmap(width, height) -> a_bmp or nil
 *
 * Creates a memory bitmap sized width by height. The bitmap will have clipping
 * turned on, and the clipping rectangle set to the full size of the bitmap. The
 * image memory will not be cleared, so it will probably contain garbage: you
 * should clear the bitmap before using it. This routine always uses the global
 * pixel format, as specified by calling set_color_depth. The minimum height of
 * the BITMAP must be 1 and width can't be negative. Example:
 *   # Create a 10 pixel tall bitmap, as wide as the screen.
 *   bmp = create_bitmap(SCREEN_W, 10)
 *   abort_on_error("Couldn't create bitmap!") if bmp.nil?
 *   # Use the bitmap.
 *   ...
 *   # Destroy it when we don't need it any more.
 *   destroy_bitmap(bmp)
 *
 * Return value: Returns a reference to the created bitmap, or nil if the bitmap
 * could not be created. Remember to free this bitmap later to avoid memory
 * leaks.
 */
VALUE a4r_create_bitmap(VALUE self, VALUE width, VALUE height)
{
  // TODO: Change to call destroy_bitmap on free?
  BITMAP *bmp = create_bitmap(FIX2INT(width), FIX2INT(height));
  if (bmp == NULL)
    return Qnil;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

/*
 * call-seq:
 *   create_sub_bitmap(parent, x, y, width, height) -> a_bmp or nil
 *
 * Creates a sub-bitmap, ie. a bitmap sharing drawing memory with a pre-existing
 * bitmap, but possibly with a different size and clipping settings. When
 * creating a sub-bitmap of the mode-X screen, the x position must be a multiple
 * of four. The sub-bitmap width and height can extend beyond the right and
 * bottom edges of the parent (they will be clipped), but the origin point must
 * lie within the parent region.
 *
 * Return value: Returns a reference to the created sub bitmap, or nil if the
 * sub bitmap could not be created. Remember to free the sub bitmap before
 * freeing the parent bitmap to avoid memory leaks and potential crashes
 * accessing memory which has been freed.
 */
VALUE a4r_create_sub_bitmap(VALUE self, VALUE parent, VALUE x, VALUE y, VALUE width, VALUE height)
{
  BITMAP *bmp;
  Data_Get_Struct(parent, BITMAP, bmp);
  BITMAP *ret = create_sub_bitmap(bmp, FIX2INT(x), FIX2INT(y), FIX2INT(width), FIX2INT(height));
  if (ret == NULL)
    return Qnil;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, ret);
  return obj;
}

/*
 * call-seq:
 *   create_video_bitmap(width, height) -> a_bmp or nil
 *
 * Allocates a video memory bitmap of the specified size. This can be used to
 * allocate offscreen video memory for storing source graphics ready for a
 * hardware accelerated blitting operation, or to create multiple video memory
 * pages which can then be displayed by calling show_video_bitmap. Read the
 * introduction of this chapter for a comparison with other types of bitmaps and
 * other specific details.
 *
 * Warning: video memory bitmaps are usually allocated from the same space as
 * the screen bitmap, so they may overlap with it; it is therefore not a good
 * idea to use the global screen at the same time as any surfaces returned by
 * this function.
 *
 * Return value: Returns a reference to the bitmap on success, or nil if you
 * have run out of video ram. Remember to destroy this bitmap before any
 * subsequent call to set_gfx_mode.
 */
VALUE a4r_create_video_bitmap(VALUE self, VALUE width, VALUE height)
{
  // TODO: Change to call destroy_bitmap on free?
  BITMAP *bmp = create_video_bitmap(FIX2INT(width), FIX2INT(height));
  if (bmp == NULL)
    return Qnil;
  VALUE obj = Data_Wrap_Struct(cBITMAP, 0, 0, bmp);
  return obj;
}

/*
 * call-seq:
 *   destroy_bitmap(bitmap) -> nil
 *
 * Destroys a memory bitmap, sub-bitmap, video memory bitmap, or system bitmap
 * when you are finished with it. If you pass a nil this function won't do
 * anything. See above for the restrictions as to when you are allowed to
 * destroy the various types of bitmaps.
 *
 * The bitmap must not have a mouse cursor shown on it at the time it is
 * destroyed.
 */
VALUE a4r_destroy_bitmap(VALUE self, VALUE bitmap)
{
  BITMAP *bmp;
  if (bitmap == Qnil)
    bmp = NULL;
  else
    Data_Get_Struct(bitmap, BITMAP, bmp);
  destroy_bitmap(bmp);
  return Qnil;
}

/*
 * call-seq:
 *   bitmap_mask_color(bmp) -> int
 *
 * Returns the mask color for the specified bitmap (the value which is skipped
 * when drawing sprites). For 256-color bitmaps this is zero, and for truecolor
 * bitmaps it is bright pink (maximum red and blue, zero green). A frequent use
 * of this function is to clear a bitmap with the mask color so you can later
 * use this bitmap with masked_blit or draw_sprite after drawing other stuff on
 * it. Example:
 *   # Replace mask color with another color.
 *   (0...bmp.h).each do |y|
 *     (0...bmp.w).each do |x|
 *       if (getpixel(bmp, x, y) == bitmap_mask_color(bmp))
 *         putpixel(bmp, x, y, another_color)
 *       end
 *     end
 *   end
 */
VALUE a4r_bitmap_mask_color(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  return INT2FIX(bitmap_mask_color(bitmap));
}

/*
 * call-seq:
 *   acquire_bitmap(bmp) -> nil
 *
 * Acquires the specified video bitmap prior to drawing onto it. You never need
 * to call the function explicitly as it is low level, and will only give you a
 * speed up if you know what you are doing. Using it wrongly may cause slowdown,
 * or even lock up your program.
 *
 * Note: You do never need to use acquire_bitmap on a memory bitmap, i.e. a
 * normal bitmap created with create_bitmap. It will simply do nothing in that
 * case.
 *
 * It still can be useful, because e.g. under the current DirectDraw driver of
 * Allegro, most drawing functions need to lock a video bitmap before drawing to
 * it. But doing this is very slow, so you will get much better performance if
 * you acquire the screen just once at the start of your main redraw function,
 * then call multiple drawing operations which need the bitmap locked, and only
 * release it when done.
 *
 * Multiple acquire calls may be nested, but you must make sure to match up the
 * acquire_bitmap and release_bitmap calls. Be warned that DirectX and X11
 * programs activate a mutex lock whenever a surface is locked, which prevents
 * them from getting any input messages, so you must be sure to release all your
 * bitmaps before using any timer, keyboard, or other non-graphics routines!
 *
 * Note that if you are using hardware accelerated VRAM->VRAM functions, you
 * should not call acquire_bitmap. Such functions need an unlocked target bitmap
 * under DirectX, so there is now just the opposite case from before - if the
 * bitmap is already locked with acquire_bitmap, the drawing operation has to
 * unlock it.
 *
 * Note: For backwards compatibility, the unlocking behavior of such functions
 * is permanent. That is, if you call acquire_bitmap first, then call e.g. an
 * accelerated blit, the DirectX bitmap will be unlocked internally (it won't
 * affect the nesting counter of acquire/release calls).
 *
 * There is no clear cross-platform way in this Allegro version to know which
 * drawing operations need a locked/unlocked state. For example a normal
 * rectfill most probably is accelerated under DirectX, and therefore needs the
 * screen unlocked, but an XOR rectfill, or one with blending activated, most
 * probably is not, and therefore locks the screen. And while the DirectX driver
 * will do automatic unlocking, there is no such thing under X11, where the
 * function is used to synchronize X11 calls from different threads. Your best
 * bet is to never use acquire_bitmap - changes are you are doing something in
 * the wrong way if you think you need it.
 *
 * Warning: This function can be very dangerous to use, since the whole program
 * may get locked while the bitmap is locked. So the lock should only be held
 * for a short time, and you should not call anything but drawing operations
 * onto the locked video bitmap while a lock is in place. Especially don't call
 * things like show_mouse (or scare_mouse which calls that) or readkey, since it
 * will most likely deadlock your entire program.
 */
VALUE a4r_acquire_bitmap(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  acquire_bitmap(bitmap);
  return Qnil;
}

/*
 * call-seq:
 *   release_bitmap(bmp) -> nil
 *
 * Releases a bitmap that was previously locked by calling acquire_bitmap. If
 * the bitmap was locked multiple times, you must release it the same number of
 * times before it will truly be unlocked.
 */
VALUE a4r_release_bitmap(VALUE self, VALUE bmp)
{
  BITMAP *bitmap;
  Data_Get_Struct(bmp, BITMAP, bitmap);
  release_bitmap(bitmap);
  return Qnil;
}

/*
 * call-seq:
 *   acquire_screen -> nil
 *
 * Shortcut version of acquire_bitmap(screen)
 */
VALUE a4r_acquire_screen(VALUE self)
{
  acquire_screen();
  return Qnil;
}

/*
 * call-seq:
 *   release_screen -> nil
 *
 * Shortcut version of release_bitmap(screen)
 */
VALUE a4r_release_screen(VALUE self)
{
  release_screen();
  return Qnil;
}
