//
// Created by tanawin on 2/7/65.
//

#include "bundle.h"

#include <utility>
#include <cassert>


namespace generator::object{

/// port ///////////////////////////////////////////////////////////////

    port::port(PORT_TYPE input_portType,
               bundle *input_inherited_port,
               std::string input_description) {

        service::check_that(input_inherited_port != nullptr, "port constructor", "recursive port is null");

        assert( (input_portType == BUNDLE) || (input_portType == FLIPPED_BUNDLE));

        portType       = input_portType;
        inherited_port = input_inherited_port;
        description    = std::move(input_description);
    }

    port::port(PORT_TYPE input_portType,
               std::string input_description,
               std::string input_portSize,
               std::string input_portSizeOwner,
               PORT_SIZE_TYP input_portSizeType) {

        assert( (input_portType == INPUT) || (input_portType == OUTPUT));
        portType = input_portType;
        description = std::move(input_description);
        portSize    = std::move(input_portSize);
        portSizeOwner = std::move(input_portSizeOwner);
        portSizeType = input_portSizeType;
    }

    std::string port::genPort() {

        std::string preRet;
        if ( (portType == INPUT) || (portType == OUTPUT)){
            preRet = std::string(portType == INPUT ? "Input": "Output") +
                     "(UInt(" +
                     ((portSizeType == DEFAULT_VAR) ? (portSizeOwner + ".") : "") +
                     portSize +
                     ".W))";
        }else if (portType == BUNDLE){
            preRet = "new " + inherited_port->getFinalBundleName() + "()";
        }else if (portType == FLIPPED_BUNDLE){
            preRet = "Flipped( new " + inherited_port->getFinalBundleName() + "())";
        }else {

            service::check_that(false,
                                "genport",
                                "no port type found!"
            );
        }
        return preRet + service::SanizDesc(description);
    }

    std::string port::getDesc() {
        return description;
    }

    PORT_TYPE port::getPortType() {
        return portType;
    }


/// interface ///////////////////////////////////////////////////////////////

        std::string
        bundle::restoreCode(CTF& ctf, enum service::POS pos){
            CTD cached(getFinalBundleName(), pos);
            return cached.finalize(ctf);
        }

        bundle::bundle(std::string input_bundle_name,
                       std::string input_bundle_id
                             ):
                bundle_name(std::move(input_bundle_name)),
                bundle_id  (std::move(input_bundle_id  ))
        {}

        generatedDayta bundle::genObj(CTF& ctf ) {
            generatedDayta gdRet;
            std::string preResult;
            preResult = "class " + getFinalBundleName() + " extends Bundle{\n";
            preResult += genPortSet();
            preResult += "\n";
            preResult += restoreCode(ctf, service::POS::MID) + "\n";
            preResult += "} ";

            gdRet.dayta  = preResult;
            gdRet.preDt  = "/////////////////////////////////////\n\n\n/////////////////////////////////////";
            gdRet.postDt = "/////////////////////////////////////\n\n\n/////////////////////////////////////";

            return gdRet;
        }

        bundle::~bundle() {
            for (const auto& dt: ports){
                delete dt.port_ptr;
            }
        }

        std::string bundle::genPortSet() {
            std::string preResult;
            //calculate max length name to make it read easily
            size_t expectSize = 0;
            for (auto p : ports){
                expectSize = std::max(expectSize, p.name.size());
            }

            // generate like var x = ...
            for (int port_id = 0; port_id < ports.size(); port_id++){
                preResult += "    val "+
                        ports[port_id].name +
                        service::repeatStr(" ", expectSize - ports[port_id].name.size()) +
                        " = " +
                        ports[port_id].port_ptr->genPort() +
                        "\n"; // this will gen description too
            }
            return preResult;
        }

        void bundle::addPort(std::string input_portName, port* input_port_ptr) {
            service::check_that(input_port_ptr != nullptr, "add port", "nullptr port");
            ports.push_back({std::move(input_portName), input_port_ptr});
        }

        std::string bundle::getFinalBundleName() {
            return bundle_name + "_" + bundle_id;
        }

/////////////////////////////////////////////////
}
