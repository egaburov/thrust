cmake_minimum_required(VERSION 3.0)

project(Thrust CXX)


#set(warn_all '-Wall')Â

# find_package(CUDA)
# find_package(OpenMP)
# find_package(TBB)


macro(define_compiler_flags PREFIX)
  set(__arg_name )
  set(__is_name True)
  foreach(arg ${ARGN})
    if (__is_name)
      set(__arg_name ${arg})
      set(__is_name False)
    else()
      separate_arguments(arg)
      set(${PREFIX}_${__arg_name} ${arg})
      #      message("${PREFIX}_${__arg_name} '${arg}'")
      set(__is_name True)
    endif()
  endforeach()
endmacro()

define_compiler_flags(
  GNU_COMPILER
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

define_compiler_flags(
  CLANG_COMPILER
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

define_compiler_flags(
  MSVC_COMPILER
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


macro(countargs)
  message (${ARGC})
endmacro()
message("'${GNU_COMPILER_CXX03}'")
message("'${GNU_COMPILER_CXX11}'")
countargs(${GNU_COMPILER_CXX11})
#
