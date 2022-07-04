//
// Created by tanawin on 2/7/65.
//

#include "file_mgr.h"

namespace generator{
    namespace service{


        file_mgr::file_mgr(std::string  input_prefix_path,
                           std::string  input_path,
                           std::string  input_fileName):
                prefix_path(std::move(input_prefix_path)),
                path       (std::move(input_path)       ),
                fileName   (std::move(input_fileName)   ),
                dayta(),
                objs()
        {

            std::string created_directory = "mkdir -p " + prefix_path + path;
            /// https://codeyarns.com/tech/2014-08-07-how-to-create-directory-using-c-on-linux.html
            const int dir_err = system(created_directory.c_str());
            if (-1 == dir_err){
                std::cout << "[file_mgr] cannot recursivly create director" <<\
                created_directory <<"\n";
                exit(1);
            }
            desfile = new std::ofstream(prefix_path+path+fileName);
        }

        void file_mgr::addgenObj(object::genObject* obj) {
            objs.push_back(obj);
        }

        void file_mgr::genAllWriteDayta() {
            for(object::genObject* goPtr: objs){
                object::generatedDayta gd = goPtr->genObj();
                dayta += gd.preDt + "\n" + gd.dayta + "\n" + gd.postDt;
            }
        }

        void file_mgr::write() {
            // todo maybe have time scale for some block
            (*desfile)<< dayta;
        }

        std::string file_mgr::read() {
            // todo
            return std::string();
        }




    }
}