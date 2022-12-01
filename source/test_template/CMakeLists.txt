################################################################################################################################################################
## CMakeLists.txt
##
## Zach Metcalf
################################################################################################################################################################

project(test_template)

set(HEADER_FILES
)

set(SOURCE_FILES
	test_template.cpp
)

add_executable(test_template ${SOURCE_FILES} ${HEADER_FILES})

target_link_libraries(test_template
PUBLIC
	shared::catch_ext
)
