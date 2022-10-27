//
// Created by tanawin on 2/7/65.
//

#ifndef GENERATOR_BUNDLE_H
#define GENERATOR_BUNDLE_H
#include "../genObject.h"
#include <iostream>
#include <vector>
#include <cassert>


namespace generator::object{

        enum PORT_TYPE{
            INPUT,
            OUTPUT,
            BUNDLE,
            FLIPPED_BUNDLE
        };
        enum PORT_SIZE_TYP{
            DEFAULT_VAR,
            VALUE
        };


        class bundle;
        class port{
        private:
            PORT_TYPE     portType ;
            bundle*       inherited_port; // case this port is copy from other interface
            std::string   description;
            // port Size consideration
            std::string   portSize;
            std::string   portSizeOwner; // scala object that contain the value
            PORT_SIZE_TYP portSizeType;

        public:
            static const int   varSize = 13; //for only logic[xxx -1: 0]   varsize not include name
            port(
                PORT_TYPE   input_portType,
                 bundle*  input_inherited_port,
                 std::string input_description
            );

            port(
                PORT_TYPE   input_portType,
                 std::string input_description,
                std::string input_portSize,
                std::string input_portSizeOwner,
                PORT_SIZE_TYP input_portSizeType
            );

            std::string genPort(); //spacer between portname and -1
            std::string getDesc();
            PORT_TYPE   getPortType();
        };

        struct portNameMap{
            std::string name;
            port*       port_ptr;
        };

        class bundle : public genObject{
        private:
            std::string        bundle_name;
            std::string        bundle_id;

            std::vector<portNameMap> ports;

            std::string restoreCode(CTF& ctf, enum service::POS pos) override;

        public :
            bundle(std::string input_bundle_name,
                   std::string input_bundle_id);

            ~bundle();

            generatedDayta genObj( CTF& ctf ) override;
            std::string    genPortSet();
            void           addPort(std::string input_portName, port* input_port_ptr);
            std::string    getFinalBundleName();
            static std::string getFinalBundleName(const std::string& itfName,
                                                      const std::string& id){
                return itfName + "_" + id;
            }



        };
    }
#endif //GENERATOR_BUNDLE_H
