# Ruby port of ex_convert.c from the Allegro examples.

# Image conversion example

require 'allegro4r'
include Allegro4r::API

require_relative "common"


def main(argc, argv)
  abort_example("Could not init Allegro.\n") unless al_init

  open_log

  catch :done do
    if argc < 3
      log_printf("This example needs to be run from the command line.\n")
      log_printf("Usage: %s <infile> <outfile>\n", argv[0])
      log_printf("\tPossible file types: BMP PCX PNG TGA\n")
      throw :done
    end

    al_init_image_addon

    al_set_new_bitmap_format(:pixel_format_argb_8888)
    al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP |
      ALLEGRO_NO_PREMULTIPLIED_ALPHA)

    bitmap = al_load_bitmap(argv[1])
    if bitmap.null?
      log_printf("Error loading input file\n")
      throw :done
    end

    t0 = al_get_time
    unless al_save_bitmap(argv[2], bitmap)
      log_printf("Error saving bitmap\n")
      throw :done
    end
    t1 = al_get_time
    log_printf("Saving took %.4f seconds\n", t1 - t0)

    al_destroy_bitmap(bitmap)
  end

  close_log(true)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
