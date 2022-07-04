//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_GENOBJECT_H
#define GENERATOR_GENOBJECT_H

#include <string>

namespace generator {
    namespace object{

        //using namespace generator::service;
        struct generatedDayta{ // todo In the future this will be used to tokenize data from last file to build exclusion region
            std::string dayta; // dayta that generated from each genObject
            std::string preDt; // message that paste before the dayta
            std::string postDt;// message that paste after  the dayta
        };

        class genObject{

        private:

        public :
            virtual generatedDayta genObj() = 0;


        };




    }
}



#endif //GENERATOR_GENOBJECT_H
