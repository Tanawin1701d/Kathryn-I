//
// Created by tanawin on 4/7/65.
//

#ifndef GENERATOR_VARIABLE_H
#define GENERATOR_VARIABLE_H

#include<string>
#include<vector>
#include"../genObject.h"

namespace generator::object{



        class variable : public genObject{
        private:
            std::string type;
            std::string name;
            std::string value;
            std::string des;
            [[maybe_unused]] std::string    restoreCode(CTF& ctf, enum service::POS pos){};
        public :
            variable(std::string type,
                     std::string name,
                     std::string value,
                     std::string des);
            generatedDayta genObj(CTF& ctf) override;


        };




    }



#endif //GENERATOR_VARIABLE_H
