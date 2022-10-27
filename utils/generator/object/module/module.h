//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_MODULE_H
#define GENERATOR_MODULE_H

#include <string>
#include <vector>
#include <utility>
#include "../genObject.h"
#include "../bundle/bundle.h"

namespace generator::object{


        class module : public genObject{
        private:
            bundle*        io_bundle;
            std::string    blockName;
            std::string    restoreCode(CTF& ctf, enum service::POS pos);
        public :
            explicit module(std::string modname);
            ~module();
            generatedDayta genObj( CTF& ctf) override;
            void addBundle(const std::string& input_portName,
                           bundle* nextBundle,
                           bool isflip,
                           const std::string& description
                           );


        };




    }


#endif //GENERATOR_MODULE_H
