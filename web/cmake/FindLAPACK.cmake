# Target: lapack_lib
set(LAPACK_LIBRARY_PATH "${CMAKE_BINARY_DIR}/web/liblapack.a")
set(LAPACK_BUILD_SCRIPT_PATH "${CMAKE_CURRENT_LIST_DIR}/../build_lapack.sh")
if(EXISTS ${LAPACK_LIBRARY_PATH})
    message(STATUS "Found LAPACK library at ${LAPACK_LIBRARY_PATH}")
else()
    message(STATUS "LAPACK library not found, will build using Docker")
    add_custom_command(
        OUTPUT ${LAPACK_LIBRARY_PATH}
        COMMAND docker run
            -v ${LAPACK_BUILD_SCRIPT_PATH}:/build.sh
            -v ${CMAKE_CURRENT_LIST_DIR}/../lib:/workspace/lib
            -e LIBDIR=/workspace/lib
            ghcr.io/r-wasm/flang-wasm:v20.1.4
            /build.sh
        DEPENDS ${LAPACK_BUILD_SCRIPT_PATH}
        COMMENT "Building LAPACK library with Docker"
        VERBATIM
    )
endif()
add_custom_target(lapack_lib DEPENDS ${LAPACK_LIBRARY_PATH})

# Target: lapack
add_library(lapack INTERFACE)
target_link_libraries(lapack INTERFACE
    $<BUILD_INTERFACE:${LAPACK_LIBRARY_PATH}>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/lib/liblapack.a>
)
add_dependencies(lapack lapack_lib)
install(TARGETS lapack
    EXPORT faiss-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(FILES ${LAPACK_LIBRARY_PATH}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT faiss
)

include(FindPackageHandleStandardArgs)
set(LAPACK_FOUND TRUE)
set(LAPACK_VERSION "3.12.0")
set(LAPACK_LIBRARIES "lapack")
find_package_handle_standard_args(LAPACK
    REQUIRED_VARS LAPACK_FOUND LAPACK_LIBRARIES
    VERSION_VAR LAPACK_VERSION
)
