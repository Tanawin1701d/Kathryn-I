//
// Created by tanawin on 3/7/65.
//

#ifndef GENERATOR_CONTROLLER_H
#define GENERATOR_CONTROLLER_H

#include <unordered_map>
#include <OpenXLSX.hpp>
#include "libxl.h"
#include "../../object/variable/variable.h"
#include "../../object/interface/interface.h"
#include "../../object/module/module.h"
#include "../ioHelp/ioh.h"
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
            bool transferUserSpace = true;

            struct variable_value{
                int ROW_START       = 2 + 1;
                int COL_VAR_GROUP   = 0 + 1;
                int COL_VAR_NAME    = 1 + 1;
                int COL_VAR_TYPE    = 2 + 1;
                int COL_VAR_VALUE   = 3 + 1;
                int COL_VAR_DES     = 4 + 1;
            }VV;

            struct interface_value{
                int ROW_START       = 2 + 1;
                int COL_ITF_NAME    = 0 + 1;
                int COL_PORT_DIREC  = 1 + 1;
                int COL_PORT_TP     = 2 + 1;
                int COL_PORT_NM     = 3 + 1;
                int COL_PORT_DES    = 4 + 1;
                int COL_ITF_ID_ST   = 5 + 1;
                const std::string unused = "UNUSED";
            }IV;

            struct module_value{
                int ROW_START       = 2 + 1;
                int COL_BLK_NAME    = 0 + 1;
                int COL_ITF_NAME    = 1 + 1;
                int COL_ITF_ID      = 2 + 1;
                int COL_CON_NAME    = 3 + 1;
                int COL_CON_DES     = 7 + 1;
            }MV;

            struct file_value{
                int ROW_START       = 2 + 1;
                int COL_OBJECT      = 0 + 1;
                int COL_TYPE        = 1 + 1;
                int COL_PATH        = 2 + 1;
                int COL_FILE_NAME   = 3 + 1;
                int COL_INCD_1      = 4 + 1;
                int COL_INCD_2      = 5 + 1;
                const std::string itf = "interface";
                const std::string var = "variable";
                const std::string blk = "block";

            }FV;

            struct specBook_value{
                std::string SHEETID_INTERFACE = "core_interface";
                std::string SHEETID_VARIABLE  = "core_variable";
                std::string SHEETID_MODULE    = "core_block_link";
                std::string SHEETID_INFO      = "object_info";
            }SBV;

            const std::string endOfFile = "-eof-";
            const std::string normalEnd = "-end-";

            [[maybe_unused]] bool is_variable_built;
            [[maybe_unused]] bool is_interfaces_built;
            [[maybe_unused]] bool is_modules_built;
            [[maybe_unused]] bool is_file_built;
            [[maybe_unused]] bool is_file_generated;

            void build_variables (OpenXLSX::XLWorksheet& sheet);
            void build_interfaces(OpenXLSX::XLWorksheet& sheet);
            void build_modules   (OpenXLSX::XLWorksheet& sheet);
            void build_filesClass(OpenXLSX::XLWorksheet& sheet);
            void load_inside_code();
            void generate_file();
        public:
            controller(std::string prefix_path, std::string spec_path, bool trans);
            ~controller();
            bool generates();
        };
}
#endif //GENERATOR_CONTROLLER_H
