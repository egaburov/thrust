
message(STATUS "Adding examples")

#aux_source_directory("testing" sources)
FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)


set(SOURCES ${SOURCES_CU})

macro(set_thrust_flags THRUST_FLAGS_)
  set(${THRUST_FLAGS_} "-DTHRUST_HOST_SYSTEM=THRUST_HOST_SYSTEM_${HOST_BACKEND}")
  LIST(APPEND ${THRUST_FLAGS_} "-DTHRUST_DEVICE_SYSTEM=THRUST_DEVICE_SYSTEM_${DEVICE_BACKEND}")

  if (THRUST_MODE STREQUAL "DEBUG")
    LIST(APPEND ${THRUST_FLAGS_} "-DTHRUST_DEBUG")
  endif()
endmacro()

macro(get_compiler_id COMPILER_ID_)
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(${COMPILER_ID_} "GNU_COMPILER")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(${COMPILER_ID_} "CLANG_COMPILER")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
    set(${COMPILER_ID_} "CLANG_COMPILER")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    set(${COMPILER_ID_} "Intel_COMPILER")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(${COMPILER_ID_} "MSCV_COMPILER")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "PGI")
    set(${COMPILER_ID_} "PGI_COMPILER")
  endif()
endmacro()

macro(find_key_value LIST_ KEY_ VALUE_)
  LIST(FIND ${LIST_} ${KEY_}  index_)
  if (index_ EQUAL -1) 
    message(FATAL_ERROR "${KEY_} is not found in ${LIST_}." )
  endif()
  math(EXPR index_ "${index_}+1")
  LIST(GET ${LIST_} ${index_} ${VALUE_})
  separate_arguments(${VALUE_})
endmacro()

macro(set_cc_compiler_flags CC_COMPILER_FLAGS_)
  get_compiler_id(CXX_)
  set(CXX_ ${CXX_}_FLAGS)

  find_key_value(${CXX_} EXCEPTION_HANDLING flags_)
  LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})

  find_key_value(${CXX_} ${HOST_BACKEND} flags_)
  LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})
  
  find_key_value(${CXX_} ${DEVICE_BACKEND} flags_)
  LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})

  if (${WARN_ALL})
    find_key_value(${CXX_} WARN_ALL flags_)
    LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})
  endif()
  
  if (${WARN_ERROR})
    find_key_value(${CXX_} WARNINGS_AS_ERRORS flags_)
    LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})
  endif()

  find_key_value(${CXX_} ${CXX_STD} flags_)
  LIST(APPEND ${CC_COMPILER_FLAGS_} ${flags_})
endmacro()

macro(set_nv_compiler_flags NV_COMPILER_FLAGS_)

  set(MACHINE_ARCH_ ${CUDA_ARCH})
  # Transform sm_XX to compute_XX
  string(REGEX REPLACE "sm" "compute"  VIRTUAL_ARCH_ ${MACHINE_ARCH_})
  # Produce -gencode flags like this: -gencode=arch=compute_XX,code=\"sm_XX,compute_XX\"
  LIST(APPEND ${NV_COMPILER_FLAGS_} "-gencode=arch=${VIRTUAL_ARCH_},\\\\\"code=${MACHINE_ARCH_},${VIRTUAL_ARCH_}\\\\\"")

  if ("${THRUST_MODE}" STREQUAL "DEBUG")
    # turn on debug mode
    # XXX make this work when we've debugged nvcc -G
#    LIST(APPEND ${NV_COMPILER_FLAGS_} "-G")    
  endif()

  if ("${DEVICE_BACKEND}" STREQUAL "CUDA")
    LIST(APPEND ${NV_COMPILER_FLAGS_} "--x=c++")
  endif()

  if (${CUDA_CDP})
    LIST(APPEND ${NV_COMPILER_FLAGS_} "-rdc=true")
  endif()

  # Untested on OSX 10.8.*
  if ("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
    if ("${CMAKE_SYSTEM_VERSION}" STREQUAL "10.8.")
      LIST(APPEND ${NV_COMPILER_FLAGS_} "-ccbin ${CMAKE_CXX_COMPILER}")
    endif()
  endif()
endmacro()

set_thrust_flags(THRUST_FLAGS)
set_cc_compiler_flags(CC_FLAGS)
set_nv_compiler_flags(NV_FLAGS)
message("THRUST_FLAGS= ${THRUST_FLAGS}")
message("CC_FLAGS= ${CC_FLAGS}")
message("NV_FLAGS= ${NV_FLAGS}")
foreach (src ${SOURCES})
  get_filename_component(target ${src} NAME_WE)
  cuda_add_executable(${target} ${src} OPTIONS "${THRUST_FLAGS}" ) 
  set_target_properties(${target} PROPERTIES LINK_FLAGS "${OpenMP_CXX_FLAGS}")
  return()
endforeach()

