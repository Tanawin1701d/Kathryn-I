//
// Created by tanawin on 9/7/65.
//

#ifndef GENERATOR_IOH_H
#define GENERATOR_IOH_H

#include<iostream>
#include<OpenXLSX.hpp>

namespace generator::service {

    std::string CToS(const char *raw);
    std::string CellToString(OpenXLSX::XLCellValue value);
    std::string SanizDesc(const std::string& raw);
    std::string repeatStr(const std::string& raw, int times);
    void        check_that(bool condition, const std::string& place, const std::string& cause);
    void        SanizDirPath(std::string& path);
}

#endif //GENERATOR_IOH_H
