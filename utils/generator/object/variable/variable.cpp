//
// Created by tanawin on 4/7/65.
//

#include "variable.h"

namespace generator{
    namespace object{


        variable::variable(std::string type,
                           std::string name,
                           std::string value,
                           std::string des):
                           type(std::move(type)),
                           name(std::move(name)),
                           value(std::move(value)),
                           des(std::move(des))
                           {
                                // todo sanity check type and value
                           }

        generatedDayta variable::genObj() {
            generatedDayta gdt;
            gdt.dayta = type + " " + name + " = " + value + ";    //" + des;
            gdt.preDt = "";
            gdt.postDt= "";
            return gdt;
        }
    }
}