message(STATUS "Adding \"testing\"")

#aux_source_directory("testing" sources)
FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU} ${SOURCES_CPP})


set(CMAKE_INCLUDE_CURRENT_DIR ON)
cuda_include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
set(SOURCES distance.cu advance.cu vector_cpp_subset.cpp)
set(SOURCES testframework.cpp ${SOURCES})

add_subdirectory(backend)

message("src= ${SOURCES}")
set(target tester)
cuda_add_executable(${target} ${SOURCES})
install(TARGETS ${target} DESTINATION "${HOST_BACKEND}_host_${DEVICE_BACKEND}_device_${THRUST_MODE}")

