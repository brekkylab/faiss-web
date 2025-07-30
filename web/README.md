## Build faiss for wasm target

### Setup Emscripten

Refer to [Download Emscripten](https://emscripten.org/docs/getting_started/downloads.html) to setup emscripten.


### Build faiss

Building faiss for wasm target requires BLAS and LAPACK to be also built for wasm target.

The cmake files under `web/cmake` builds the required libraries automatically, so make sure to provide `-DCMAKE_MODULE_PATH=$(pwd)/web/cmake`.

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

emmake make faiss -j$(nproc)
```
