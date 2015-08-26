set(DRIVER "${CMAKE_CURRENT_SOURCE_DIR}/testframework.cpp")

FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU} ${SOURCES_CPP})

list(FIND SOURCES ${DRIVER} index)
if (${index} EQUAL -1)
  MESSAGE(FATAL_ERROR "${DRIVER} was not found in source list. Something went wrong")
endif()

list(REMOVE_AT SOURCES ${index} SOURCES)

set(SOURCES pair.cu)

list(LENGTH SOURCES index)
message(STATUS "Found ${index} tests in testing")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
cuda_include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(backend)


set(targets "")
foreach(src ${SOURCES})
  get_filename_component(exec_name ${src} NAME_WE)
  set(target test.${exec_name})
  set(src_files ${src} ${DRIVER})
  thrust_add_executable(${target} ${src_files})
  #  install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}" OPTIONAL)
  add_test(NAME ${exec_name} COMMAND ${target})
  list(APPEND targets ${target})
endforeach()

add_custom_target(tests DEPENDS ${targets})
