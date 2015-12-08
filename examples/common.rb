# Ruby port of common.c from the Allegro examples.

require 'allegro4r'

if ENV["ALLEGRO_POPUP_EXAMPLES"]

  include Allegro4r::API::NativeDialog

  $textlog = nil

  def abort_example(format, *args)
    str = format % args
    if al_init_native_dialog_addon
      display = al_is_system_installed ? al_get_current_display : nil
      al_show_native_message_box(display, "Error", "Cannot run example", str, nil, 0)
    else
      STDERR.print(str)
    end
    exit 1
  end

  def open_log
    if al_init_native_dialog_addon
      $textlog = al_open_native_text_log("Log", 0)
    end
  end

  def open_log_monospace
    if al_init_native_dialog_addon
      $textlog = al_open_native_text_log("Log", ALLEGRO_TEXTLOG_MONOSPACE)
    end
  end

  def close_log(wait_for_user)
    if $textlog && wait_for_user
      queue = al_create_event_queue
      al_register_event_source(queue, al_get_native_text_log_event_source(
        $textlog))
      al_wait_for_event(queue, nil)
      al_destroy_event_queue(queue)
    end

    al_close_native_text_log($textlog)
    $textlog = nil
  end

  def log_printf(format, *args)
    str = format % args
    al_append_native_text_log($textlog, str)
  end

else

  def abort_example(format, *args)
    STDERR.print(format % args)
    exit 1
  end

  def open_log
  end

  def open_log_monospace
  end

  def close_log(_wait_for_user)
  end

  def log_printf(format, *args)
    STDERR.print(format % args)
  end

end
