# Ruby port of ex_gp2xwiz.c from the Allegro examples.

require 'allegro4r'
include Allegro4r::API

require_relative 'common'

W = 320
H = 240
R = 240
POINTS = 200

def main
  abort_example("Could not init Allegro.\n") unless al_init
  al_init_primitives_addon

  d = al_create_display(W, H)
  abort_example("Error creating display\n") if d.null?

  vs = FFI::MemoryPointer.new(AllegroVertex, POINTS)
  v = Array.new(POINTS) { |i| AllegroVertex.new(vs + i * AllegroVertex.size) }

  v[0][:x] = 0
  v[0][:y] = 0
  v[0][:color] = al_map_rgb(rand(256), rand(256), rand(256))
  v[1][:x] = 0 + R
  v[1][:y] = 0
  v[1][:color] = al_map_rgb(rand(256), rand(256), rand(256))

  a = 0.0
  r = R.to_f

  (2...POINTS).each do |i|
    v[i][:x] = 0 + Math.cos(a) * r
    v[i][:y] = 0 + Math.sin(a) * r
    a += 0.3
    r -= 1.5
    v[i][:color] = al_map_rgb(rand(256), rand(256), rand(256))
  end

  frames = 0
  t = AllegroTransform.new

  loop do
    al_clear_to_color(al_map_rgb(0, 0, 0))
    al_identity_transform(t)
    al_rotate_transform(t, frames * 0.1)
    al_translate_transform(t, W / 2, H / 2)
    al_use_transform(t)
    al_draw_prim(vs, nil, al_get_target_bitmap, 0, POINTS, :allegro_prim_triangle_fan)
    al_flip_display
    # GP2X Wiz is locked to 60FPS using OpenGL
    frames += 1
    break if frames > 400
  end
end

run_main(method(:main))
