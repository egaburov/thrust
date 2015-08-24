

FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES_LOC ${SOURCES_CU} ${SOURCES_CPP})

list(LENGTH SOURCES_LOC index)
string(TOLOWER ${DEVICE_BACKEND} backend)
message(STATUS "Found ${index} tests in backend/${backend}")

set(SOURCES ${SOURCES} ${SOURCES_LOC} PARENT_SCOPE)

