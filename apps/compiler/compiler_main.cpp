#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iterator>
#include <algorithm>

int main(const int argc, const char ** argv)
{
    // check argc    
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <source_files.sig...>\n";
        exit(-1);
    }
    
    // check file
    std::ifstream source_file(argv[1]);
    if (!source_file) {
        std::cerr << "Cannot access file: " << argv[1] << "\n";
        exit(-1);
    }
    
    // start parse
    std::vector<std::string> code;
    
    do { code.emplace_back(); }
    while (std::getline(source_file, code.back()));
    code.pop_back();
              
    std::copy(code.begin(), code.end(), std::ostream_iterator<std::string>(std::cout, "\n"));
}
