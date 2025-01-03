cmake_minimum_required(VERSION 3.16)

project(CoreTester LANGUAGES CXX)

enable_testing()

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Test)
find_package(Qt6 6.4 REQUIRED COMPONENTS Sql)

add_test(NAME CoreTester COMMAND CoreTester)

include_directories(../../)
add_executable(CoreTester testcore.cpp ../../utils.cpp ../../database.cpp)

target_link_libraries(CoreTester
    PRIVATE Qt6::Test
)

target_link_libraries(CoreTester
    PRIVATE Qt6::Sql
)
