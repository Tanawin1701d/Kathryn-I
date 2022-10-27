//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_FILE_MGR_H
#define GENERATOR_FILE_MGR_H

#include <string>
#include <fstream>
#include <cstdlib>
#include <cassert>
#include <iostream>
#include <vector>
#include "../../object/genObject.h"
#include "codeTransfer.h"


namespace generator::service{

        static const std::string SOURCE_FOLDER     = "src/";


        class file_mgr{
        private:
            /// path
            std::ofstream* desfile;
            std::ifstream* oldfile;
            std::string prefix_path = "../../../../"; //   t/d/
            std::string path; //  src/   source not necessarily include
            std::string fileName;
            std::string pathToFile; // this is processed value
            /// all processed content
            std::string dayta;
            /// raw content
            std::vector< object::genObject* > objs;
            codeTransfer   ctf;
            /// specify data for each file
            std::vector< std::string> includePaths;
            std::string packageName;


        public:
            explicit file_mgr(std::string  input_prefix_path = "../../../../src/",
                              std::string  input_path = "", //  src/   source not necessarily include
                              std::string  input_fileName   = "defaultFile.txt");
            void addgenObj(object::genObject* obj);
            void genAllWriteDayta();
            void write();
            void readCodeTag();
            std::string read();
            void addIncludePath(std::string includePath);
            void addPackageName(const std::string& pc_str);
        };

    }
#endif //GENERATOR_FILE_MGR_H
