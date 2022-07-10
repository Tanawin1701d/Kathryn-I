//
// Created by tanawin on 2/7/65.
//

#include "module.h"


namespace generator::object{

        module::module(std::string modname
                      ):
                        blockName(std::move(modname)) {}


        module::~module() {

        }

        generatedDayta
        module::genObj( CTF& ctf ) {
            generatedDayta gdt;
            std::string    preRet;

            int expectSize = -1;
            for (auto x : connectors){
                expectSize = std::max(expectSize,(int)x.itf->getFinalIntfName().size());
            }


            ///// gen dayta
            preRet += "module (\n";

            for (int interface_num = 0; interface_num < connectors.size(); interface_num++){
                assert(connectors[interface_num].itf != nullptr);
                preRet += "     " + connectors[interface_num].itf->getFinalIntfName()
                        + service::repeatStr(" ",expectSize - connectors[interface_num].itf->getFinalIntfName().size())
                        + " " + connectors[interface_num].name
                        + ((interface_num == (connectors.size()-1)) ? "" : ",") + "  //" + service::SanizDesc(connectors[interface_num].des)
                        +"\n";
            }

            preRet += ");\n\n\n\n" + restoreCode(ctf,service::POS::MID) +"\n\n\n\nendmodule";
            gdt.dayta = preRet;
            gdt.preDt = "\n\n\n"+restoreCode(ctf,service::POS::PRE)+"\n\n\n\n";
            gdt.postDt= "\n\n\n"+restoreCode(ctf,service::POS::POS)+"\n\n\n\n";
            //////////////////////////////////////////////
            return gdt;
        }

        void
        module::addLocalInterface(const std::string& con_name, interface *itf, std::string& des) {
            assert(itf != nullptr);
            connectors.emplace_back(connector{con_name, itf, des});
        }

        std::string
        module::restoreCode(CTF &ctf, enum service::POS pos ) {

            std::string suffix = "";
            switch(pos){
                case service::POS::PRE : suffix = service::STARTTAG_PRE_SUFFIX; break;
                case service::POS::MID : break;
                case service::POS::POS : suffix = service::STOPTAG_POST_SUFFIX; break;
            }



            std::string ret;
            CTD cached;
            cached.start_tag = generator::service::STARTTAG_PREFIX + blockName + suffix;
            cached.stop_tag  = generator::service::STOPTAG_PREFIX  + blockName + suffix;
            if (ctf.areThereCode(cached.start_tag)){
                cached = ctf.retrieveCode(cached.start_tag);
            }
            return cached.start_tag + '\n' + cached.code + '\n' + cached.stop_tag;
    }




}