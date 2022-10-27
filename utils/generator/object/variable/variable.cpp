//
// Created by tanawin on 4/7/65.
//

#include "variable.h"

namespace generator::object{


        variable::variable(VARTYP      type,
                           std::string name,
                           std::string value,
                           std::string des):
                           type (type),
                           name (std::move(name )),
                           value(std::move(value)),
                           des  (std::move(des  ))
                           {
                                // todo sanity check type and value
                           }

        generatedDayta variable::genObj(CTF& ctf) {
            generatedDayta gdt;
            //TODO for now we support only uint
            gdt.dayta = "val " + name + " = " + value + " //" + des;
            gdt.preDt = "";
            gdt.postDt= "";
            return gdt;
        }
    }