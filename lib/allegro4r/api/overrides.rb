module Allegro4r
  module API
    module Overrides
      def al_init
        al_install_system(al_get_allegro_version, nil)
      end

      def al_get_clipping_rectangle(*args)
        return super unless args.length == 0

        args = 4.times.map { FFI::MemoryPointer.new(:int) }
        super(*args)
        args.map(&:read_int32)
      end

      def al_unmap_rgba_f(*args)
        return super unless args.length == 1

        args += 4.times.map { FFI::MemoryPointer.new(:float) }
        super(*args)
        args.drop(1).map(&:read_float)
      end

      def al_path_cstr(path, delim)
        delim = delim.ord if delim.kind_of?(String)
        super
      end

      def al_grab_font_from_bitmap(bmp, n, ranges)
        if ranges.kind_of?(Array)
          ranges = FFI::MemoryPointer.new(:int, ranges.length).write_array_of_int(ranges)
        end
        super
      end
    end
  end
end
