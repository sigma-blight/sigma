import subprocess
import sys
import os

"""

File Structure:

sigma_language_location/
    apps/
        bencher/
            bencher_src_files...
        compiler/
            compiler_src_files...
        tester/
            tester_src_files...
            
    bin/
        tester_executable
        bencher_executable
        compiler_executable
        
    build/
        build.py !!THIS FILE!!
        
    deps/
        include/
            dependencies_include_dirs/...
        lib/
            dependencies_libs...
    
    lib/
        liblibrary.a
        
    src/
        library_src_files...        

"""


# returns sigma_language_location/build
def get_root():
    return os.path.dirname(os.path.realpath(__file__)) + "/"


def get_apps_dir():
    return get_root() + "../apps/"


def get_bin_dir():
    return get_root() + "../bin/"


def get_deps_dir():
    return get_root() + "../deps/"


def get_deps_include_dir():
    return get_deps_dir() + "include/"


def get_deps_lib_dir():
    return get_deps_dir() + "lib/"


def get_library_src_dir():
    return get_root() + "../src/"


def get_library_lib_dir():
    return get_root() + "../lib/"


def execute(cmd_string):
    try:
        print(cmd_string)
        subprocess.check_call([cmd_string], shell=True)
    except subprocess.CalledProcessError:
        print("Command failed: " + cmd_string)
        exit(-1)
    except OSError:
        print("Command not found: " + cmd_string)
        exit(-1)


def front_join(string, list):
    if len(list) != 0:
        return "{1}{0}".format(string.join(list), string)
    else:
        return ""


class CMDArgs:
    def __init__(self, argc, argv):
        self.argc = argc
        self.argv = argv

        if argc < 2:
            print(self.usage())
            exit(-1)

        self.project = argv[1]

        for arg in argv[2:]:
            if arg.startswith("--pf="):
                self.project_flags = arg[5:]
            elif arg.startswith("--cf="):
                self.compiler_flags = arg[5:]
            else:
                print("Fatal build, unknown cmd line arg: " + arg)
                exit(-1)

    def usage(self):
        return "Usage: " + \
               self.argv[0] + \
               " <project>" + \
               " [--pf=\"project_flags\"]" + \
               " [--cf=\"compiler_flags\"]" + \
               " [help]"

    def get_project(self):
        return self.project

    def get_project_flags(self):
        return self.project_flags

    def get_compiler_flags(self):
        return self.compiler_flags


class Project:
    def __init__(self, src_files, compiler_flags, output, include_dirs, lib_dirs, libs, extra):
        self.src_files = " ".join(src_files)
        self.compiler_flags = " ".join(compiler_flags)
        self.output = output
        self.include_dirs = include_dirs
        self.lib_dirs = lib_dirs
        self.libs = " ".join(libs)
        self.extra = extra

    def get_src_files(self): return self.src_files

    def get_compiler_flags(self): return self.compiler_flags

    def get_output(self): return self.output

    def get_include_dirs(self): return self.include_dirs

    def get_lib_dirs(self): return self.lib_dirs

    def get_libs(self): return self.libs

    def get_extra(self): return self.extra

    def __str__(self):
        return "clang++ " + \
               self.compiler_flags + \
               " -o " + self.output + \
               " " + self.src_files + \
               front_join(" -I ", self.include_dirs) + \
               front_join(" -L ", self.lib_dirs) + \
               " " + self.libs + \
               " " + self.extra


def get_compiler_flags():
    return [
        " -std=c++1z"
        " -O3",
        " -fno-rtti",
        " -Wall",
        " -pedantic",
        " -Werror"
    ]


def get_llvm_extra():
    return "`llvm-config --ldflags --system-libs --libs core`"


def get_srcs_from_dir(dir):
    srcs = []
    for root, dirs, files in os.walk(dir):
        for file in files:
            if file.endswith(".cpp"):
                srcs.append(os.path.join(root, file))
    return srcs


def create_library_project(cmd_args):
    cf = get_compiler_flags()
    cf.append(" -shared")
    cf.append(" -fPIC")
    return Project(get_srcs_from_dir(get_library_src_dir()),
                   cf,
                   get_library_lib_dir() + "liblibrary.a",
                   [get_deps_include_dir()],
                   [get_deps_lib_dir()],
                   "", "")


def create_tester_project(cmd_args):
    return Project(get_srcs_from_dir(get_apps_dir() + "tester/"),
                   get_compiler_flags(),
                   get_bin_dir() + "tester",
                   [get_deps_include_dir(), get_library_src_dir()],
                   [get_deps_lib_dir(), get_library_lib_dir()],
                   [" -llibrary",
                    " -lgtest",
                    " -lgtest_main",
                    " -lgmock",
                    " -lgmock_main"
                    " -lpthread"],
                   get_llvm_extra())


def create_bencher_project(cmd_args):
    return Project(get_srcs_from_dir(get_apps_dir() + "bencher/"),
                   get_compiler_flags(),
                   get_bin_dir() + "bencher",
                   [get_deps_include_dir(), get_library_src_dir()],
                   [get_deps_lib_dir(), get_library_lib_dir()],
                   [" -llibrary",
                    " -lbenchmark",
                    " -lpthread"],
                   get_llvm_extra())


def create_compiler_project(cmd_args):
    return Project(get_srcs_from_dir(get_apps_dir() + "compiler/"),
                   get_compiler_flags(),
                   get_bin_dir() + "compiler",
                   [get_deps_include_dir(), get_library_src_dir()],
                   [get_deps_lib_dir(), get_library_lib_dir()],
                   [" -llibrary"],
                   get_llvm_extra())


def build_project(project, cmd_args):
    if project == "library":
        execute(str(create_library_project(cmd_args)))
    elif project == "bencher":
        execute(str(create_bencher_project(cmd_args)))
    elif project == "tester":
        execute(str(create_tester_project(cmd_args)))
    elif project == "compiler":
        execute(str(create_compiler_project(cmd_args)))
    elif project == "all":
        print("")
        print("************************************")
        print("**             Library            **")
        print("************************************")
        print("")
        build_project("library", cmd_args)

        print("")
        print("************************************")
        print("**             Compiler           **")
        print("************************************")
        print("")
        build_project("compiler", cmd_args)

        print("")
        print("************************************")
        print("**             Bencher            **")
        print("************************************")
        print("")
        build_project("bencher", cmd_args)

        print("")
        print("************************************")
        print("**             Tester             **")
        print("************************************")
        print("")
        build_project("tester", cmd_args)

        print("")
        print("************************************")
        print("**             Completed          **")
        print("************************************")
        print("")
    else:
        print("Fatal build, unknown project: " + project)
        exit(-1)


if __name__ == "__main__":
    cmd_args = CMDArgs(len(sys.argv), sys.argv)
    project = cmd_args.get_project()
    build_project(project, cmd_args)