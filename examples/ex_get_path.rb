# Ruby port of ex_get_path.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

def show_path(id, label)
  path = al_get_standard_path(id)
  path_str = !path.null? ? al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP) : "<none>"
  log_printf("%s: %s\n", label, path_str)
  al_destroy_path(path)
end

def main
  # defaults to blank
  al_set_org_name("liballeg.org")

  # defaults to the exename, set it here to remove the .exe on windows
  al_set_app_name("ex_get_path")

  abort_example("Could not init Allegro.\n") unless al_init
  open_log

  (1..3).each do |pass|
    case pass
    when 1
      log_printf("With default exe name:\n")
    when 2
      log_printf("\nOverriding exe name to blahblah\n")
      al_set_exe_name("blahblah")
    when 3
      log_printf("\nOverriding exe name to /tmp/blahblah.exe:\n")
      al_set_exe_name("/tmp/blahblah.exe")
    end

    show_path(ALLEGRO_RESOURCES_PATH, "RESOURCES_PATH")
    show_path(ALLEGRO_TEMP_PATH, "TEMP_PATH")
    show_path(ALLEGRO_USER_DATA_PATH, "USER_DATA_PATH")
    show_path(ALLEGRO_USER_SETTINGS_PATH, "USER_SETTINGS_PATH")
    show_path(ALLEGRO_USER_HOME_PATH, "USER_HOME_PATH")
    show_path(ALLEGRO_USER_DOCUMENTS_PATH, "USER_DOCUMENTS_PATH")
    show_path(ALLEGRO_EXENAME_PATH, "EXENAME_PATH")
  end

  close_log(true)
end

run_main(method(:main))
