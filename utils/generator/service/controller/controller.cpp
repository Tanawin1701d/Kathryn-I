//
// Created by tanawin on 3/7/65.
//

#include "controller.h"

#include <utility>


namespace generator::service{

        controller::controller(std::string input_GlobalName,
                               std::string input_prefix_path,
                               std::string spec_path,
                               bool trans):
        GlobalName(input_GlobalName),
        transferUserSpace(trans),
        is_variable_built(false),
        is_interfaces_built(false),
        is_modules_built(false),
        is_file_built(false),
        is_file_generated(false),
        prefix_path(std::move(input_prefix_path)),
        spec_path(std::move(spec_path))
        {
            nest_obj_name = GlobalName + "_var";
            std::cout << "[kathryn-I@generator] : controller for "+ this->spec_path + " is starting up" +"\n";
        }

        controller::~controller() {
            for (auto dt: variables){
                delete dt;
            }
            for (const auto& dt: bundles){
                delete dt.second;
            }
            for (const auto& dt: modules){
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
                    //TODO for now we support only scala int type
                    variables.push_back(new object::variable(object::VARTYP::UINT, name, value, des));
                } // else case -end-
                cur_row++;
            }
            // for now we use Global name as a var object
            nest_variable = new object::nestvar(nest_obj_name);
        }

        void
        controller::build_bundle(OpenXLSX::XLWorksheet& sheet) {
            int cur_row = BV.ROW_START;
            bool maskAskUnused = false;
            while(true){
                std::string bundle_name  = sheet.cell(cur_row, BV.COL_ITF_NAME ).value();
                std::string bundle_id    = CellToString(sheet.cell(cur_row, BV.COL_ITF_ID_ST).value());

                if (bundle_name == endOfFile){
                    break;
                }else if ( (!bundle_name.empty()) && (!(bundle_name == normalEnd)) ){
                    if ( bundle_id != BV.unused) {
                        object::bundle *newBundle = new object::bundle(bundle_name, bundle_id);
                        std::string finalName = newBundle->getFinalBundleName();
                        bundles.insert({finalName, newBundle});
                    }
                }
                cur_row++;
            }

            cur_row = BV.ROW_START;
            std::string  buf_bundle_name;
            std::string  buf_bundle_id;
            object::bundle* buf_bundle;
            maskAskUnused = false;

            while(true){
                std::string bundle_name   = sheet.cell(cur_row, BV.COL_ITF_NAME).value();
                std::string bundle_id     = CellToString(sheet.cell(cur_row, BV.COL_ITF_ID_ST).value());
                std::string portDirect    = sheet.cell(cur_row, BV.COL_PORT_DIREC).value();
                std::string portType      = sheet.cell(cur_row, BV.COL_PORT_TP).value();
                std::string portName      = sheet.cell(cur_row, BV.COL_PORT_NM).value();
                std::string portDes       = CellToString(sheet.cell(cur_row, BV.COL_PORT_DES).value());
                std::string portsize      = CellToString(sheet.cell(cur_row, BV.COL_ITF_ID_ST).value());

                if (bundle_name == endOfFile){
                    break;
                }else if ( (!bundle_name.empty()) && (!(bundle_name == normalEnd)) ){ //in case interface name
                    ///mark for header
                    buf_bundle_name = bundle_name;
                    buf_bundle_id   = bundle_id  ;

                    ///case unused
                    if (buf_bundle_id == BV.unused){
                        maskAskUnused = true;
                    }else{
                        /// get bundle for port inserting
                        std::string final_bd = object::bundle::getFinalBundleName(buf_bundle_name, buf_bundle_id);
                        assert( bundles.find(final_bd) != bundles.end());
                        buf_bundle = bundles[final_bd];
                        maskAskUnused= false;
                    }

                }else if (bundle_name.empty() && (!maskAskUnused)){ //incase this this is port section or interface section
                    ///case there is normal port and the bundle is usesd
                    object::port* pt;
                    if ( portType == BV.wireType ){
                         pt = new object::port(
                                portDirect == BV.port_direct_out ?
                                object::PORT_TYPE::OUTPUT:
                                object::PORT_TYPE::INPUT,
                                portDes,
                                portsize, // aka port_size due to same field
                                nest_obj_name,
                                service::isInt(portsize) ?
                                object::PORT_SIZE_TYP::VALUE:
                                object::PORT_SIZE_TYP::DEFAULT_VAR
                                );
                    }else{
                        std::string refer_bd_n = object::bundle::getFinalBundleName(portType, bundle_id);// aka port_size due to same field
                        assert(bundles.find(refer_bd_n) != bundles.end());
                        pt = new object::port(
                                portDirect == BV.port_direct_flip ?
                                object::PORT_TYPE::FLIPPED_BUNDLE :
                                object::PORT_TYPE::BUNDLE,
                                bundles[refer_bd_n],
                                portDes
                        );
                    }
                    buf_bundle->addPort(portName, pt);
                } /// case there is unused sections, header section or end of module section
                cur_row++;

            }
        }

        void
        controller::build_modules(OpenXLSX::XLWorksheet& sheet) {
            int cur_row = MV.ROW_START;
            std::string buf_blkName;
            object::module* buf_module;

            while (true){
                std::string blkName     = sheet.cell(cur_row, MV.COL_BLK_NAME).value();
                std::string bundle_name = sheet.cell(cur_row, MV.COL_ITF_NAME).value();
                std::string bundle_id   = sheet.cell(cur_row, MV.COL_ITF_ID  ).value();
                std::string con_direc   = sheet.cell(cur_row, MV.COL_CON_DIREC).value();
                std::string con_name    = sheet.cell(cur_row, MV.COL_CON_NAME).value();
                std::string con_des     = sheet.cell(cur_row, MV.COL_CON_DES ).value();


                if (blkName == endOfFile){
                    break;
                }else if ( ((!blkName.empty()) &&  (blkName != normalEnd)) || blkName.empty() ){
                    ///    ^------------ case that is block name              ^--------case this is one of bundle list
                    if ( (!blkName.empty()) &&  (blkName != normalEnd) ){
                        buf_blkName = blkName;
                        buf_module = new object::module(blkName);
                        modules.insert({buf_blkName, buf_module});
                    }
                    std::string con_bundle_name = object::bundle::getFinalBundleName(bundle_name, bundle_id);
                    assert(bundles.find(con_bundle_name) != bundles.end());
                    assert(con_direc == "yes" || con_direc == "no");
                    bool isflip = con_direc == "yes";
                    /// insert bundle to sub
                    buf_module->addBundle(con_name, bundles[con_bundle_name], isflip, con_des);
                }
                cur_row++;
            }
        }

        void
        controller::build_filesClass(OpenXLSX::XLWorksheet& sheet) {
            // todo this version assume one file per module and us unified interface and variable
            int cur_row = FV.ROW_START;
            while(true){
                std::string objectName    = sheet.cell(cur_row, FV.COL_OBJECT)   .value();
                std::string objectType    = sheet.cell(cur_row, FV.COL_TYPE)     .value();
                std::string objectPath    = sheet.cell(cur_row, FV.COL_PATH)     .value();
                std::string objectFname   = sheet.cell(cur_row, FV.COL_FILE_NAME).value();
                std::string objectPackage = CellToString(sheet.cell(cur_row, FV.COL_PACKAGE).value());
                std::string incPath1      = CellToString(sheet.cell(cur_row, FV.COL_INC1).value());
                std::string incPath2      = CellToString(sheet.cell(cur_row, FV.COL_INC2).value());
                if ( objectName == endOfFile ){
                    break;
                }

                file_mgr* newFile = new file_mgr(prefix_path, // path to prject directory
                                                      objectPath, // path to file's folder
                                                   objectFname); // file name

                if (!incPath1.empty())  newFile->addIncludePath(incPath1 );
                if (!incPath2.empty()) newFile->addIncludePath(incPath2);

                if ( objectType == FV.bun ){
                    for (auto & bd : bundles){
                        newFile->addgenObj(bd.second);
                    }
                }
                else if ( objectType == FV.var ){
                    for (auto & varia : variables){
                        newFile->addgenObj(varia);
                    }
                }
                else if ( objectType == FV.blk ){
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
            build_bundle(interfaceSheet);
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