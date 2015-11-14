module Allegro4r::API
  ALLEGRO_VERSION_INT =
    ((ALLEGRO_VERSION << 24) | (ALLEGRO_SUB_VERSION << 16) |
    (ALLEGRO_WIP_VERSION << 8) | ALLEGRO_RELEASE_NUMBER)

  # enums not copied in yet by ffi_gen
  ALLEGRO_WINDOWED                    = 1 << 0
  ALLEGRO_FULLSCREEN                  = 1 << 1
  ALLEGRO_OPENGL                      = 1 << 2
  ALLEGRO_DIRECT3D_INTERNAL           = 1 << 3
  ALLEGRO_RESIZABLE                   = 1 << 4
  ALLEGRO_FRAMELESS                   = 1 << 5
  ALLEGRO_NOFRAME                     = ALLEGRO_FRAMELESS # older synonym
  ALLEGRO_GENERATE_EXPOSE_EVENTS      = 1 << 6
  ALLEGRO_OPENGL_3_0                  = 1 << 7
  ALLEGRO_OPENGL_FORWARD_COMPATIBLE   = 1 << 8
  ALLEGRO_FULLSCREEN_WINDOW           = 1 << 9
  ALLEGRO_MINIMIZED                   = 1 << 10

  ALLEGRO_MEMORY_BITMAP            = 0x0001
  ALLEGRO_KEEP_BITMAP_FORMAT       = 0x0002
  ALLEGRO_FORCE_LOCKING            = 0x0004
  ALLEGRO_NO_PRESERVE_TEXTURE      = 0x0008
  ALLEGRO_ALPHA_TEST               = 0x0010
  ALLEGRO_INTERNAL_OPENGL          = 0x0020 # internal
  ALLEGRO_MIN_LINEAR               = 0x0040
  ALLEGRO_MAG_LINEAR               = 0x0080
  ALLEGRO_MIPMAP                   = 0x0100
  ALLEGRO_NO_PREMULTIPLIED_ALPHA   = 0x0200
  ALLEGRO_VIDEO_BITMAP             = 0x0400

  ALLEGRO_ALIGN_LEFT       = 0
  ALLEGRO_ALIGN_CENTRE     = 1
  ALLEGRO_ALIGN_CENTER     = 1
  ALLEGRO_ALIGN_RIGHT      = 2
  ALLEGRO_ALIGN_INTEGER    = 4

  ALLEGRO_EVENT_JOYSTICK_AXIS               =  1
  ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN        =  2
  ALLEGRO_EVENT_JOYSTICK_BUTTON_UP          =  3
  ALLEGRO_EVENT_JOYSTICK_CONFIGURATION      =  4

  ALLEGRO_EVENT_KEY_DOWN                    = 10
  ALLEGRO_EVENT_KEY_CHAR                    = 11
  ALLEGRO_EVENT_KEY_UP                      = 12

  ALLEGRO_EVENT_MOUSE_AXES                  = 20
  ALLEGRO_EVENT_MOUSE_BUTTON_DOWN           = 21
  ALLEGRO_EVENT_MOUSE_BUTTON_UP             = 22
  ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY         = 23
  ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY         = 24
  ALLEGRO_EVENT_MOUSE_WARPED                = 25

  ALLEGRO_EVENT_TIMER                       = 30

  ALLEGRO_EVENT_DISPLAY_EXPOSE              = 40
  ALLEGRO_EVENT_DISPLAY_RESIZE              = 41
  ALLEGRO_EVENT_DISPLAY_CLOSE               = 42
  ALLEGRO_EVENT_DISPLAY_LOST                = 43
  ALLEGRO_EVENT_DISPLAY_FOUND               = 44
  ALLEGRO_EVENT_DISPLAY_SWITCH_IN           = 45
  ALLEGRO_EVENT_DISPLAY_SWITCH_OUT          = 46
  ALLEGRO_EVENT_DISPLAY_ORIENTATION         = 47

  ALLEGRO_KEY_A   = 1
  ALLEGRO_KEY_B    = 2
  ALLEGRO_KEY_C    = 3
  ALLEGRO_KEY_D    = 4
  ALLEGRO_KEY_E    = 5
  ALLEGRO_KEY_F    = 6
  ALLEGRO_KEY_G    = 7
  ALLEGRO_KEY_H    = 8
  ALLEGRO_KEY_I    = 9
  ALLEGRO_KEY_J    = 10
  ALLEGRO_KEY_K    = 11
  ALLEGRO_KEY_L    = 12
  ALLEGRO_KEY_M    = 13
  ALLEGRO_KEY_N    = 14
  ALLEGRO_KEY_O    = 15
  ALLEGRO_KEY_P    = 16
  ALLEGRO_KEY_Q    = 17
  ALLEGRO_KEY_R    = 18
  ALLEGRO_KEY_S    = 19
  ALLEGRO_KEY_T    = 20
  ALLEGRO_KEY_U    = 21
  ALLEGRO_KEY_V    = 22
  ALLEGRO_KEY_W    = 23
  ALLEGRO_KEY_X    = 24
  ALLEGRO_KEY_Y    = 25
  ALLEGRO_KEY_Z    = 26

  ALLEGRO_KEY_0    = 27
  ALLEGRO_KEY_1    = 28
  ALLEGRO_KEY_2    = 29
  ALLEGRO_KEY_3    = 30
  ALLEGRO_KEY_4    = 31
  ALLEGRO_KEY_5    = 32
  ALLEGRO_KEY_6    = 33
  ALLEGRO_KEY_7    = 34
  ALLEGRO_KEY_8    = 35
  ALLEGRO_KEY_9    = 36

  ALLEGRO_KEY_PAD_0    = 37
  ALLEGRO_KEY_PAD_1    = 38
  ALLEGRO_KEY_PAD_2    = 39
  ALLEGRO_KEY_PAD_3    = 40
  ALLEGRO_KEY_PAD_4    = 41
  ALLEGRO_KEY_PAD_5    = 42
  ALLEGRO_KEY_PAD_6    = 43
  ALLEGRO_KEY_PAD_7    = 44
  ALLEGRO_KEY_PAD_8    = 45
  ALLEGRO_KEY_PAD_9    = 46

  ALLEGRO_KEY_F1   = 47
  ALLEGRO_KEY_F2   = 48
  ALLEGRO_KEY_F3   = 49
  ALLEGRO_KEY_F4   = 50
  ALLEGRO_KEY_F5   = 51
  ALLEGRO_KEY_F6   = 52
  ALLEGRO_KEY_F7   = 53
  ALLEGRO_KEY_F8   = 54
  ALLEGRO_KEY_F9   = 55
  ALLEGRO_KEY_F10    = 56
  ALLEGRO_KEY_F11    = 57
  ALLEGRO_KEY_F12    = 58

  ALLEGRO_KEY_ESCAPE = 59
  ALLEGRO_KEY_TILDE    = 60
  ALLEGRO_KEY_MINUS    = 61
  ALLEGRO_KEY_EQUALS = 62
  ALLEGRO_KEY_BACKSPACE  = 63
  ALLEGRO_KEY_TAB    = 64
  ALLEGRO_KEY_OPENBRACE  = 65
  ALLEGRO_KEY_CLOSEBRACE = 66
  ALLEGRO_KEY_ENTER    = 67
  ALLEGRO_KEY_SEMICOLON  = 68
  ALLEGRO_KEY_QUOTE    = 69
  ALLEGRO_KEY_BACKSLASH  = 70
  ALLEGRO_KEY_BACKSLASH2 = 71 # DirectInput calls this DIK_OEM_102: "< > | on UK/Germany keyboards"
  ALLEGRO_KEY_COMMA    = 72
  ALLEGRO_KEY_FULLSTOP = 73
  ALLEGRO_KEY_SLASH    = 74
  ALLEGRO_KEY_SPACE    = 75

  ALLEGRO_KEY_INSERT = 76
  ALLEGRO_KEY_DELETE = 77
  ALLEGRO_KEY_HOME   = 78
  ALLEGRO_KEY_END    = 79
  ALLEGRO_KEY_PGUP   = 80
  ALLEGRO_KEY_PGDN   = 81
  ALLEGRO_KEY_LEFT   = 82
  ALLEGRO_KEY_RIGHT    = 83
  ALLEGRO_KEY_UP   = 84
  ALLEGRO_KEY_DOWN   = 85

  ALLEGRO_KEY_PAD_SLASH  = 86
  ALLEGRO_KEY_PAD_ASTERISK = 87
  ALLEGRO_KEY_PAD_MINUS  = 88
  ALLEGRO_KEY_PAD_PLUS = 89
  ALLEGRO_KEY_PAD_DELETE = 90
  ALLEGRO_KEY_PAD_ENTER  = 91

  ALLEGRO_KEY_PRINTSCREEN  = 92
  ALLEGRO_KEY_PAUSE    = 93

  ALLEGRO_KEY_ABNT_C1  = 94
  ALLEGRO_KEY_YEN    = 95
  ALLEGRO_KEY_KANA   = 96
  ALLEGRO_KEY_CONVERT  = 97
  ALLEGRO_KEY_NOCONVERT  = 98
  ALLEGRO_KEY_AT   = 99
  ALLEGRO_KEY_CIRCUMFLEX = 100
  ALLEGRO_KEY_COLON2 = 101
  ALLEGRO_KEY_KANJI    = 102

  ALLEGRO_KEY_PAD_EQUALS = 103  # MacOS X
  ALLEGRO_KEY_BACKQUOTE  = 104  # MacOS X
  ALLEGRO_KEY_SEMICOLON2 = 105  # MacOS X -- TODO: ask lillo what this should be
  ALLEGRO_KEY_COMMAND  = 106  # MacOS X
  ALLEGRO_KEY_UNKNOWN      = 107

  # All codes up to before ALLEGRO_KEY_MODIFIERS can be freely
  # assignedas additional unknown keys, like various multimedia
  # and application keys keyboards may have.

  ALLEGRO_KEY_MODIFIERS  = 215

  ALLEGRO_KEY_LSHIFT = 215
  ALLEGRO_KEY_RSHIFT = 216
  ALLEGRO_KEY_LCTRL  = 217
  ALLEGRO_KEY_RCTRL  = 218
  ALLEGRO_KEY_ALT    = 219
  ALLEGRO_KEY_ALTGR  = 220
  ALLEGRO_KEY_LWIN   = 221
  ALLEGRO_KEY_RWIN   = 222
  ALLEGRO_KEY_MENU   = 223
  ALLEGRO_KEY_SCROLLLOCK = 224
  ALLEGRO_KEY_NUMLOCK  = 225
  ALLEGRO_KEY_CAPSLOCK = 226

  ALLEGRO_KEY_MAX = 227

  ALLEGRO_KEYMOD_SHIFT       = 0x00001
  ALLEGRO_KEYMOD_CTRL        = 0x00002
  ALLEGRO_KEYMOD_ALT         = 0x00004
  ALLEGRO_KEYMOD_LWIN        = 0x00008
  ALLEGRO_KEYMOD_RWIN        = 0x00010
  ALLEGRO_KEYMOD_MENU        = 0x00020
  ALLEGRO_KEYMOD_ALTGR       = 0x00040
  ALLEGRO_KEYMOD_COMMAND     = 0x00080
  ALLEGRO_KEYMOD_SCROLLLOCK  = 0x00100
  ALLEGRO_KEYMOD_NUMLOCK     = 0x00200
  ALLEGRO_KEYMOD_CAPSLOCK    = 0x00400
  ALLEGRO_KEYMOD_INALTSEQ   = 0x00800
  ALLEGRO_KEYMOD_ACCENT1     = 0x01000
  ALLEGRO_KEYMOD_ACCENT2     = 0x02000
  ALLEGRO_KEYMOD_ACCENT3     = 0x04000
  ALLEGRO_KEYMOD_ACCENT4     = 0x08000

  # NOTE: These have enum definitions with names, but ffi_gen is broken/weird
  ALLEGRO_ZERO               = 0
  ALLEGRO_ONE                = 1
  ALLEGRO_ALPHA              = 2
  ALLEGRO_INVERSE_ALPHA      = 3
  ALLEGRO_SRC_COLOR          = 4
  ALLEGRO_DEST_COLOR         = 5
  ALLEGRO_INVERSE_SRC_COLOR  = 6
  ALLEGRO_INVERSE_DEST_COLOR = 7
  ALLEGRO_NUM_BLEND_MODES    = 8

  ALLEGRO_ADD                = 0
  ALLEGRO_SRC_MINUS_DEST     = 1
  ALLEGRO_DEST_MINUS_SRC     = 2
  ALLEGRO_NUM_BLEND_OPERATIONS = 3

  def self.al_init
    al_install_system(ALLEGRO_VERSION_INT, nil)
  end

  def al_init
    Allegro4r::API.al_init
  end

  def self.run_main(real_main, *args)
    argc = 0
    argv = FFI::MemoryPointer.new(:pointer)
    argv.write_array_of_pointer([FFI::Pointer::NULL])

    callback = run_main_callback(real_main, *args)

    al_run_main(argc, argv, callback)
  end

  def run_main(real_main, *args)
    Allegro4r::API.run_main(real_main, *args)
  end

  def self.run_main_callback(real_main, *args)
    run_main_backtrace = caller
    FFI::Function.new(:int, [:int, :pointer]) do
      begin
        real_main.call(*args)
        0
      rescue SystemExit => err
        err.status
      rescue Exception => err
        full_backtrace = err.backtrace[0..-2] + run_main_backtrace
        STDERR.puts "#{full_backtrace[0]}: #{err.message} (#{err.class})"
        STDERR.puts full_backtrace[1..-1].map { |l| "\tfrom #{l}" }.join("\n")
        1
      ensure
        al_uninstall_system
      end
    end
  end
  private_class_method :run_main_callback
end