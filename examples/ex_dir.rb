# Ruby port of ex_dir.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

def print_file(entry)
  mode = al_get_fs_entry_mode(entry)
  now = Time.now.to_i
  atime = al_get_fs_entry_atime(entry)
  ctime = al_get_fs_entry_ctime(entry)
  mtime = al_get_fs_entry_mtime(entry)
  size = al_get_fs_entry_size(entry)
  name = al_get_fs_entry_name(entry)

  log_printf("%-36s %s%s%s%s%s%s %8u %8u %8u %8u\n",
    name,
    mode & Allegro4r::API.enum_value(:allegro_filemode_read) != 0 ? "r" : ".",
    mode & Allegro4r::API.enum_value(:allegro_filemode_write) != 0 ? "w" : ".",
    mode & Allegro4r::API.enum_value(:allegro_filemode_execute) != 0 ? "x" : ".",
    mode & Allegro4r::API.enum_value(:allegro_filemode_hidden) != 0 ? "h" : ".",
    mode & Allegro4r::API.enum_value(:allegro_filemode_isfile) != 0 ? "f" : ".",
    mode & Allegro4r::API.enum_value(:allegro_filemode_isdir) != 0 ? "d" : ".",
    now - ctime,
    now - mtime,
    now - atime,
    size)
end

def print_entry(entry)
  print_file(entry)

  if al_get_fs_entry_mode(entry) & Allegro4r::API.enum_value(:allegro_filemode_isdir) != 0
    al_open_directory(entry)
    loop do
      next_dir = al_read_directory(entry)
      break if next_dir.null?

      print_entry(next_dir)
      al_destroy_fs_entry(next_dir)
    end
    al_close_directory(entry)
  end
end

def main(argc, argv)
  abort_example("Could not init Allegro.\n") unless al_init
  open_log_monospace

  log_printf("%-36s %-6s %8s %8s %8s %8s\n",
    "name", "flags", "ctime", "mtime", "atime", "size")
  log_printf(
    "------------------------------------ " \
    "------ " \
    "-------- " \
    "-------- " \
    "-------- " \
    "--------\n")

  if argc == 1
    entry = al_create_fs_entry("data")
    print_entry(entry)
    al_destroy_fs_entry(entry)
  end

  (1...argc).each do |i|
    entry = al_create_fs_entry(argv[i])
    print_entry(entry)
    al_destroy_fs_entry(entry)
  end

  close_log(true)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
