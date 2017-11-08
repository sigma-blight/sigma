#include <cmd_line/parser.hpp>
#include <iostream>

int main(const int argc, const char ** argv)
{
	cmd_line::Context context = cmd_line::parse(argc, argv);
	for (const auto & file : context.source_files)
		std::cout << file << "\n";
}
