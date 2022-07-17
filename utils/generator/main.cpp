#include <iostream>
#include <fstream>
#include <cassert>
#include "service/file/file_mgr.h"
#include "object/genObject.h"
#include "service/controller/controller.h"

std::string prefix_path = "/home/tanawin/Work/vivado/Kathryn/"; // path to home project folder

std::pair<std::string, std::vector<std::string>> retriveConfigPath(){
    std::ifstream file("../config.txt");
    generator::service::check_that(file.is_open(), "main", "can't read config");
    std::vector<std::string> specPaths;
    std::string line;
    std::string prefixPath;
    getline(file,prefixPath);


    while(getline(file,line)){
        specPaths.push_back(line);
    }

    generator::service::check_that(specPaths.size() >= 1, "main", "no spec path");

    return {prefixPath, specPaths};
}

void genUserTran(bool tranf){
    std::cout << "[main@generator] start retrieve configs ...\n";
    auto config =  retriveConfigPath();
    for (auto spec_path : config.second) {
        generator::service::controller ctrl(prefix_path, spec_path, tranf);
        ctrl.generates();
    }
}

void genAllUnCache(){
    while (true) {
        std::cout << "[main@generator] Are you sure to remove all user code (N/y) : ";
        char cmd = ' ';
        std::cin >> cmd;
        if (cmd == 'N') {
            genUserTran(true);
            return ;
        } else if (cmd == 'y') {
            genUserTran(false);
            return;
        }
    }
};

void help(){
    std::cout << "This tool was buit to help Kathryn-I developer feel easier to build systemverilog code\n"
              << "1.the excel (.ods file) wil give fundamental of main block of kathryn architecture\n"
              << "2.the path to make generator running is in config file in same folder to main.cpp file\n"
              << "3.first line of config is absolute path to home folder (main github kathryn folder)\n"
              << "4.another lines of config is relative path(related to 3.) to the excel's path\n"
              << "5.Due to OpenXLSX is not support .ods file, you must first export to .xlsx file with no formula(plain text excel)\n";

}

int main(int c, char* argv[]) {

    //first argument is path to project directory

    std::cout << "----------KATHRYN-I rtl file generator(system verilog)----------\n";
    std::cout << "This tool is designed for KATHRYN-I project (2021-2022)\n";
    std::string menu = "please select these below options\n"
                       "[1] generate entire system(transfer user code)\n"
                       "[2] generate entire system(clear user code)\n"
                       "[3] help\n"
                       "[4] exit\n"
                       ;
    std::cout << menu;
    std::cout << "[main@generator] please enter menu number to execute next command : ";
    int selected_menu = 4;
    std::cin  >>  selected_menu;
    switch( selected_menu ){
        case 1 :{genUserTran(true);break;}
        case 2 :{genAllUnCache()   ;break;}
        case 3 :{help()          ;break;}
        default:exit(0);
    }

    return 0;
}