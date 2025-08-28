add_library(OpenMP_CXX INTERFACE)
target_include_directories(OpenMP_CXX INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/../include>
)
target_compile_options(OpenMP_CXX INTERFACE "-Wno-unknown-pragmas")

add_library(OpenMP::OpenMP_CXX ALIAS OpenMP_CXX)

install(TARGETS OpenMP_CXX
    EXPORT faiss-targets
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(FILES "${CMAKE_CURRENT_LIST_DIR}/../include/omp.h"
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    COMPONENT faiss
)

include(FindPackageHandleStandardArgs)
set(OpenMP_FOUND TRUE)
set(OpenMP_VERSION "Dummy")
find_package_handle_standard_args(OpenMP
    REQUIRED_VARS OpenMP_FOUND
    VERSION_VAR OpenMP_VERSION
)
