//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_GENOBJECT_H
#define GENERATOR_GENOBJECT_H

#include <string>
#include "../service/ioHelp/ioh.h"
#include "../service/file/codeTransfer.h"

namespace generator::object{

        //using namespace generator::service;
        struct generatedDayta{ // todo In the future this will be used to tokenize data from last file to build exclusion region
            std::string dayta; // dayta that generated from each genObject
            std::string preDt; // message that paste before the dayta
            std::string postDt;// message that paste after  the dayta
        };

        typedef generator::service::codeTransfer CTF;
        typedef generator::service::codedayta    CTD;

        class genObject{
        private:
            virtual std::string    restoreCode(CTF& ctf, enum service::POS pos) = 0;
        public :
            virtual generatedDayta genObj( CTF& ctf ) = 0;

        };




    }



#endif //GENERATOR_GENOBJECT_H
