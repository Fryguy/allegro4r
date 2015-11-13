# API Generator

## Instructions

- Install Allegro as per the [README](../README.md)
- Retrieve the source
  - from homebrew
    - `brew unpack allegro --destdir=/usr/local/src`
    - `export ALLEGRO_SOURCE_DIR=/usr/local/src/allegro-5.0.11`
  - or from git
    - `git clone git@github.com:liballeg/allegro5.git /usr/local/src/allegro.git`
    - `git checkout 5.0.11`
    - `export ALLEGRO_SOURCE_DIR=/usr/local/src/allegro.git`
- Install LLVM
  - from source
    - `brew install llvm --with-clang` - NOTE: Takes about an hour
    - `export LLVM_PREFIX=llvm`
  - or from clang binaries
    - Download from http://llvm.org/releases/3.7.0/clang+llvm-3.7.0-x86_64-apple-darwin.tar.xz
      and untar into /usr/local/opt/clang+llvm
    - `export LLVM_PREFIX=clang+llvm`
- Prepare the rest of the environment variables
  ```
  export PATH=$PATH:/usr/local/opt/$LLVM_PREFIX/bin
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/opt/$LLVM_PREFIX/lib
  export CPATH=$CPATH:$ALLEGRO_SOURCE_DIR/src/include
  ```
- `cd gen`
- `ruby generate.rb`
