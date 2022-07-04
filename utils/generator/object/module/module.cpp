//
// Created by tanawin on 2/7/65.
//

#include "module.h"

#include <utility>

namespace generator {
    namespace object{

        module::module(std::string modname
                        ):
                        blockName(std::move(modname)) {}

        generatedDayta module::genObj() {
            // todo
            generatedDayta gdt;
            std::string preRet;

            preRet += "module (\n";

            for (int interface_num = 0; interface_num < (interfaces.size()-1); interface_num++){
                assert(interfaces[interface_num].itf != nullptr);
                preRet += "     " + interfaces[interface_num].itf->getFinalIntfName() + "     " + interfaces[interface_num].name + ",\n";
            }

            if ( (interfaces.size()-1) >= 0){
                assert(interfaces[interfaces.size()-1].itf != nullptr);
                preRet += "     " + interfaces[interfaces.size()-1].itf->getFinalIntfName() + "     " + interfaces[interfaces.size()-1].name + "\n";
            }
            preRet += ");\n\n\n\n\n\n\n\nendmodule";

            gdt.dayta = preRet;
            gdt.preDt = "\n\n\n\n\n\n\n";
            gdt.postDt= "\n\n\n\n\n\n\n";
            return gdt;
        }

        void module::addLocalInterface(const std::string& con_name, interface *itf, std::string& des) {
            interfaces.emplace_back(connector{con_name, itf, des});
        }


    }
}