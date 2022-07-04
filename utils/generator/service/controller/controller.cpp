//
// Created by tanawin on 3/7/65.
//

#include "controller.h"

#include <utility>


namespace generator{
    namespace service{

        controller::controller(std::string input_prefix_path,
                               std::string spec_path):
        is_variable_built(false),
        is_interfaces_built(false),
        is_modules_built(false),
        is_file_built(false),
        is_file_generated(false),
        prefix_path(std::move(input_prefix_path)),
        spec_path(std::move(spec_path))
        {
            std::cout << "[kathryn-I@generator] : main controller is established\n";
        }

        void controller::build_variables(libxl::Sheet *sheet) {
            int cur_row = VV.ROW_START;

            while (true){
                std::string group = sheet->readStr(cur_row, VV.COL_VAR_GROUP);
                std::string name  = sheet->readStr(cur_row, VV.COL_VAR_NAME);
                std::string type  = sheet->readStr(cur_row, VV.COL_VAR_TYPE);
                std::string value = sheet->readStr(cur_row, VV.COL_VAR_VALUE);
                std::string des   = sheet->readStr(cur_row, VV.COL_VAR_DES);

                if (group == endOfFile){
                    break;
                }else if( (group == normalEnd) || (!group.empty())){ // case group and end of group
                    //pass
                }else{
                    variables.push_back(new object::variable(type, name, value, des));
                }
            }

        }

        void controller::build_interfaces(libxl::Sheet* sheet) {
            int cur_row = IV.ROW_START;
            while(true){
                std::string itf_name = sheet->readStr(cur_row, IV.COL_ITF_NAME);
                std::string itf_id   = sheet->readStr(cur_row, IV.COL_ITF_ID_ST);

                if (itf_name == endOfFile){
                    break;
                }else if ( (!itf_name.empty()) && (!(itf_name == normalEnd)) ){
                    object::interface* newItf = new object::interface(itf_name, itf_id);
                    std::string finalName = newItf->getFinalIntfName();
                    interfaces.insert({finalName, newItf});

                }
                cur_row++;
            }

            cur_row = IV.ROW_START;
            while(true){
                std::string itf_name   = sheet->readStr(cur_row, IV.COL_ITF_NAME);
                std::string itf_id     = sheet->readStr(cur_row, IV.COL_ITF_ID_ST);
                std::string portDirect = sheet->readStr(cur_row, IV.COL_PORT_DIREC);
                std::string portType   = sheet->readStr(cur_row, IV.COL_PORT_TP);
                std::string portName   = sheet->readStr(cur_row, IV.COL_PORT_NM);
                std::string portDes    = sheet->readStr(cur_row, IV.COL_PORT_DES);
                std::string portsize   = sheet->readStr(cur_row, IV.COL_ITF_ID_ST);

                std::string buf_itf_name;
                std::string buf_itf_id;

                if (itf_name == endOfFile){
                    break;
                }else if ( (!itf_name.empty()) && (!(itf_name == normalEnd)) ){ //in case interface name
                    buf_itf_name = itf_name;
                    buf_itf_id   = itf_id  ;
                }else if ( (itf_name.empty() )  ){ //incase this this is port section or interface section
                    if (portType == "logic"){
                        interfaces[object::interface::getFinalIntfName(buf_itf_name,buf_itf_id)]
                        ->addPort(new object::port( object::PORT_TYPE::logic,
                                                       portName,
                                                           portDes,
                                                             portsize
                                                       )
                                 );
                    }else if (portType != "logic"){
                        interfaces[object::interface::getFinalIntfName(buf_itf_name,buf_itf_id)]
                        ->addPort(new object::port(object::PORT_TYPE::logic,
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

        void controller::build_modules(libxl::Sheet* sheet) {
            int cur_row = MV.ROW_START;
            while (true){
                std::string blkName     = sheet->readStr(cur_row, MV.COL_BLK_NAME);
                std::string itf_name    = sheet->readStr(cur_row, MV.COL_ITF_NAME);
                std::string itf_id      = sheet->readStr(cur_row, MV.COL_ITF_ID);
                std::string con_name    = sheet->readStr(cur_row, MV.COL_CON_NAME);
                std::string con_des     = sheet->readStr(cur_row, MV.COL_CON_DES);

                std::string buf_blkName;

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
                }
                cur_row++;
            }
        }

        void controller::build_filesClass(libxl::Sheet* sheet) {
            // todo this version assume one file per module and us unified interface and variable
            int cur_row = FV.ROW_START;
            while(true){
                std::string objectName  = sheet->readStr(cur_row, FV.COL_OBJECT);
                std::string objectType  = sheet->readStr(cur_row, FV.COL_TYPE);
                std::string objectPath  = sheet->readStr(cur_row, FV.COL_PATH);
                std::string objectFname = sheet->readStr(cur_row, FV.COL_FILE_NAME);
                if ( objectName == endOfFile ){
                    break;
                }

                file_mgr* newFile = new file_mgr(prefix_path,
                                                      objectPath,
                                                   objectFname);

                if ( objectType == FV.itf ){
                    for (auto & interface : interfaces){
                        newFile->addgenObj(interface.second);
                    }

                }else if ( objectType == FV.var ){
                    //todo build variable object

                }else if ( objectType == FV.blk ){
                    //sanity check in case block not found
                    assert(modules.find(objectName) != modules.end());
                    newFile->addgenObj(modules[objectName]);
                }
                files.push_back(newFile);
                cur_row++;
            }

        }

        void controller::generate_file() {
            for (auto file: files){
                file->genAllWriteDayta();
                file->write();
            }
        }

        bool controller::generates() {
            libxl::Book* specBook = xlCreateBook();
            // sanity check
            assert(specBook != nullptr);
            // sanity check do not delete this file
            bool isBookLoaded = specBook->load(spec_path.c_str());
            assert( isBookLoaded );
            //
            libxl::Sheet* interfaceSheet = specBook->getSheet(SBV.SHEETID_INTERFACE);
            libxl::Sheet* variableSheet = specBook->getSheet (SBV.SHEETID_VARIABLE );
            libxl::Sheet* moduleSheet = specBook->getSheet   (SBV.SHEETID_MODULE   );
            libxl::Sheet* objInfoSheet = specBook->getSheet  (SBV.SHEETID_INFO     );
            assert( interfaceSheet != nullptr );
            assert( variableSheet  != nullptr );
            assert( moduleSheet    != nullptr );
            assert( objInfoSheet   != nullptr );
            build_interfaces(interfaceSheet);
            build_variables (variableSheet );
            build_modules   (moduleSheet   );
            build_filesClass(objInfoSheet  );
            generate_file();


            return true;
        }




    }
}