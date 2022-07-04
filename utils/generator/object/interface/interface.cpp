//
// Created by tanawin on 2/7/65.
//

#include "interface.h"

#include <utility>
#include <cassert>


namespace generator{
    namespace object{

/// port ///////////////////////////////////////////////////////////////
        port::port(PORT_TYPE   input_portType,
                   interface*       input_inherited_port,
                   std::string input_portName,
                   std::string description
                   ):
                   portType(input_portType),
                   inherited_port(input_inherited_port),
                   portName(std::move(input_portName)),
                   description(std::move(description)),
                   portSize(0)
        {
            assert(portType == PORT_TYPE::inherit);
        }

        port::port(PORT_TYPE   input_portType,
                   std::string input_portName,
                   std::string description,
                   std::string portSize
                   ):
                portType(input_portType),
                inherited_port(nullptr),
                portName(std::move(input_portName)),
                description(std::move(description)),
                portSize(std::move(portSize))
        {
            //todo so now our system support only logic and inherit type
            assert(portType == PORT_TYPE::logic);
        }

        std::string port::genPort() {
            if (portType == PORT_TYPE::logic){
                return "logic[" + portSize+"-1: 0] " + portName;
            }else if (portType == PORT_TYPE::inherit){
                assert(inherited_port != nullptr);
                std::string gdt = inherited_port->genPortSet();
                return gdt;
            }
                std::cout << "unexpected port name: " << portName << '\n';
                exit(1);
        }
/// interface ///////////////////////////////////////////////////////////////
        interface::interface(std::string input_interface_name,
                             std::string input_interface_id
                             ):
                             interface_name(std::move(input_interface_name)),
                             interface_id  (std::move(input_interface_id  ))
        {}

        generatedDayta interface::genObj() {
            generatedDayta gdRet;
            std::string preResult;
            preResult = "interface " + getFinalIntfName()+ " ();\n";
            preResult += genPortSet();
            preResult += "endinterface";

            gdRet.dayta  = preResult;
            gdRet.preDt  = "/////////////////////////////////////\n\n\n/////////////////////////////////////";
            gdRet.postDt = "/////////////////////////////////////\n\n\n/////////////////////////////////////";

            return gdRet;
        }

        std::string interface::genPortSet() {
            std::string preResult;
            // every lines must have  ",\n"
            //preResult = "interface " + interface_name + " ();\n";

            for (int port_id = 0; port_id < (ports.size()-1); port_id++){
                preResult += "  " + ports[port_id]->genPort() + " ,\n";
            }
            if ((ports.size()-1) >=0){
                preResult += " " + ports[ports.size()-1]->genPort() + "\n";
            }

            return preResult;
        }

        void interface::addPort(port* pt) {
            ports.push_back(pt);
        }

        std::string interface::getFinalIntfName() {
            return interface_name + "_" + interface_id;
        }


    }
}




