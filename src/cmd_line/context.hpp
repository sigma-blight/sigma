// TODO: doxygen header

#ifndef		_SIGMA_LANGUAGE_SRC_CMD_LINE_HPP_
#define		_SIGMA_LANGUAGE_SRC_CMD_LINE_HPP_

#include <vector>
#include <string>

namespace cmd_line
{
  // TODO: doxygen header
  struct Context
  {
      using source_files_t = std::vector<std::string>;

      Context(source_files_t);

      const source_files_t source_files;
  };
}

#endif	//	_SIGMA_LANGUAGE_SRC_CMD_LINE_HPP_
