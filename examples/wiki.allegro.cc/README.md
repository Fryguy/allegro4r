# wiki.allegro.cc Examples

These examples are compiled from the
[Allegro 5 API Tutorials](https://wiki.allegro.cc/index.php?title=Allegro_5_API_Tutorials).

## Notes on compiling the C source

For those not familiar with development against Allegro in C, but would like to
compile the examples for comparison against their Ruby couterparts, this is a
few examples on getting the C examples to compile.

- Given the source located [here](https://wiki.allegro.cc/index.php?title=Allegro_5_Tutorial/Displays),
  store it in a file named 01-displays.c and compile with:

  ```sh
  gcc 01-displays.c -o 01-displays.c -lallegro -lallegro_main
  ```

  As can be seen, you must link to both allegro and allegro_main.

- Given the source located [here](https://wiki.allegro.cc/index.php?title=Creating_a_fullscreen_display_with_maximum/minimum_resolution),
  store it in a file named 01a-fullscreen.c and compile with:

  ```sh
  gcc 01a-fullscreen.c -o 01a-fullscreen -lallegro -lallegro_main -lallegro_image -lallegro_primitives
  ```

  As can be seen, there are extra linker targets allegro_image and allegro_primitives.
  These are known as optional addons in Allegro, and need to be linked because
  they are being referenced in the C source.

