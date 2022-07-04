//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_INTERFACE_H
#define GENERATOR_INTERFACE_H
#include "../genObject.h"
#include <iostream>
#include <vector>
#include <cassert>


namespace generator {
    namespace object{

        enum PORT_TYPE{
            logic,
            reg,
            wire,
            inherit
        };


        class interface;
        class port{
        private:
            PORT_TYPE   portType ;
            interface*  inherited_port; // case this port is copy from other interface
            std::string portName;
            std::string description;
            std::string portSize;

        public:
            port(PORT_TYPE   input_portType,
                 interface*       input_inherited_port,
                 std::string input_portName,
                 std::string description
            );

            port(PORT_TYPE   input_portType,
                 std::string input_portName,
                 std::string description,
                 std::string portSize
            );

            std::string genPort(); // last comma is true when want , at last of the line
        };

        class interface : public genObject{
        private:
            std::string        interface_name;
            std::string        interface_id;
            std::vector<port*> ports;

        public :
            interface(std::string input_interface_name,
                      std::string input_interface_id);
            generatedDayta genObj() override;
            std::string    genPortSet();
            void           addPort(port* pt);
            std::string    getFinalIntfName();
            static std::string getFinalIntfName(const std::string& itfName,
                                                      const std::string& id){
                return itfName + "_" + id;
            }



        };




    }
}
#endif //GENERATOR_INTERFACE_H
