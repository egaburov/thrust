cmake_minimum_required(VERSION 3.0)

project(Thrust CXX)


#set(warn_all '-Wall')Â

# find_package(CUDA)
# find_package(OpenMP)
# find_package(TBB)


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

print_flags(MSVC_COMPILER_FLAGS)

