# message(STATUS "Adding \"examples\"")

#aux_source_directory("testing" sources)
FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU})

list(LENGTH SOURCES index)
message(STATUS "Found ${index} examples")

set(target "")
foreach (src ${SOURCES})
  get_filename_component(exec_name ${src} NAME_WE)
  set(target example.${exec_name})
  thrust_add_executable(${target} ${src})
  # set_target_properties(${target} PROPERTIES EXCLUDE_FROM_ALL TRUE)
  # install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}/examples" OPTIONAL)
  # set_target_properties(${target} PROPERTIES OUTPUT_NAME ${exec_name})
  install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}" OPTIONAL)
  list(APPEND targets ${target})
endforeach()

add_custom_target(examples DEPENDS ${targets})

