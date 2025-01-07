cmake_minimum_required(VERSION 3.5)

project(TestUI LANGUAGES CXX)

enable_testing()

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
find_package(Qt6 6.4 REQUIRED COMPONENTS QuickControls2)
find_package(Qt6 6.4 REQUIRED COMPONENTS QuickTest)

# no need to copy around qml test files for shadow builds - just set the respective define
add_definitions(-DQUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

file(GLOB_RECURSE QML_FILES *.qml)
add_custom_target(qmlfiles SOURCES ${QML_FILES})

add_executable(TestUI main.cpp)
add_test(NAME TestUI COMMAND TestUI)

target_link_libraries(TestUI
    PRIVATE Qt6::QuickTest
)

target_link_libraries(TestUI
    PRIVATE Qt6::Quick
)

target_link_libraries(TestUI
    PRIVATE Qt6::QuickControls2
)
