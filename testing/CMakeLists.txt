message(STATUS "Adding \"testing\"")

#aux_source_directory("testing" sources)
FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU} ${SOURCES_CPP})


cuda_include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
set(SOURCES distance.cu advance.cu)
set(SOURCES testframework.cpp ${SOURCES})
set(SOURCES backend/cuda/testframework.cu ${SOURCES})

set(target tester)
cuda_add_executable(${target} ${SOURCES})
install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}")

