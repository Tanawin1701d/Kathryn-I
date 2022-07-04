//
// Created by tanawin on 3/7/65.
//

#ifndef GENERATOR_CONTROLLER_H
#define GENERATOR_CONTROLLER_H

#include <unordered_map>
#include "libxl.h"
#include "../../object/variable/variable.h"
#include "../../object/interface/interface.h"
#include "../../object/module/module.h"
#include "../file/file_mgr.h"

namespace generator::service{


        class controller{
        private:
            std::string prefix_path;
            std::string spec_path;
            std::vector<object::variable*> variables;
            std::unordered_map<std::string,object::interface*> interfaces;
            std::unordered_map<std::string,object::module*>    modules;
            std::vector<file_mgr*>                             files;

            struct variable_value{
                int ROW_START       = 2;
                int COL_VAR_GROUP   = 0;
                int COL_VAR_NAME    = 1;
                int COL_VAR_TYPE    = 2;
                int COL_VAR_VALUE   = 3;
                int COL_VAR_DES     = 4;
            }VV;

            struct interface_value{
                int ROW_START       = 2;
                int COL_ITF_NAME   = 0;
                int COL_PORT_DIREC  = 1;
                int COL_PORT_TP     = 2;
                int COL_PORT_NM     = 3;
                int COL_PORT_DES    = 4;
                int COL_ITF_ID_ST   = 5;
                [[maybe_unused]]const std::string unused = "UNUSED";
            }IV;

            struct module_value{
                int ROW_START       = 2;
                int COL_BLK_NAME    = 0;
                int COL_ITF_NAME    = 1;
                int COL_ITF_ID      = 2;
                int COL_CON_NAME    = 3;
                int COL_CON_DES     = 7;
            }MV;

            struct file_value{
                int ROW_START       = 2;
                int COL_OBJECT      = 0;
                int COL_TYPE        = 1;
                int COL_PATH        = 2;
                int COL_FILE_NAME   = 3;
                const std::string itf = "interface";
                const std::string var = "variable";
                const std::string blk = "block";

            }FV;

            struct specBook_value{
                int SHEETID_INTERFACE = 0;
                int SHEETID_VARIABLE  = 1;
                int SHEETID_MODULE    = 2;
                int SHEETID_INFO      = 3;
            }SBV;

            const std::string endOfFile = "-eof-";
            const std::string normalEnd = "-end-";

            [[maybe_unused]] bool is_variable_built;
            [[maybe_unused]] bool is_interfaces_built;
            [[maybe_unused]] bool is_modules_built;
            [[maybe_unused]] bool is_file_built;
            [[maybe_unused]] bool is_file_generated;
            // todo
            void build_variables(libxl::Sheet* sheet);
            void build_interfaces(libxl::Sheet* sheet);
            void build_modules(libxl::Sheet* sheet);
            void build_filesClass(libxl::Sheet* sheet);
            void generate_file();
        public:
            controller(std::string prefix_path, std::string spec_path);
            bool generates();
        };
}
#endif //GENERATOR_CONTROLLER_H
