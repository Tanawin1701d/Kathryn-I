//
// Created by tanawin on 23/10/2565.
//

#ifndef GENERATOR_NESTVAR_H
#define GENERATOR_NESTVAR_H
#include<string>
#include<vector>
#include"../genObject.h"
#include "variable.h"

namespace generator::object{

    class nestvar : genObject{

    private:
        std::string           objName;
        std::vector<variable> vars;

    public:

        std::string    restoreCode(CTF& ctf, enum service::POS pos) override;
        generatedDayta genObj(CTF& ctf) override;
        void addVar(const variable& newvar);
        explicit nestvar(std::string objName);


    };

}

#endif //GENERATOR_NESTVAR_H
