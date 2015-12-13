#!/usr/bin/env ruby

require 'fileutils'
require 'ffi_gen'
require 'active_support/core_ext/string'

module Allegro4r
  class Generator
    DEST_DIR = File.expand_path("../lib/allegro4r", __dir__)

    def self.generate(library_name, namespace, headers)
      puts "=== Generating #{namespace} ==="

      module_name = "Allegro4r::#{namespace}"
      output = File.join(DEST_DIR, "#{namespace.underscore}.rb")

      FileUtils.mkdir_p(File.dirname(output))

      FFIGen.generate(
        module_name:   module_name,
        ffi_lib_flags: [:now],
        ffi_lib:       library_name,
        cflags:        `llvm-config --cflags`.split(" "),
        headers:       headers.map { |h| "allegro5/#{h}.h" },
        output:        output,
      )

      puts "Cleaning up #{output}"
      contents = File.read(output)

      # Remove trailing whitespace
      contents = contents.lines.map(&:rstrip).join("\n")

      # Adjust module nesting to appease Ruby const lookup
      nested_modules = module_name.split("::")
      nested_module_names = nested_modules.map { |m| "module #{m}" }.join("; ")
      nested_module_ends = (["end"] * nested_modules.length).join("; ")
      contents.sub!("module #{module_name}", nested_module_names)
      contents.sub!(/end\z/, nested_module_ends)

      yield(contents) if block_given?

      # Write out the modified contents
      puts "Writing #{output}"
      File.write(output, contents)

      puts
    end
  end
end

Allegro4r::Generator.generate("allegro", "API", %w(
  allegro base altime bitmap bitmap_draw bitmap_io bitmap_lock blender color
  config debug display drawing error events file fixed fmaths fshook
  fullscreen_mode joystick keyboard memory monitor mouse mouse_cursor path
  system threads timer tls transformations utf8 keycodes
)) do |contents|
  # Fix contents based on syntax and calling errors with ffi_gen
  contents.gsub!("[:char, 1]", ":pointer")
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
  contents.gsub!(/(attach_function :al_get_display_format.+), :int$/, '\1, :allegro_pixel_format')

  # Directly adjust specific calls that otherwise can't be fixed in api_ext.rb
  contents.gsub!(/(attach_function :al_run_main.+)$/, '\1, :blocking => true')
end

Allegro4r::Generator.generate("allegro_font", "API::Font", %w(
  allegro color allegro_font
)) do |contents|
  # Remove duplicate definitions for color
  contents.sub!(/(^\s+#.+?\n)+\s+class ALLEGROCOLOR.+attach_function :al_get_pixel_format_bits.+?\n/m, "")
end

Allegro4r::Generator.generate("allegro_image", "API::Image", %w(
  allegro allegro_image
))

Allegro4r::Generator.generate("allegro_dialog", "API::NativeDialog", %w(
  allegro allegro_native_dialog
))

Allegro4r::Generator.generate("allegro_primitives", "API::Primitives", %w(
  allegro color allegro_primitives
)) do |contents|
  # Remove duplicate definitions for color
  contents.sub!(/(^\s+#.+?\n)+\s+class ALLEGROCOLOR.+attach_function :al_get_pixel_format_bits.+?\n/m, "")

  # Fix contents based on syntax and calling errors with ffi_gen
  contents.gsub!("[:float, 8]", ":pointer")
end
