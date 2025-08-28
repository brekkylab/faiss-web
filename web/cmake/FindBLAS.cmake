set(BLAS_FOUND TRUE)
set(BLAS_VERSION "3.12.1")
set(BLAS_LIBRARIES "blas")

# Target: blas_lib
set(BLAS_LIBRARY_PATH "${CMAKE_CURRENT_LIST_DIR}/../lib/libblas.a")
set(BLAS_BUILD_SCRIPT_PATH "${CMAKE_CURRENT_LIST_DIR}/../build_blas.sh")
if(EXISTS ${BLAS_LIBRARY_PATH})
    message(STATUS "Found BLAS library at ${BLAS_LIBRARY_PATH}")
else()
    message(STATUS "BLAS library not found, will build using Docker")
    add_custom_command(
        OUTPUT ${BLAS_LIBRARY_PATH}
        COMMAND docker run
            -v ${BLAS_BUILD_SCRIPT_PATH}:/build.sh
            -v ${CMAKE_CURRENT_LIST_DIR}/../lib:/workspace/lib
            -e LIBDIR=/workspace/lib
            -e BLAS_VERSION=${BLAS_VERSION}
            ghcr.io/r-wasm/flang-wasm:v20.1.4
            /build.sh
        DEPENDS ${BLAS_BUILD_SCRIPT_PATH}
        COMMENT "Building BLAS library with Docker"
        VERBATIM
    )
endif()
add_custom_target(blas_lib DEPENDS ${BLAS_LIBRARY_PATH})

# Target: blas
add_library(blas INTERFACE)
target_link_libraries(blas INTERFACE
    $<BUILD_INTERFACE:${BLAS_LIBRARY_PATH}>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/lib/libblas.a>
)
add_dependencies(blas blas_lib)
install(TARGETS blas
    EXPORT faiss-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(FILES ${BLAS_LIBRARY_PATH}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT faiss
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BLAS
    REQUIRED_VARS BLAS_FOUND BLAS_LIBRARIES
    VERSION_VAR BLAS_VERSION
)
