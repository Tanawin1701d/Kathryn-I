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
    static const std::string POS_PRE_SUFFIX  = "_PRE";
    static const std::string POS_POST_SUFFIX  = "_POST";
    const int CODETAG_SIZE = 3; //  "//$" or "//@"
    // implicit rule is  STARTTAG_PREFIX + blockname + pos suffix
    // implicit rule is  STOPTAG_PREFIX  + blockname + pos suffix

    enum POS{
        PRE,
        MID,
        POS
    };


    class codeTransfer;
    class codedayta{

    public:
        std::string start_tag;
        std::string stop_tag;
        std::string code;
        codedayta(std::string keyName, enum POS pos);
        codedayta(std::string _start_tag,
                  std::string _stop_tag,
                  std::string _code
                  );
        std::string finalize(codeTransfer& ctf);

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
