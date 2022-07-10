//
// Created by tanawin on 3/7/65.
//

#include "controller.h"

#include <utility>


namespace generator::service{

        controller::controller(std::string input_prefix_path,
                               std::string spec_path,
                               bool trans):
        transferUserSpace(trans),
        is_variable_built(false),
        is_interfaces_built(false),
        is_modules_built(false),
        is_file_built(false),
        is_file_generated(false),
        prefix_path(std::move(input_prefix_path)),
        spec_path(std::move(spec_path))
        {
            std::cout << "[kathryn-I@generator] : controller for "+ this->spec_path+ " is starting up" +"\n";
        }

        controller::~controller() {
            for (auto dt: variables){
                delete dt;
            }
            for (auto dt: interfaces){
                delete dt.second;
            }
            for (auto dt: modules){
                delete dt.second;
            }
            for (auto dt: files){
                delete dt;
            }
        }

        void
        controller::build_variables(OpenXLSX::XLWorksheet& sheet) {
            int cur_row = VV.ROW_START;

            while (true){
                std::string group = sheet.cell(cur_row, VV.COL_VAR_GROUP).value();
                std::string name  = sheet.cell(cur_row, VV.COL_VAR_NAME ).value();
                std::string type  = sheet.cell(cur_row, VV.COL_VAR_TYPE ).value();
                std::string value = CellToString(sheet.cell(cur_row, VV.COL_VAR_VALUE ).value());

                std::string des   = sheet.cell(cur_row, VV.COL_VAR_DES  ).value();

                if (group == endOfFile){
                    break;
                }else if(group.empty()){
                    variables.push_back(new object::variable(type, name, value, des));
                }
                cur_row++;
            }


        }

        void
        controller::build_interfaces(OpenXLSX::XLWorksheet& sheet) {
            int cur_row = IV.ROW_START;
            bool maskAskUnused = false;
            while(true){
                std::string itf_name  = sheet.cell(cur_row, IV.COL_ITF_NAME ).value();
                std::string itf_id    = CellToString(sheet.cell(cur_row, IV.COL_ITF_ID_ST).value());

                if (itf_name == endOfFile){
                    break;
                }else if ( (!itf_name.empty()) && (!(itf_name == normalEnd)) ){
                    if ( itf_id != IV.unused) {
                        object::interface *newItf = new object::interface(itf_name, itf_id);
                        std::string finalName = newItf->getFinalIntfName();
                        interfaces.insert({finalName, newItf});
                    }
                }
                cur_row++;
            }

            cur_row = IV.ROW_START;
            std::string buf_itf_name;
            std::string buf_itf_id;
            maskAskUnused = false;

            while(true){
                std::string itf_name   = sheet.cell(cur_row, IV.COL_ITF_NAME).value();
                std::string itf_id     = CellToString(sheet.cell(cur_row, IV.COL_ITF_ID_ST).value());
                std::string portDirect = sheet.cell(cur_row, IV.COL_PORT_DIREC).value();
                std::string portType   = sheet.cell(cur_row, IV.COL_PORT_TP).value();
                std::string portName   = sheet.cell(cur_row, IV.COL_PORT_NM).value();
                std::string portDes    = sheet.cell(cur_row, IV.COL_PORT_DES).value();
                std::string portsize   = CellToString(sheet.cell(cur_row, IV.COL_ITF_ID_ST).value());

                if (itf_name == endOfFile){
                    break;
                }else if ( (!itf_name.empty()) && (!(itf_name == normalEnd)) ){ //in case interface name
                    buf_itf_name = itf_name;
                    buf_itf_id   = itf_id  ;
                    maskAskUnused= false;
                    if (buf_itf_id == IV.unused){
                        maskAskUnused = true;
                    }
                }else if (itf_name.empty() && (!maskAskUnused)){ //incase this this is port section or interface section
                    if (portType == "logic"){
                        interfaces[object::interface::getFinalIntfName(buf_itf_name,buf_itf_id)]
                        ->addPort(new object::port( object::PORT_TYPE::logic,
                                                       portName,
                                                           portDes,
                                                             portsize
                                                       )
                                 );
                    }else if (portType != "logic"){
                        // sanity check whether there are inherit interface

                        check_that(interfaces.find(object::interface::getFinalIntfName(portType, itf_id)) !=
                                   interfaces.end(),
                                   "interfaceRetriver",
                                   object::interface::getFinalIntfName(portType, itf_id) + "wasn't built"
                        );

                        interfaces[object::interface::getFinalIntfName(buf_itf_name,buf_itf_id)]
                        ->addPort(new object::port(object::PORT_TYPE::inherit,
                                                    interfaces[object::interface::getFinalIntfName(portType,itf_id)],
                                                       portName,
                                                           portDes
                                                       )
                                 );
                    }
                }
                cur_row++;

            }

        }

