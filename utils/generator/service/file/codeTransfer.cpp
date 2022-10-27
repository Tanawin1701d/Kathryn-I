//
// Created by tanawin on 10/7/65.
//

#include "codeTransfer.h"

#include <utility>


namespace generator::service{

    /////// code dayta
    codedayta::codedayta(std::string keyName, enum POS pos) {
        start_tag = STARTTAG_PREFIX + keyName;
        stop_tag  = STOPTAG_PREFIX  + keyName;
        switch (pos) {
            case PRE:
                    { start_tag += POS_PRE_SUFFIX;
                      stop_tag  += POS_PRE_SUFFIX;
                        break;
                    }
            case MID:
                    {
                        break;
                    }
            case POS:
                    { start_tag += POS_POST_SUFFIX;
                      stop_tag  += POS_POST_SUFFIX;
                        break;
                    }
        }
    }

    codedayta::codedayta(std::string _start_tag, std::string _stop_tag, std::string _code):
    start_tag(std::move(_start_tag)),
    stop_tag(std::move(_stop_tag)),
    code(std::move(_code))
    {}

    std::string
    codedayta::finalize(codeTransfer& ctf) {
        code =  ctf.areThereCode(start_tag) ? ctf.retrieveCode(start_tag).code : "";
        return start_tag + '\n' + code + '\n' + stop_tag;
    }
    /// finalize with owner's code
    std::string
    codedayta::finalize() {
        return start_tag + '\n' + code + '\n' + stop_tag;
    }
    /////// codeTransfer
    void codeTransfer::addCode(const std::string& start_tag, std::string stop_tag, std::string code) {
        codeMap.emplace(start_tag,
                        codedayta(start_tag,
                                  std::move(stop_tag),
                                  std::move(code))
                        );
    }

    codedayta
    codeTransfer::retrieveCode(std::string key) {
        if (codeMap.find(key) != codeMap.end()){
            return codeMap.at(key);
        }
        check_that(false,
                   "codeTransfer",
                   "there are no match id " + key
        );
        exit(1);
    }

    bool codeTransfer::areThereCode(std::string key) {
        return (codeMap.find(key) != codeMap.end());
    }

}