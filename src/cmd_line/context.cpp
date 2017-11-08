#include "context.hpp"
#include <utility>

using namespace cmd_line;

cmd_line::Context::Context(source_files_t source_files_) :
	source_files(std::move(source_files_))
{}
