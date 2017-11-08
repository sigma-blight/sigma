#include "parser.hpp"
#include <stdexcept>
#include <string>

#include <iostream>

using namespace cmd_line;

static constexpr unsigned ARGC_MIN = 2;

Context cmd_line::parse(const unsigned argc, const char ** argv)
{
	if (argc < ARGC_MIN)
		throw std::invalid_argument {
			std::string{ "Usage: " } + argv[0] + 
			" <source_files.sig ...> [options...]\n"
		};

	Context::source_files_t source_files;

	for (auto it = argv + 1; it != argv + argc; ++it) {
		if ((*it)[0] == '-') {
			std::cout << "Option: " << *it
				<< "\tValue: " << (
					(it + 1 == argv + argc) ? 
					"*null*" : *(it + 1))				
				<< "\n";
				++it;
		} else {
			source_files.push_back(*it);
		}
	}

	Context context{ 
		source_files 
	};
	return context;
}
