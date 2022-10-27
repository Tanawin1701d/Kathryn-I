//
// Created by tanawin on 23/10/2565.
//

#include "nestvar.h"

#include <utility>

namespace generator::object {
    std::string
    nestvar::restoreCode(CTF &ctf, enum service::POS pos) {
        CTD cached(objName, pos);
        return cached.finalize(ctf);
    }

    generatedDayta
    nestvar::genObj(generator::object::CTF &ctf) {

        generatedDayta preRet;
        preRet.postDt = restoreCode(ctf, service::POS::PRE);
        ///////////
        std::string preDayta  = "object " + objName + "{\n";
        for(auto& vr: vars){
            // gen var
            preDayta += ("   " + vr.genObj(ctf).dayta + "\n");
        }
        preDayta += '\n';
        ///////////
        preRet.dayta = preDayta;
        preRet.postDt = restoreCode(ctf, service::POS::POS);


        return preRet;
    }

    void
    nestvar::addVar(const generator::object::variable &newvar) {
        vars.push_back(newvar);
    }

    nestvar::nestvar(std::string objName) : objName(std::move(objName)) {}

}