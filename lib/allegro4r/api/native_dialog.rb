# Generated by ffi_gen. Please do not change this file by hand.

require 'ffi'

module Allegro4r::API::NativeDialog
  extend FFI::Library
  ffi_lib_flags :now
  ffi_lib "allegro_dialog.5.0"

  def self.attach_function(name, *_)
    begin; super; rescue FFI::NotFoundError => e
      (class << self; self; end).class_eval { define_method(name) { |*_| raise e } }
    end
  end

  # Type: ALLEGRO_FILECHOOSER
  class ALLEGROFILECHOOSER < FFI::Struct
    layout :dummy, :char
  end

  # Type: ALLEGRO_TEXTLOG
  class ALLEGROTEXTLOG < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  #
  # @method al_init_native_dialog_addon()
  # @return [Boolean]
  # @scope class
  attach_function :al_init_native_dialog_addon, :al_init_native_dialog_addon, [], :bool

  # (Not documented)
  #
  # @method al_shutdown_native_dialog_addon()
  # @return [nil]
  # @scope class
  attach_function :al_shutdown_native_dialog_addon, :al_shutdown_native_dialog_addon, [], :void

  # (Not documented)
  #
  # @method al_create_native_file_dialog(initial_path, title, patterns, mode)
  # @param [String] initial_path
  # @param [String] title
  # @param [String] patterns
  # @param [Integer] mode
  # @return [ALLEGROFILECHOOSER]
  # @scope class
  attach_function :al_create_native_file_dialog, :al_create_native_file_dialog, [:string, :string, :string, :int], ALLEGROFILECHOOSER

  # (Not documented)
  #
  # @method al_show_native_file_dialog(display, dialog)
  # @param [FFI::Pointer(*ALLEGRODISPLAY)] display
  # @param [ALLEGROFILECHOOSER] dialog
  # @return [Boolean]
  # @scope class
  attach_function :al_show_native_file_dialog, :al_show_native_file_dialog, [:pointer, ALLEGROFILECHOOSER], :bool

  # (Not documented)
  #
  # @method al_get_native_file_dialog_count(dialog)
  # @param [ALLEGROFILECHOOSER] dialog
  # @return [Integer]
  # @scope class
  attach_function :al_get_native_file_dialog_count, :al_get_native_file_dialog_count, [ALLEGROFILECHOOSER], :int

  # (Not documented)
  #
  # @method al_get_native_file_dialog_path(dialog, index)
  # @param [ALLEGROFILECHOOSER] dialog
  # @param [Integer] index
  # @return [String]
  # @scope class
  attach_function :al_get_native_file_dialog_path, :al_get_native_file_dialog_path, [ALLEGROFILECHOOSER, :ulong], :string

  # (Not documented)
  #
  # @method al_destroy_native_file_dialog(dialog)
  # @param [ALLEGROFILECHOOSER] dialog
  # @return [nil]
  # @scope class
  attach_function :al_destroy_native_file_dialog, :al_destroy_native_file_dialog, [ALLEGROFILECHOOSER], :void

  # (Not documented)
  #
  # @method al_show_native_message_box(display, title, heading, text, buttons, flags)
  # @param [FFI::Pointer(*ALLEGRODISPLAY)] display
  # @param [String] title
  # @param [String] heading
  # @param [String] text
  # @param [String] buttons
  # @param [Integer] flags
  # @return [Integer]
  # @scope class
  attach_function :al_show_native_message_box, :al_show_native_message_box, [:pointer, :string, :string, :string, :string, :int], :int

  # (Not documented)
  #
  # @method al_open_native_text_log(title, flags)
  # @param [String] title
  # @param [Integer] flags
  # @return [ALLEGROTEXTLOG]
  # @scope class
  attach_function :al_open_native_text_log, :al_open_native_text_log, [:string, :int], ALLEGROTEXTLOG

  # (Not documented)
  #
  # @method al_close_native_text_log(textlog)
  # @param [ALLEGROTEXTLOG] textlog
  # @return [nil]
  # @scope class
  attach_function :al_close_native_text_log, :al_close_native_text_log, [ALLEGROTEXTLOG], :void

  # (Not documented)
  #
  # @method al_append_native_text_log(textlog, format)
  # @param [ALLEGROTEXTLOG] textlog
  # @param [String] format
  # @return [nil]
  # @scope class
  attach_function :al_append_native_text_log, :al_append_native_text_log, [ALLEGROTEXTLOG, :string], :void

  # (Not documented)
  #
  # @method al_get_native_text_log_event_source(textlog)
  # @param [ALLEGROTEXTLOG] textlog
  # @return [FFI::Pointer(*ALLEGROEVENTSOURCE)]
  # @scope class
  attach_function :al_get_native_text_log_event_source, :al_get_native_text_log_event_source, [ALLEGROTEXTLOG], :pointer

  # (Not documented)
  #
  # @method al_get_allegro_native_dialog_version()
  # @return [Integer]
  # @scope class
  attach_function :al_get_allegro_native_dialog_version, :al_get_allegro_native_dialog_version, [], :uint

end