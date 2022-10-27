//
// Created by tanawin on 2/7/65.
//

#include "module.h"


namespace generator::object{

    std::string
    module::restoreCode(CTF &ctf, enum service::POS pos ) {

        CTD cached(blockName, pos);
        return cached.finalize(ctf);
    }

    module::module(std::string modname):
                        io_bundle(new bundle(blockName, "io")),
                        blockName(std::move(modname)) {
        /// block name is ${blockName}_io
    }


    module::~module() {
        delete io_bundle;
    }

    generatedDayta
    module::genObj( CTF& ctf ) {
        generatedDayta gdt;
        ///// generate code section
        std::string    preMidRet;
        preMidRet += io_bundle->genObj(ctf).dayta + "\n\n\n\n\n\n\n\n";

        preMidRet += "class " + blockName + " extends Module{\n\n";
        preMidRet += "val io = IO(new "+ io_bundle->getFinalBundleName() +" )\n";
        preMidRet += restoreCode(ctf, service::POS::MID) + "\n";
        preMidRet += "}";

        ////////////////////////////////////
        gdt.preDt = "\n\n\n"+restoreCode(ctf,service::POS::PRE)+"\n\n\n\n";
        gdt.dayta = preMidRet;
        gdt.postDt= "\n\n\n"+restoreCode(ctf,service::POS::POS)+"\n\n\n\n";
        //////////////////////////////////////////////
        return gdt;
    }

    void module::addBundle(const std::string& input_portName,
                           bundle *nextBundle,
                           bool isflip,
                           const std::string& description
                           ) {
        assert(nextBundle);
        port* np = new port(isflip ? PORT_TYPE::FLIPPED_BUNDLE : PORT_TYPE::BUNDLE,
                           nextBundle,
                           description
                           );

        io_bundle->addPort(input_portName, np);
    }
}