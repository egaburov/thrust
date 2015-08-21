cmake_minimum_required(VERSION 3.0)

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
  CXX03                " "
  CXX11                "-std=c++11"
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
  CXX03                " "
  CXX11                "-std=c++11"
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
  CXX03                " "
  CXX11                "-std=c++11"
  )
set(
  MSVC_LINKER
  DEBUG "/debug"
  RELEASE  " "
  WORKAROUND "/nologo"
  )

set(NV_LINKER_FLAGS ${GNU_LINKER_FLAGS})

# print_flags(MSVC_COMPILER_FLAGS)


find_package(CUDA)
find_package(OpenMP)
# find_package(TBB)

# Add Compute Capability list
set(ARCH_LIST  sm_10  sm_11  sm_12)
list(APPEND ARCH_LIST sm_20  sm_21)
list(APPEND ARCH_LIST sm_30  sm_32  sm_35  sm_37)
list(APPEND ARCH_LIST sm_50  sm_52)

if (CUDA_ARCH)
  LIST(FIND ARCH_LIST ${CUDA_ARCH} index)
  if (index EQUAL -1)
    MESSAGE(FATAL_ERROR "Unknown Compute Capability '${CUDA_ARCH}'")
  endif()
endif()

# Set default to sm_20
set(CUDA_ARCH sm_20 CACHE STRING "Compute capability code generation")
set_property(CACHE CUDA_ARCH PROPERTY STRINGS ${ARCH_LIST})

#message("${ARCH}")

