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
    end
  end
end
