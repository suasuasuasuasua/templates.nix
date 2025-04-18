# Define CMAKE requirements
cmake_minimum_required(VERSION 3.16)
project(myProject LANGUAGES C CXX)

# Define the standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Ensure the specified standard is used

# Check the build type
if(NOT CMAKE_BUILD_TYPE)
  set(default_build_type "Debug")
  message(
  STATUS
    "Set the build type to `${default_build_type}` as none was specified.")
  set(CMAKE_BUILD_TYPE
    ${default_build_type}
    CACHE STRING "Chooce the build type." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Set the flags
set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

message(STATUS "myProject Build Type: ${CMAKE_BUILD_TYPE}")

# Set the version for myProject
set(myProject_Version_Major 0)
set(myProject_Version_Minor 1)
set(myProject_Version_Patch 0)
set(myProject_Version_Status "-dev")
set(PROJECT_VERSION
    "${myProject_Version_Major}.${myProject_Version_Minor}.${myProject_Version_Patch}${myProject_Version_Status}"
)
message(STATUS "${PROJECT_NAME} version: ${PROJECT_VERSION}")

add_subdirectory(src)
