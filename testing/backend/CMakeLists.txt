

FILE(GLOB SOURCES_CU  *.cu)
FILE(GLOB SOURCES_CPP *.cpp)

string(TOLOWER ${DEVICE_BACKEND} backend)
#add_subdirectory(${backend})
set(SOURCES ${SOURCES} backend/${backend}/testframework.cu ${SOURCES_CU} ${SOURCES_CPP} PARENT_SCOPE)

