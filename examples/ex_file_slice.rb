# Ruby port of ex_expose.c from the Allegro examples.

#
# ex_file_slice - Use slices to pack many objects into a single file.
#
# This example packs two strings into a single file, and then uses a
# file slice to open them one at a time. While this usage is contrived,
# the same principle can be used to pack multiple images (for example)
# into a single file, and later read them back via Allegro's image loader.
#

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

BUFFER_SIZE = 1024

def pack_object(file, object, len)
  # First write the length of the object, so we know how big to make
  # the slice when it is opened later.
  al_fwrite32le(file, len)
  al_fwrite(file, object, len)
end

def get_next_chunk(file)
  # Reads the length of the next chunk, and if not at end of file, returns a
  # slice that represents that portion of the file.
  length = al_fread32le(file)
  !al_feof(file) ? al_fopen_slice(file, length, "rw") : nil
end

def main
  tmp_path = FFI::MemoryPointer.new(:pointer)
  first_string = "Hello, World!"
  second_string = "The quick brown fox jumps over the lazy dog."
  buffer = FFI::MemoryPointer.new(:char, BUFFER_SIZE)

  abort_example("Could not init Allegro.\n") unless al_init

  open_log

  master = al_make_temp_file("ex_file_slice_XXXX", tmp_path)
  tmp_path = tmp_path.get_pointer(0)
  abort_example("Unable to create temporary file\n") if master.null?

  # Pack both strings into the master file.
  pack_object(master, first_string, first_string.length)
  pack_object(master, second_string, second_string.length)

  # Seek back to the beginning of the file, as if we had just opened it
  al_fseek(master, 0, :allegro_seek_set)

  # Loop through the main file, opening a slice for each object
  while (slice = get_next_chunk(master))
    # Note: While the slice is open, we must avoid using the master file!
    # If you were dealing with packed images, this is where you would pass 'slice'
    # to al_load_bitmap_f.

    if al_fsize(slice) < BUFFER_SIZE
      # We could have used al_fgets, but just to show that the file slice
      # is constrained to the string object, we'll read the entire slice.
      al_fread(slice, buffer, al_fsize(slice))
      buffer.put_char(al_fsize(slice), 0)
      log_printf("Chunk of size %d: '%s'\n", al_fsize(slice).to_i, buffer.read_string)
    end

    # The slice must be closed before the next slice is opened. Closing
    # the slice will advanced the master file to the end of the slice.
    al_fclose(slice)
  end

  al_fclose(master)

  al_remove_filename(al_path_cstr(tmp_path, '/'))

  close_log(true)
end

run_main(method(:main))
