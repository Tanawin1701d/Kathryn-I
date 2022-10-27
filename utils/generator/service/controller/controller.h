//
// Created by tanawin on 3/7/65.
//

#ifndef GENERATOR_CONTROLLER_H
#define GENERATOR_CONTROLLER_H

#include <unordered_map>
#include <OpenXLSX.hpp>
#include "libxl.h"
#include "../../object/variable/variable.h"
#include "../../object/bundle/bundle.h"
#include "../../object/module/module.h"
#include "../../object/variable/nestvar.h"
#include "../ioHelp/ioh.h"
#include "../file/file_mgr.h"

namespace generator::service{


        class controller{
        private:
            std::string GlobalName;
            std::string prefix_path;
            std::string spec_path;
            ///variable
            std::vector<object::variable*>                     variables;
            object::nestvar*                                   nest_variable;
            std::string                                        nest_obj_name;//nest var obj name
            ///bundle
            std::unordered_map<std::string,object::bundle*>    bundles;
            ///module
            std::unordered_map<std::string,object::module*>    modules;
            ///file
            std::vector<file_mgr*>                             files;
            bool transferUserSpace = true;

            struct variable_value{
                int ROW_START       = 3;
                int COL_VAR_GROUP   = 1;
                int COL_VAR_NAME    = 2;
                int COL_VAR_TYPE    = 3;
                int COL_VAR_VALUE   = 4;
                int COL_VAR_DES     = 5;
                const std::string objName = "CORE_VAR";
            }VV;

            struct bundle_value{
                int ROW_START       = 3;
                int COL_ITF_NAME    = 1;
                int COL_PORT_DIREC  = 3;
                int COL_PORT_TP     = 4;
                int COL_PORT_NM     = 5;
                int COL_PORT_DES    = 6;
                int COL_ITF_ID_ST   = 7;
                const std::string unused = "UNUSED";
                const std::string wireType = "wire";
                const std::string port_direct_out = "output";
                const std::string port_direct_flip = "flip";
            }BV;

            struct module_value{
                int ROW_START       = 3;
                int COL_BLK_NAME    = 1;
                int COL_ITF_NAME    = 2;
                int COL_ITF_ID      = 3;
                int COL_CON_NAME    = 4;
                int COL_CON_DIREC   = 7;
                int COL_CON_DES     = 8;
            }MV;

            struct file_value{
                int ROW_START       = 3;
                int COL_OBJECT      = 1;
                int COL_TYPE        = 2;
                int COL_PATH        = 3;
                int COL_FILE_NAME   = 4;
                int COL_PACKAGE     = 5;
                int COL_INC1        = 6;
                int COL_INC2        = 7;
                const std::string bun = "bundle";
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
            void build_bundle(OpenXLSX::XLWorksheet& sheet);
            void build_modules   (OpenXLSX::XLWorksheet& sheet);
            void build_filesClass(OpenXLSX::XLWorksheet& sheet);
            void load_inside_code();
            void generate_file();
        public:
            controller(std::string input_GlobalName,
                       std::string prefix_path,
                       std::string spec_path,
                       bool trans);
            ~controller();
            bool generates();
        };
}
#endif //GENERATOR_CONTROLLER_H
