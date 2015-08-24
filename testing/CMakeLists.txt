# message(STATUS "Adding \"testing\"")

FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU} ${SOURCES_CPP})

list(LENGTH SOURCES index)
message(STATUS "Found ${index} tests in testing")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
cuda_include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(backend)

#message("src= ${SOURCES}")
set(target tester)
thrust_add_executable(${target} ${SOURCES})
install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}")

