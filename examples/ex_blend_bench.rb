# Ruby port of ex_blend_bench.c from the Allegro examples.

# Benchmark for memory blenders.

require 'allegro4r'
include Allegro4r::API

require_relative "common"

# Do a few un-timed runs to switch CPU to performance mode and cache
# data and so on - seems to make the results more stable here.
# Also used to guess the number of timed iterations.
WARMUP = 100
# How many seconds the timing should approximately take - a fixed
# number of iterations is not enough on very fast systems but takes
# too long on slow systems.
TEST_TIME = 5.0

MODE_ALL = 0
MODE_PLAIN_BLIT = 1
MODE_SCALED_BLIT = 2
MODE_ROTATE_BLIT = 3

NAMES = [
  "", "Plain blit", "Scaled blit", "Rotated blit"
]

$display = nil

def step(mode, b2)
  case mode
  when MODE_ALL
    # skip
  when MODE_PLAIN_BLIT
    al_draw_bitmap(b2, 0, 0, 0)
  when MODE_SCALED_BLIT
    al_draw_scaled_bitmap(b2, 0, 0, 320, 200, 0, 0, 640, 480, 0)
  when MODE_ROTATE_BLIT
    al_draw_scaled_rotated_bitmap(b2, 10, 10, 10, 10, 2.0, 2.0,
      ALLEGRO_PI/30, 0)
  end
end

# al_get_current_time measures wallclock time - but for the benchmark
# result we prefer CPU time so clock is better.
def current_clock
  Process.clock_gettime(:CLOCK_BASED_CLOCK_PROCESS_CPUTIME_ID)
end

def do_test(mode)
  state = ALLEGROSTATE.new

  al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP)

  b1 = al_load_bitmap("data/mysha.pcx")
  if b1.null?
    abort_example("Error loading data/mysha.pcx\n")
    return false
  end

  b2 = al_load_bitmap("data/allegro.pcx")
  if b2.null?
    abort_example("Error loading data/mysha.pcx\n")
    return false
  end

  al_set_target_bitmap(b1)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA)
  step(mode, b2)

  # Display the blended bitmap to the screen so we can see something.
  al_store_state(state, ALLEGRO_STATE_ALL)
  al_set_target_backbuffer($display)
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO)
  al_draw_bitmap(b1, 0, 0, 0)
  al_flip_display
  al_restore_state(state)

  log_printf("Benchmark: %s\n", NAMES[mode])
  log_printf("Please wait...\n")

  # Do warmup run and estimate required runs for real test.
  t0 = current_clock
  WARMUP.times do |i|
    step(mode, b2)
  end
  t1 = current_clock
  repeat = (TEST_TIME * 100 / (t1 - t0)).to_i

  # Do the real test.
  t0 = current_clock
  repeat.times do |i|
    step(mode, b2)
  end
  t1 = current_clock

  log_printf("Time = %g s, %d steps\n",
    t1 - t0, repeat)
  log_printf("%s: %g FPS\n", NAMES[mode], repeat / (t1 - t0))
  log_printf("Done\n")

  al_destroy_bitmap(b1)
  al_destroy_bitmap(b2)

  true
end

def main(argc, argv)
  mode = MODE_ALL

  if argc > 1
    i = argv[1].to_i
    case i
    when 0 then mode = MODE_PLAIN_BLIT
    when 1 then mode = MODE_SCALED_BLIT
    when 2 then mode = MODE_ROTATE_BLIT
    end
  end

  abort_example("Could not init Allegro\n") unless al_init

  open_log

  al_init_image_addon
  al_init_primitives_addon

  $display = al_create_display(640, 480)
  abort_example("Error creating display\n") if $display.null?

  if mode == MODE_ALL
    (MODE_PLAIN_BLIT..MODE_ROTATE_BLIT).each do |mode|
      do_test(mode)
    end
  else
    do_test(mode)
  end

  al_destroy_display($display)

  close_log(true)
end

args = ARGV.unshift($0)
run_main(method(:main), args.length, args)
