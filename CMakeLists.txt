cmake_minimum_required(VERSION 3.16)

project(FirstProject VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

set_source_files_properties(ui/Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickLayouts)

qt_add_executable(appFirstProject
    main.cpp
    src/secondary.cpp
)

qt_add_qml_module(appFirstProject
    URI FirstProject
    VERSION 1.0
    QML_FILES 
        ui/Main.qml
        ui/Theme.qml
)

target_link_libraries(appFirstProject PRIVATE Qt6::Quick Qt6::QuickLayouts)