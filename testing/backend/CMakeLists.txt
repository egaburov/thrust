
FILE(GLOB SOURCES_LOC_CU  *.cu)
FILE(GLOB SOURCES_LOC_CPP *.cpp)

string(TOLOWER ${DEVICE_BACKEND} backend)
FILE(GLOB_RECURSE SOURCES_backend_CU ${backend}/*.cu)
FILE(GLOB_RECURSE SOURCES_backend_CPP ${backend}/*.cpp)

set(SOURCES_LOC ${SOURCES_LOC_CU} ${SOURCES_LOC_CPP})
set(SOURCES_backend ${SOURCES_backend_CU} ${SOURCES_backend_CPP})

list(LENGTH SOURCES_LOC size_LOC)
list(LENGTH SOURCES_backend size_backend)
math(EXPR size "${size_LOC} + ${size_backend}")
message(STATUS "Found ${size} tests in backend")

set(SOURCES ${SOURCES} ${SOURCES_LOC} ${SOURCES_backend} PARENT_SCOPE)



