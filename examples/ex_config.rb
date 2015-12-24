# Ruby port of ex_config.c from the Allegro examples.

# Example program for the Allegro library.
#
# Test config file reading and writing.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

$passed = true

def test(name, expr)
  if expr
    log_printf(" PASS - %s\n", name)
  else
    log_printf("!FAIL - %s\n", name)
    $passed = false
  end
end

def main
  iterator = AllegroConfigSection.new
  iterator2 = AllegroConfigEntry.new

  abort_example("Could not init Allegro.\n") unless al_init
  open_log

  cfg = al_load_config_file("data/sample.cfg")
  abort_example("Couldn't load data/sample.cfg\n") if cfg.null?

  value = al_get_config_value(cfg, nil, "old_var")
  test("global var", value == "old global value")

  value = al_get_config_value(cfg, "section", "old_var")
  test("section var", value == "old section value")

  value = al_get_config_value(cfg, "", "mysha.xpm")
  test("long value", value && value.length == 1394)

  # Test whether iterating through our whole sample.cfg returns all
  # sections and entries, in order.

  value = al_get_first_config_section(cfg, iterator)
  test("section1", value == "")

  value = al_get_first_config_entry(cfg, value, iterator2)
  test("entry1", value == "old_var")

  value = al_get_next_config_entry(iterator2)
  test("entry2", value == "mysha.xpm")

  value = al_get_next_config_entry(iterator2)
  test("entry3", value.nil?)

  value = al_get_next_config_section(iterator)
  test("section2", value == "section")

  value = al_get_first_config_entry(cfg, value, iterator2)
  test("entry4", value == "old_var")

  value = al_get_next_config_entry(iterator2)
  test("entry5", value.nil?)

  value = al_get_next_config_section(iterator)
  test("section3", value)

  value = al_get_first_config_entry(cfg, value, iterator2)
  test("entry6", value)

  value = al_get_next_config_entry(iterator2)
  test("entry7", value.nil?)

  value = al_get_next_config_section(iterator)
  test("section4", value.nil?)



  al_set_config_value(cfg, "", "new_var", "new value")
  al_set_config_value(cfg, "section", "old_var", "new value")

  test("save_config", al_save_config_file("test.cfg", cfg))

  log_printf("Done\n")

  al_destroy_config(cfg)

  close_log(true)

  exit 1 unless $passed
end

run_main(method(:main))
