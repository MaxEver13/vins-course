# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/max/Documents/ch6/BA_schur

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/max/Documents/ch6/BA_schur/build

# Include any dependencies generated for this target.
include app/CMakeFiles/testCurveFitting.dir/depend.make

# Include the progress variables for this target.
include app/CMakeFiles/testCurveFitting.dir/progress.make

# Include the compile flags for this target's objects.
include app/CMakeFiles/testCurveFitting.dir/flags.make

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o: app/CMakeFiles/testCurveFitting.dir/flags.make
app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o: ../app/CurveFitting.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/max/Documents/ch6/BA_schur/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o -c /home/max/Documents/ch6/BA_schur/app/CurveFitting.cpp

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.i"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/max/Documents/ch6/BA_schur/app/CurveFitting.cpp > CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.i

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.s"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/max/Documents/ch6/BA_schur/app/CurveFitting.cpp -o CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.s

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.requires:

.PHONY : app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.requires

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.provides: app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.requires
	$(MAKE) -f app/CMakeFiles/testCurveFitting.dir/build.make app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.provides.build
.PHONY : app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.provides

app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.provides.build: app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o


# Object files for target testCurveFitting
testCurveFitting_OBJECTS = \
"CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o"

# External object files for target testCurveFitting
testCurveFitting_EXTERNAL_OBJECTS =

app/testCurveFitting: app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o
app/testCurveFitting: app/CMakeFiles/testCurveFitting.dir/build.make
app/testCurveFitting: backend/libslam_course_backend.a
app/testCurveFitting: app/CMakeFiles/testCurveFitting.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/max/Documents/ch6/BA_schur/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable testCurveFitting"
	cd /home/max/Documents/ch6/BA_schur/build/app && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/testCurveFitting.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
app/CMakeFiles/testCurveFitting.dir/build: app/testCurveFitting

.PHONY : app/CMakeFiles/testCurveFitting.dir/build

app/CMakeFiles/testCurveFitting.dir/requires: app/CMakeFiles/testCurveFitting.dir/CurveFitting.cpp.o.requires

.PHONY : app/CMakeFiles/testCurveFitting.dir/requires

app/CMakeFiles/testCurveFitting.dir/clean:
	cd /home/max/Documents/ch6/BA_schur/build/app && $(CMAKE_COMMAND) -P CMakeFiles/testCurveFitting.dir/cmake_clean.cmake
.PHONY : app/CMakeFiles/testCurveFitting.dir/clean

app/CMakeFiles/testCurveFitting.dir/depend:
	cd /home/max/Documents/ch6/BA_schur/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/max/Documents/ch6/BA_schur /home/max/Documents/ch6/BA_schur/app /home/max/Documents/ch6/BA_schur/build /home/max/Documents/ch6/BA_schur/build/app /home/max/Documents/ch6/BA_schur/build/app/CMakeFiles/testCurveFitting.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : app/CMakeFiles/testCurveFitting.dir/depend

