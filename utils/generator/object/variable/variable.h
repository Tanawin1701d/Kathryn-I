//
// Created by tanawin on 4/7/65.
//

#ifndef GENERATOR_VARIABLE_H
#define GENERATOR_VARIABLE_H

#include<string>
#include<vector>
#include"../genObject.h"

namespace generator {
    namespace object{



        class variable : public genObject{
        private:
            std::string type;
            std::string name;
            std::string value;
            std::string des;
        public :
            variable(std::string type,
                     std::string name,
                     std::string value,
                     std::string des);
            generatedDayta genObj() override;


        };




    }
}



#endif //GENERATOR_VARIABLE_H
