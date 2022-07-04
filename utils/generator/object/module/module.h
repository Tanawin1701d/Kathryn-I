//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_MODULE_H
#define GENERATOR_MODULE_H

#include <string>
#include <vector>
#include "../genObject.h"
#include "../interface/interface.h"

namespace generator {
    namespace object{


        struct connector{
         std::string name; //connection name
         interface*  itf;
         std::string des;
        };


        class module : public genObject{
        private:
                        // interface and name that use with interface
            std::vector<connector> interfaces;
            std::string                                       blockName;
        public :
            module(std::string modname);
            generatedDayta genObj() override;
            void addLocalInterface(const std::string& con_name, interface* itf, std::string& des);


        };




    }
}


#endif //GENERATOR_MODULE_H
