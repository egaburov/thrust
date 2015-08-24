# message(STATUS "Adding \"examples\"")

#aux_source_directory("testing" sources)
FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU})

list(LENGTH SOURCES index)
message(STATUS "Found ${index} examples")

foreach (src ${SOURCES})
  get_filename_component(target ${src} NAME_WE)
  set(target ${target})
  cuda_add_executable(${target} ${src})
  install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}/examples")
endforeach()