        void
        controller::build_modules(OpenXLSX::XLWorksheet& sheet) {
            int cur_row = MV.ROW_START;
            std::string buf_blkName;

            while (true){
                std::string blkName     = sheet.cell(cur_row, MV.COL_BLK_NAME).value();
                std::string itf_name    = sheet.cell(cur_row, MV.COL_ITF_NAME).value();
                std::string itf_id      = sheet.cell(cur_row, MV.COL_ITF_ID  ).value();
                std::string con_name    = sheet.cell(cur_row, MV.COL_CON_NAME).value();
                std::string con_des     = sheet.cell(cur_row, MV.COL_CON_DES ).value();


                if (blkName == endOfFile){
                    break;
                }else if ( ((!blkName.empty()) &&  (blkName != normalEnd)) || blkName.empty() ){
                    if ( (!blkName.empty()) &&  (blkName != normalEnd) ){
                        buf_blkName = blkName;
                        modules.insert({buf_blkName, new object::module(blkName)});
                    }
                    modules[buf_blkName]->addLocalInterface(con_name,
                                                            interfaces[object::interface::getFinalIntfName(itf_name,itf_id)],
                                                            con_des
                                                            );
                    // todo build other side to make main core link together
                }
                cur_row++;
            }
        }

        void
        controller::build_filesClass(OpenXLSX::XLWorksheet& sheet) {
            // todo this version assume one file per module and us unified interface and variable
            int cur_row = FV.ROW_START;
            while(true){
                std::string objectName  = sheet.cell(cur_row, FV.COL_OBJECT)   .value();
                std::string objectType  = sheet.cell(cur_row, FV.COL_TYPE)     .value();
                std::string objectPath  = sheet.cell(cur_row, FV.COL_PATH)     .value();
                std::string objectFname = sheet.cell(cur_row, FV.COL_FILE_NAME).value();
                std::string incPath     = CellToString(sheet.cell(cur_row, FV.COL_INCD_1).value());
                std::string incPath2    = CellToString(sheet.cell(cur_row, FV.COL_INCD_2).value());
                if ( objectName == endOfFile ){
                    break;
                }

                file_mgr* newFile = new file_mgr(prefix_path,
                                                      objectPath,
                                                   objectFname);

                if (!incPath.empty())  newFile->addIncludePath(incPath );
                if (!incPath2.empty()) newFile->addIncludePath(incPath2);

                if ( objectType == FV.itf ){
                    for (auto & interface : interfaces){
                        newFile->addgenObj(interface.second);
                    }
                }else if ( objectType == FV.var ){
                    for (auto & varia : variables){
                        newFile->addgenObj(varia);
                    }

                }else if ( objectType == FV.blk ){
                    //sanity check in case block not found
                    assert(modules.find(objectName) != modules.end());
                    newFile->addgenObj(modules[objectName]);
                }
                files.push_back(newFile);
                cur_row++;
            }

        }

        void
        controller::generate_file() {
            for (auto file: files){
                file->genAllWriteDayta();
                file->write();
            }
        }

        void
        controller::load_inside_code() {
            for (auto file : files){
                file->readCodeTag();
            }
        }

        bool
        controller::generates() {
            using namespace OpenXLSX;
            XLDocument specBook;
            // sanity check
            // sanity check do not delete this file
            std::string loadPath = prefix_path + spec_path;
            specBook.open(loadPath);
            //
            std::cout << "[kathryn-I@generator] : worksheets loading ...\n";

            auto interfaceSheet = specBook.workbook().worksheet(SBV.SHEETID_INTERFACE);
            auto variableSheet  = specBook.workbook().worksheet(SBV.SHEETID_VARIABLE );
            auto moduleSheet    = specBook.workbook().worksheet(SBV.SHEETID_MODULE   );
            auto objInfoSheet   = specBook.workbook().worksheet(SBV.SHEETID_INFO     );
            std::cout << "[kathryn-I@generator] : worksheets loaded\n";
//            assert( interfaceSheet != nullptr );
//            assert( variableSheet  != nullptr );
//            assert( moduleSheet    != nullptr );
//            assert( objInfoSheet   != nullptr );
            std::cout << "[kathryn-I@generator] : start retrieve interfaces ...\n";
            build_interfaces(interfaceSheet);
            std::cout << "[kathryn-I@generator] : start retrieve variable ....\n";
            build_variables (variableSheet );
            std::cout << "[kathryn-I@generator] : start retrieve modules ... \n";
            build_modules   (moduleSheet   );
            std::cout << "[kathryn-I@generator] : start building/Analyzing system verilog file ...\n";
            build_filesClass(objInfoSheet  );
            if (transferUserSpace) {
                std::cout << "[kathryn-I@generator] : start Analyzing old system verilog file ...\n";
                load_inside_code();
            }
            std::cout << "[kathryn-I@generator] : start generate system verilog file ...\n";
            generate_file();
            std::cout << "[kathryn-I@generator] : controller for "+ spec_path+ " is finish generation" +"\n";
            return true;
        }

}