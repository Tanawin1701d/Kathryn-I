//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_MODULE_H
#define GENERATOR_MODULE_H

#include <string>
#include <vector>
#include <utility>
#include "../genObject.h"
#include "../interface/interface.h"

namespace generator::object{


        struct connector{
         std::string name; //connection name
         interface*  itf;
         std::string des;
        };


        class module : public genObject{
        private:
            // interface and name that use with interface
            std::vector<connector> connectors;
            std::string            blockName;
            std::string    restoreCode(CTF& ctf, enum service::POS pos);
        public :
            explicit module(std::string modname);
            ~module();
            generatedDayta genObj( CTF& ctf) override;
            void addLocalInterface(const std::string& con_name, interface* itf, std::string& des);


        };




    }


#endif //GENERATOR_MODULE_H
