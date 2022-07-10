//
// Created by tanawin on 10/7/65.
//

#include "codeTransfer.h"

#include <utility>


namespace generator::service{


    void codeTransfer::addCode(const std::string& start_tag, std::string stop_tag, std::string code) {
        codeMap.emplace(start_tag,
                        codedayta{start_tag, std::move(stop_tag), std::move(code)}
                        );
    }

    codedayta codeTransfer::retrieveCode(std::string key) {
        if (codeMap.find(key) != codeMap.end()){
            return codeMap[key];
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