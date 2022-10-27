//
// Created by tanawin on 9/7/65.
//

#include "ioh.h"
namespace generator::service {

    std::string CToS(const char *raw) {
        if (raw) {
            return std::string(raw);
        }

        return std::string();
    }

    std::string CellToString(OpenXLSX::XLCellValue value){
        if (value.type() == OpenXLSX::XLValueType::Integer) {
            return std::to_string(value.get<int64_t>());
        }else if (value.type() == OpenXLSX::XLValueType::String){
            return value.get<std::string>();
        }else if (value.type() == OpenXLSX::XLValueType::Float){
            return std::to_string(value.get<double>());
        }
        return "";
    }

    std::string SanizDesc(const std::string& raw){
        std::string ret;
        for (char x: raw){
            if ( x == '\n' || x == '\r'){
                ret += ' ';
            }else{
                ret += x;
            }
        }
        return ret;
    }

    std::string repeatStr(const std::string& raw, int times){
        std::string ret = "";
        for (int i = 0; i < times; i++){
            ret += raw;
        }
        return ret;
    }

    void check_that(bool pass, const std::string& place , const std::string& cause){
        if (!pass){
            std::cout << "[" + place + "@generator]: " + cause << '\n';
            exit(1);
        }
    }

    void SanizDirPath(std::string& path){
        if (path.length() >= 1){
            if (path[path.length()-1] != '/'){
                path.append(0, '/');
            }
            if (path[path.length()-1] == '/'){
                path.erase(path.begin());
            }
        }
    }

    bool isInt(std::string input){
        //TODO we use only detect variable or number so, we might use regex to test
        //string
        return (input.size() > 0) && (input[0] >= '0') && (input[0] <= '9');
    }

}