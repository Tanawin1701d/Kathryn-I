//
// Created by tanawin on 2/7/65.
//

#include "interface.h"

#include <utility>
#include <cassert>


namespace generator::object{

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
                   portSize("")
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

        std::string port::genPort(int expeVarSize) {
            std::string sp = service::repeatStr(" ", ((unsigned long)expeVarSize) - getMinVarlen());
            if (portType == PORT_TYPE::logic){
                return "logic[" + portSize
                                + sp  +" -1: 0] "
                                + portName;
            }else if (portType == PORT_TYPE::inherit){
                assert(inherited_port != nullptr);
                //std::string gdt = inherited_port->genPortSet();
                return inherited_port->getFinalIntfName() + sp + " " + portName;
            }
                std::cout << "unexpected port name: " << portName << '\n';
                exit(1);
        }

    std::string port::getDesc() {
        return description;
    }

    int port::getPortSizelen() {
        return portSize.size();
    }

    PORT_TYPE port::getPortType() {
        return portType;
    }

    int port::getMinVarlen() {
        if (portType == PORT_TYPE::logic) {
            return getPortSizelen() + port::varSize;
        }else if (portType == PORT_TYPE::inherit){
            return inherited_port->getFinalIntfName().size();
        }else{
            assert(1);
        }


    }

/// interface ///////////////////////////////////////////////////////////////
        interface::interface(std::string input_interface_name,
                             std::string input_interface_id
                             ):
                             interface_name(std::move(input_interface_name)),
                             interface_id  (std::move(input_interface_id  ))
        {}

        generatedDayta interface::genObj( CTF& ctf ) {
            generatedDayta gdRet;
            std::string preResult;
            preResult = "interface " + getFinalIntfName()+ " ();\n";
            preResult += genPortSet();
            preResult += "\n";
            preResult += "endinterface";

            gdRet.dayta  = preResult;
            gdRet.preDt  = "/////////////////////////////////////\n\n\n/////////////////////////////////////";
            gdRet.postDt = "/////////////////////////////////////\n\n\n/////////////////////////////////////";

            return gdRet;
        }

        interface::~interface() {
            for (auto dt: ports){
                delete dt;
            }
        }

        std::string interface::genPortSet() {
            std::string preResult;
            // every lines must have  ",\n"
            //preResult = "interface " + interface_name + " ();\n";
            int expectSize = -1;
            for (auto p : ports){
                expectSize = std::max(expectSize, p->getMinVarlen());
            }

            for (int port_id = 0; port_id < ports.size(); port_id++){
                preResult += "      " + ports[port_id]->genPort(expectSize)
                           + ((port_id ==(ports.size()-1)) ? "  ":" ,")+" //"
                           + service::SanizDesc(ports[port_id]->getDesc())+"\n";
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




