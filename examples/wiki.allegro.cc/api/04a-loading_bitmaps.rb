# https://wiki.allegro.cc/index.php?title=Basic_tutorial_on_loading_and_showing_images
require 'allegro4r'
include Allegro4r::API
include Allegro4r::API::Image
include Allegro4r::API::NativeDialog

def main
  unless al_init
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize allegro!",
      nil, ALLEGRO_MESSAGEBOX_ERROR)
    return
  end

  unless al_init_image_addon
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize al_init_image_addon!",
      nil, ALLEGRO_MESSAGEBOX_ERROR)
    return
  end

  display = al_create_display(800, 600)

  if display.null?
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize display!",
      nil, ALLEGRO_MESSAGEBOX_ERROR)
    return
  end

  image = al_load_bitmap(File.join(__dir__, "../../data/mysha256x256.png"))

  if image.null?
    al_show_native_message_box(display, "Error", "Error", "Failed to load image!",
      nil, ALLEGRO_MESSAGEBOX_ERROR)
    al_destroy_display(display)
    return
  end

  al_draw_bitmap(image, 200, 200, 0)

  al_flip_display
  al_rest(2)

  al_destroy_display(display)
  al_destroy_bitmap(image)
end

run_main(method(:main))
