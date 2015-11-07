FILE(GLOB SOURCES_CU *.cu)
FILE(GLOB SOURCES_CPP *.cpp)
set(SOURCES ${SOURCES_CU} ${SOURCES_CPP})

set(local_targets "")
get_leaf(leaf_name ${CMAKE_CURRENT_SOURCE_DIR})
foreach(src ${SOURCES})
    get_filename_component(exec_name ${src} NAME_WE)
    get_filename_component(full_path ${src} PATH)
    set(target "${leaf_name}.${exec_name}")
    thrust_add_executable(test.${target} ${src})
    target_link_libraries(test.${target} test_driver)
    set_target_properties(test.${target} PROPERTIES EXCLUDA_FROM_ALL TRUE)
    add_test(NAME test.${target} COMMAND test.${target})
    add_custom_target(check.${target} COMMAND ${CMAKE_CTEST_COMMAND} -R test.${target})
    add_dependencies(check.${target} test.${target})
    list(APPEND local_targets test.${target})
endforeach()

add_custom_target(test.${leaf_name} DEPENDS ${local_targets})
add_custom_target(check.${leaf_name} COMMAND ${CMAKE_CTEST_COMMAND} -R test.${leaf_name})
add_dependencies(check.${leaf_name} test.${leaf_name})




    
