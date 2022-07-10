//
// Created by tanawin on 10/7/65.
//

#ifndef GENERATOR_CODETRANSFER_H
#define GENERATOR_CODETRANSFER_H

#include <string>
#include <map>
#include "../ioHelp/ioh.h"

namespace generator::service{

    static const std::string STARTTAG_PREFIX = "//$";
    static const std::string STOPTAG_PREFIX  = "//@";
    static const std::string STARTTAG_PRE_SUFFIX  = "_PRE";
    static const std::string STOPTAG_POST_SUFFIX  = "_POST";
    const int CODETAG_SIZE = 3; //  "//$" or "//@"

    struct codedayta{
        std::string start_tag;
        std::string stop_tag;
        std::string code;
    };

    enum POS{
        PRE,
        MID,
        POS
    };

class codeTransfer{
private:
    std::map<std::string, codedayta> codeMap;
public :
    void        addCode(const std::string& start_tag, std::string stop_tag, std::string code);
    codedayta   retrieveCode(std::string key);
    bool        areThereCode(std::string key);

};




}

#endif //GENERATOR_CODETRANSFER_H
