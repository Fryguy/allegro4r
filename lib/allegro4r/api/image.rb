# Generated by ffi_gen. Please do not change this file by hand.

require 'ffi'

module Allegro4r; module API; module Image
  extend FFI::Library
  ffi_lib_flags :now
  ffi_lib "allegro_image.5.0"

  def self.attach_function(name, *_)
    begin; super; rescue FFI::NotFoundError => e
      (class << self; self; end).class_eval { define_method(name) { |*_| raise e } }
    end
  end

  # (Not documented)
  #
  # @method al_init_image_addon()
  # @return [Boolean]
  # @scope class
  attach_function :al_init_image_addon, :al_init_image_addon, [], :bool

  # (Not documented)
  #
  # @method al_shutdown_image_addon()
  # @return [nil]
  # @scope class
  attach_function :al_shutdown_image_addon, :al_shutdown_image_addon, [], :void

  # (Not documented)
  #
  # @method al_get_allegro_image_version()
  # @return [Integer]
  # @scope class
  attach_function :al_get_allegro_image_version, :al_get_allegro_image_version, [], :uint

end; end; end