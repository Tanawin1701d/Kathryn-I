//
// Created by tanawin on 4/7/65.
//

#ifndef GENERATOR_VARIABLE_H
#define GENERATOR_VARIABLE_H

#include<string>
#include<vector>
#include"../genObject.h"

namespace generator::object{


        enum VARTYP  { UINT } ;

        class variable : public genObject{
        private:
            VARTYP      type; // for now we hard code to Uint
            std::string name;
            std::string value;
            std::string des;
            [[maybe_unused]] std::string    restoreCode(CTF& ctf, enum service::POS pos){};
        public :
            variable(VARTYP      type,
                     std::string name,
                     std::string value,
                     std::string des);
            generatedDayta genObj(CTF& ctf) override;


        };




}



#endif //GENERATOR_VARIABLE_H
