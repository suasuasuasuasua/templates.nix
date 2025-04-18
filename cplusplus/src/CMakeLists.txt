# recursively find cpp and h files for SOURCES
file(GLOB_RECURSE SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
)

# Add the actual executable
add_executable(
  helloworld
  ${SOURCES}
)

# Include directories (if needed)
# target_include_directories(MyProject PRIVATE include)

# Link libraries (if needed)
# target_link_libraries(MyProject PRIVATE some_library)
