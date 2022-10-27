//
// Created by tanawin on 2/7/65.
//

#include <cassert>
#include "file_mgr.h"

namespace generator::service{


        file_mgr::file_mgr(std::string  input_prefix_path,
                           std::string  input_path,
                           std::string  input_fileName):
                prefix_path(std::move(input_prefix_path)),
                path       (std::move(input_path)       ),
                pathToFile(),
                fileName   (std::move(input_fileName)   ),
                dayta(),
                objs(),
                ctf(),
                includePaths()
        {
            std::string newFolder   = prefix_path+ SOURCE_FOLDER + path;
                        pathToFile  = newFolder + fileName;
            std::string created_directory = "mkdir -p " + newFolder;
            /// https://codeyarns.com/tech/2014-08-07-how-to-create-directory-using-c-on-linux.html
            int dir_err = system(created_directory.c_str());
            check_that(dir_err != -1, "file_mgr", "cannot create dir :" + created_directory);
        }

        void
        file_mgr::addgenObj(object::genObject* obj) {
            assert(obj != nullptr);
            objs.push_back(obj);
        }

        void
        file_mgr::genAllWriteDayta() {

            dayta = "package " + packageName + "\n";
            dayta += "import chisel3._\n";
            for (auto path : includePaths){
                dayta += "import " + path + "\n";
            }

            for(object::genObject* goPtr: objs){
                object::generatedDayta gd = goPtr->genObj(ctf);
                dayta += gd.preDt + "\n" + gd.dayta + "\n" + gd.postDt + "\n";
            }
        }

        void
        file_mgr::write() {
            desfile = new std::ofstream(pathToFile);

            // todo maybe have time scale for some block
            check_that(desfile->is_open(),
                       "file_mgr",
                       "file [" + fileName + "] is not opened!");
            (*desfile)<< dayta;

            desfile->close();
        }

        void
        file_mgr::readCodeTag() {
            oldfile = new std::ifstream (pathToFile);
            if (!oldfile->is_open()){
                return;
            }

            std::string line;
            while (getline(*oldfile, line)){

                if ((line.length() >= CODETAG_SIZE) && (line.substr(0,CODETAG_SIZE) == STARTTAG_PREFIX)) {
                    std::string start_tag = line;
                    std::string ownerCode = "";
                    std::string stop_tag  = "";

                    while(getline(*oldfile, line)){
                        if ((line.length() >= CODETAG_SIZE) && (line.substr(0,CODETAG_SIZE) == STOPTAG_PREFIX)){
                            stop_tag = line;
                            break;
                        }else{
                            ownerCode += line + '\n';
                        }
                        //todo may be unexpected ehaviour
                    }
                    if ((ownerCode.length() >= 1) && (ownerCode[ownerCode.length()-1] == '\n')){
                        ownerCode.erase(ownerCode.length()-1);
                    }
                    ctf.addCode(start_tag, stop_tag, ownerCode);
                }
            }
            oldfile->close();
        }

        std::string
        file_mgr::read() {
            // todo read entire file
            return std::string();
        }

        void
        file_mgr::addIncludePath(std::string includePath){
            includePaths.push_back(includePath);
        }

    void file_mgr::addPackageName(const std::string &pc_str) {
        packageName = pc_str;
    }
}