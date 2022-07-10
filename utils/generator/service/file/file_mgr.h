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
            std::ofstream* desfile;
            std::ifstream* oldfile;
            std::string prefix_path = "../../../../src/"; //   t/d/
            std::string path; //  src/   source not necessarily include
            std::string pathToFile;
            std::string fileName;
            std::string dayta;
            std::vector< object::genObject* > objs;
            codeTransfer   ctf;
            std::vector< std::string> includePaths;

        public:
            file_mgr(std::string  input_prefix_path = "../../../../src/",
                     std::string  input_path = "", //  src/   source not necessarily include
                     std::string  input_fileName   = "defaultFile.txt");
            void addgenObj(object::genObject* obj);
            void genAllWriteDayta();
            void write();
            void readCodeTag();
            std::string read();
            void addIncludePath(std::string includePath);

        };

    }
#endif //GENERATOR_FILE_MGR_H
