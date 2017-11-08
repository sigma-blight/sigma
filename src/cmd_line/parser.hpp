// TODO: doxygen header

#ifndef		_SIGMA_LANGUAGE_SRC_CMD_LINE_PARSER_HPP_
#define		_SIGMA_LANGUAGE_SRC_CMD_LINE_PARSER_HPP_

#include "context.hpp"

namespace cmd_line
{
  Context parse(const unsigned argc, const char ** argv);
}

#endif	//	_SIGMA_LANGUAGE_SRC_CMD_LINE_PARSER_HPP_
