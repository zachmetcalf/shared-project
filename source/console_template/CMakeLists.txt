################################################################################################################################################################
## CMakeLists.txt
##
## Zach Metcalf
################################################################################################################################################################

project(console_template)

set(HEADER_FILES
)

set(SOURCE_FILES
	console_template.cpp
)

add_executable(console_template ${SOURCE_FILES} ${HEADER_FILES})

target_link_libraries(console_template 
	shared::shared
)

##target_include_directories(console_demo
##PUBLIC
##    T:/git/shared/shared/source/
##)