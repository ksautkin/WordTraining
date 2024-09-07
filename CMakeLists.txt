cmake_minimum_required(VERSION 3.16)

project(WordTraining LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
find_package(Qt6 6.4 REQUIRED COMPONENTS QuickControls2)
find_package(Qt6 6.4 REQUIRED COMPONENTS Widgets)
find_package(Qt6 6.4 REQUIRED COMPONENTS Sql)

qt_standard_project_setup()

qt_add_executable(WordTraining
    main.cpp
)

qt_add_qml_module(WordTraining
    URI WordTraining
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES Items/LetterItem.qml
    QML_FILES Items/TextAreaItem.qml
    QML_FILES Items/ButtonItem.qml
    QML_FILES Items/TextFieldItem.qml
    QML_FILES Pages/WordEditorPage.qml
    QML_FILES Pages/GuessWordPage.qml
    QML_FILES Pages/ListWordsPage.qml
    SOURCES database.h database.cpp
    SOURCES listmodel.h listmodel.cpp
    SOURCES utils.h utils.cpp
    QML_FILES Items/CheckBoxItem.qml
    QML_FILES Pages/SettingsPage.qml
    SOURCES settingsmanager.h settingsmanager.cpp
    QML_FILES
    QML_FILES Items/LetterStatisticsItem.qml
    QML_FILES Pages/StatisticsWordPage.qml
)

set_property(TARGET WordTraining APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

set_property(TARGET WordTraining PROPERTY
    QT_ANDROID_VERSION_NAME "1.0.1"
)

set_property(TARGET WordTraining PROPERTY
    QT_ANDROID_VERSION_CODE 2
)

set_target_properties(WordTraining PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(WordTraining
    PRIVATE Qt6::Quick
)

target_link_libraries(WordTraining
    PRIVATE Qt6::QuickControls2
)

target_link_libraries(WordTraining
    PRIVATE Qt6::Widgets
)

target_link_libraries(WordTraining
    PRIVATE Qt6::Sql
)
