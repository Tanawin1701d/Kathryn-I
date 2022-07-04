//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_FILE_MGR_H
#define GENERATOR_FILE_MGR_H

#include <string>
#include <fstream>
#include <cstdlib>
#include <iostream>
#include <vector>
#include "../../object/genObject.h"


namespace generator{
    namespace service{


        class file_mgr{
        private:
            std::ofstream* desfile;
            std::string prefix_path = "../../../../src/"; //   t/d/
            std::string path; //  src/   source not necessarily include
            std::string fileName;
            std::string dayta;
            std::vector< object::genObject* > objs;

        public:
            file_mgr(std::string  input_prefix_path = "../../../../src/",
                     std::string  input_path = "", //  src/   source not necessarily include
                     std::string  input_fileName   = "defaultFile.txt");
            void addgenObj(object::genObject* obj);
            void genAllWriteDayta();
            void write();
            std::string read();

        };

    }
}
#endif //GENERATOR_FILE_MGR_H
