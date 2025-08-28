## Building Faiss for WebAssembly (WASM)

### Setup Emscripten

Follow the instructions in [Download Emscripten](https://emscripten.org/docs/getting_started/downloads.html) to install and configure Emscripten.


### Build Faiss

To compile Faiss for the WebAssembly target, both **BLAS** and **LAPACK** must also be built for WebAssembly.

The CMake files under `web/cmake` handle building these dependencies automatically. Be sure to pass `-DCMAKE_MODULE_PATH=$(pwd)/web/cmake` when configuring CMake.

```bash
emcmake cmake \
    -B./build \
    -DCMAKE_MODULE_PATH=$(pwd)/web/cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DFAISS_OPT_LEVEL=generic \
    -DFAISS_ENABLE_GPU=OFF \
    -DFAISS_ENABLE_PYTHON=OFF \
    -DFAISS_ENABLE_C_API=OFF \
    -DFAISS_ENABLE_EXTRAS=OFF \
    -DBUILD_TESTING=OFF

cmake --build ./build --parallel $(nproc)
```

The generated `libblas.a` and `liblapack.a` files are placed under `web/lib` instead of `CMAKE_BINARY_DIR`.
This prevents them from being rebuilt when the build directory is removed.

If you need to rebuild them, simply delete the `web/lib` directory before running the build again.


#### Enabling Pthreads (Optional)

If you'd like to enable Emscripten's [Pthreads support](https://emscripten.org/docs/porting/pthreads.html), add the following flag:

```bash
emcmake cmake \
    # ... \
    -DCMAKE_CXX_FLAGS="-pthread"
```
