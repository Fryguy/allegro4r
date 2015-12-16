#!/usr/bin/env ruby

require 'ffi_gen'

output = File.expand_path("../lib/allegro4r/api.rb", __dir__)

FFIGen.generate(
  module_name:   "Allegro4r::API",
  output:        output,
  cflags:        `llvm-config --cflags`.split(" "),
  ffi_lib_flags: [:now],
  ffi_lib: %w(
    allegro
    allegro_font
    allegro_image
    allegro_dialog
    allegro_primitives
  ),
  headers: %w(
    allegro5/allegro.h
    allegro5/base.h
    allegro5/altime.h
    allegro5/bitmap.h
    allegro5/bitmap_draw.h
    allegro5/bitmap_io.h
    allegro5/bitmap_lock.h
    allegro5/blender.h
    allegro5/color.h
    allegro5/config.h
    allegro5/debug.h
    allegro5/display.h
    allegro5/drawing.h
    allegro5/error.h
    allegro5/events.h
    allegro5/file.h
    allegro5/fixed.h
    allegro5/fmaths.h
    allegro5/fshook.h
    allegro5/fullscreen_mode.h
    allegro5/joystick.h
    allegro5/keyboard.h
    allegro5/memory.h
    allegro5/monitor.h
    allegro5/mouse.h
    allegro5/mouse_cursor.h
    allegro5/path.h
    allegro5/system.h
    allegro5/threads.h
    allegro5/timer.h
    allegro5/tls.h
    allegro5/transformations.h
    allegro5/utf8.h
    allegro5/keycodes.h

    allegro5/allegro_font.h
    allegro5/allegro_image.h
    allegro5/allegro_dialog.h
    allegro5/allegro_primitives.h
  )
)

puts "Cleaning up #{output}"
contents = File.read(output)

# Remove trailing whitespace
contents = contents.lines.map(&:rstrip).join("\n")

# Fix issue where ffi_lib is given an Array instead of multiple params
contents.sub!(/ffi_lib \[(.+?)\]/, 'ffi_lib \1')

# Fix contents based on syntax and calling errors with ffi_gen
contents.gsub!("[:char, 1]", ":pointer")
contents.gsub!("[:float, 8]", ":pointer")
contents.gsub!(":pointer.by_value", ":pointer")

# Fix issues with Unions with nested structures...they need to be by_ref
contents.sub!(/class ALLEGROANYEVENT.+?:source, ALLEGROEVENTSOURCE/m,   '\0.by_ref')
contents.sub!(/class ALLEGROJOYSTICKEVENT.+?:source, ALLEGROJOYSTICK/m, '\0.by_ref')
contents.sub!(/class ALLEGROJOYSTICKEVENT.+?:id, ALLEGROJOYSTICK/m,     '\0.by_ref')
contents.sub!(/class ALLEGROKEYBOARDEVENT.+?:source, ALLEGROKEYBOARD/m, '\0.by_ref')
contents.sub!(/class ALLEGROMOUSEEVENT.+?:source, ALLEGROMOUSE/m,       '\0.by_ref')
contents.sub!(/class ALLEGROTIMEREVENT.+?:source, ALLEGROTIMER/m,       '\0.by_ref')
contents.sub!(/class ALLEGROUSEREVENT.+?:source, ALLEGROEVENTSOURCE/m,  '\0.by_ref')
contents.sub!(/class ALLEGROUSEREVENT.+?:source, ALLEGROUSEREVENTDESCRIPTOR/m, '\0.by_ref')

# Fix issues with return pointers not marked as such
contents.sub!(/(attach_function :al_lock_bitmap.+ALLEGROLOCKEDREGION)$/, '\1.by_ref')
contents.sub!(/(attach_function :al_lock_bitmap_region.+ALLEGROLOCKEDREGION)$/, '\1.by_ref')

# Fix issues with return enums not marked as such
contents.sub!(/(attach_function :al_get_display_format.+), :int$/, '\1, :allegro_pixel_format')

# Directly adjust specific calls that otherwise can't be fixed in api_ext.rb
contents.sub!(/(attach_function :al_run_main.+)$/, '\1, :blocking => true')

# Write out the modified contents
puts "Writing #{output}"
File.write(output, contents)

puts
