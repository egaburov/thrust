cmake_minimum_required(VERSION 3.0)

file(READ "thrust/version.h" thrust_version_file)
string(REGEX MATCH "THRUST_VERSION ([0-9]+)" DUMMY ${thrust_version_file})
set(thrust_version ${CMAKE_MATCH_1})
#message("thrust_version= ${thrust_version}")
math(EXPR Thrust_VERSION_MAJOR "(${thrust_version} / 100000)")
math(EXPR Thrust_VERSION_MINOR "(${thrust_version} / 100) % 1000")
math(EXPR Thrust_VERSION_PATCH " ${thrust_version} % 100")

message(STATUS "Thrust version ${Thrust_VERSION_MAJOR}.${Thrust_VERSION_MINOR}.${Thrust_VERSION_PATCH}")

project(Thrust CXX)


function(print_flags flags)
  message("${flags}:")
  set(flags ${${flags}})
  set(__is_name True)
  foreach(arg ${flags})
    if (__is_name)
      set(__arg_name ${arg})
      set(__is_name False)
    else()
      separate_arguments(arg)
      set(arg ${arg})
      message(" | ${__arg_name} : '${arg}'")
      set(__is_name True)
    endif()
  endforeach()
endfunction()


set(
  GNU_COMPILER_FLAGS
  WARN_ALL             "-Wall"
  WARNINGS_AS_ERRORS   "-Werror"
  RELEASE              "-O2"
  DEBUG                "-g"
  EXCEPTION_HANDLING   " "
  CPP                  " "
  OMP                  "-fopenmp"
  TBB                  " "
  CUDA                 " "
  WORKAROUNDS          " "
  C++03                " "
  C++11                "-std=c++11"
  )
set(
  GNU_LINKER_FLAGS
  DEBUG " "
  RELEASE " "
  WORKAROUNDS " "
  )

set(
  CLANG_COMPILER_FLAGS
  WARN_ALL             "-Wall"
  WARNINGS_AS_ERRORS   "-Werror"
  RELEASE              "-O2"
  DEBUG                "-g"
  EXCEPTION_HANDLING   " "
  CPP                  " "
  OMP                  "-fopenmp"
  TBB                  " "
  CUDA                 " "
  WORKAROUNDS          " "
  C++03                " "
  C++11                "-std=c++11"
  )
set(
  CLANG_LINKER_FLAGS
  DEBUG " "
  RELEASE " "
  WORKAROUNDS "-stdlib=libstdc++"
  )

set(
  MSVC_COMPILER_FLAGS
  WARN_ALL             "/Wall"
  WARNINGS_AS_ERRORS   "/Wx"
  RELEASE              "/Ox"
  DEBUG                "/Zi -D_DEBUG /MTd"
  EXCEPTION_HANDLING   "/EHsc"
  CPP                  " "
  OMP                  "/openmp"
  TBB                  " "
  CUDA                 " "
  WORKAROUNDS          "/DNOMINMAX /wd4503"
  C++03                " "
  C++11                "-std=c++11"
  )
set(
  MSVC_LINKER
  DEBUG "/debug"
  RELEASE  " "
  WORKAROUND "/nologo"
  )

set(NV_LINKER_FLAGS ${GNU_LINKER_FLAGS})

# print_flags(MSVC_COMPILER_FLAGS)


function(add_option OPTION_NAME DESCRIPTION TYPE)
  if (${ARGC} EQUAL 3)
    message(FATAL_ERROR "No option value [list] is provided")
  endif()
  if (${OPTION_NAME} AND "x${TYPE}" STREQUAL "xSTRING")
    LIST(FIND ARGN ${${OPTION_NAME}} index)
    if (index EQUAL -1)
      message(FATAL_ERROR "Invalid value '${${OPTION_NAME}}' for '${DESCRIPTION}'")
    endif()
  endif()
  set(value_list ${ARGN})
  LIST(GET value_list  0 default_value)
  LIST(SORT value_list)
  set(${OPTION_NAME} ${default_value} CACHE ${TYPE} ${DESCRIPTION})
  if ("x${TYPE}" STREQUAL "xSTRING")
    set_property(CACHE ${OPTION_NAME} PROPERTY STRINGS ${value_list})
  endif()
endfunction()

add_option(CUDA_ARCH  "Compute capability code generation" STRING sm_20
  sm_10 sm_11 sm_12
  sm_20 sm_21
  sm_30 sm_32 sm_35 sm_37
  sm_50 sm_52)
add_option(HOST_BACKEND   "The host   backend to target" STRING CPP OMP TBB)
add_option(DEVICE_BACKEND "The device backend to target" STRING CUDA CPP OMP TBB)
add_option(CUDA_CDP "Enable CUDA dynamic parallelism" BOOL False)
add_option(CXX_STD "C++ standard" STRING C++03 C++11)
add_option(THRUST_MODE "Release versus debug mode" STRING RELEASE DEBUG)

if (WIN32)
  set(WINNT True)
  set(NOT_WINNT False)
else()
  set(WINNT False)
  set(NOT_WINNT True)
endif()
add_option(WARN_ALL "Enable all compilation warnings" BOOL ${NOT_WINNT})
add_option(WARN_ERROR "Treat warnings as errors" BOOL ${NOT_WINNT})

set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Build Type")



find_package(CUDA)
find_package(OpenMP)

#add_subdirectory(testing)
add_subdirectory(examples)
