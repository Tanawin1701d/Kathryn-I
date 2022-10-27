cmake_minimum_required(VERSION 3.21)
project(generator)

set(CMAKE_CXX_STANDARD 17)



add_executable(generator
                main.cpp
                service/file/file_mgr.h
                service/file/file_mgr.cpp

        object/genObject.h
        object/genObject.cpp
        object/module/module.h
        object/module/module.cpp
        object/bundle/bundle.h
        object/bundle/bundle.cpp
        service/controller/controller.h
        service/controller/controller.cpp
 #       ${excelLIB_SRC}
        object/variable/variable.cpp
        object/variable/variable.h
        service/ioHelp/ioh.cpp
        service/ioHelp/ioh.h
        service/file/codeTransfer.cpp
        service/file/codeTransfer.h
        object/variable/nestvar.cpp
        object/variable/nestvar.h)

add_subdirectory(OpenXLSX)

include_directories(            ${PROJECT_SOURCE_DIR}/libxl-4.0.4.0/include_cpp)
target_link_libraries(generator ${PROJECT_SOURCE_DIR}/libxl-4.0.4.0/lib64/libxl.so
                                OpenXLSX::OpenXLSX
        )
