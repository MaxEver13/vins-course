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
include app/CMakeFiles/testMonoBA.dir/depend.make

# Include the progress variables for this target.
include app/CMakeFiles/testMonoBA.dir/progress.make

# Include the compile flags for this target's objects.
include app/CMakeFiles/testMonoBA.dir/flags.make

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o: app/CMakeFiles/testMonoBA.dir/flags.make
app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o: ../app/TestMonoBA.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/max/Documents/ch6/BA_schur/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o -c /home/max/Documents/ch6/BA_schur/app/TestMonoBA.cpp

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.i"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/max/Documents/ch6/BA_schur/app/TestMonoBA.cpp > CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.i

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.s"
	cd /home/max/Documents/ch6/BA_schur/build/app && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/max/Documents/ch6/BA_schur/app/TestMonoBA.cpp -o CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.s

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.requires:

.PHONY : app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.requires

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.provides: app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.requires
	$(MAKE) -f app/CMakeFiles/testMonoBA.dir/build.make app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.provides.build
.PHONY : app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.provides

app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.provides.build: app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o


# Object files for target testMonoBA
testMonoBA_OBJECTS = \
"CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o"

# External object files for target testMonoBA
testMonoBA_EXTERNAL_OBJECTS =

app/testMonoBA: app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o
app/testMonoBA: app/CMakeFiles/testMonoBA.dir/build.make
app/testMonoBA: backend/libslam_course_backend.a
app/testMonoBA: app/CMakeFiles/testMonoBA.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/max/Documents/ch6/BA_schur/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable testMonoBA"
	cd /home/max/Documents/ch6/BA_schur/build/app && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/testMonoBA.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
app/CMakeFiles/testMonoBA.dir/build: app/testMonoBA

.PHONY : app/CMakeFiles/testMonoBA.dir/build

app/CMakeFiles/testMonoBA.dir/requires: app/CMakeFiles/testMonoBA.dir/TestMonoBA.cpp.o.requires

.PHONY : app/CMakeFiles/testMonoBA.dir/requires

app/CMakeFiles/testMonoBA.dir/clean:
	cd /home/max/Documents/ch6/BA_schur/build/app && $(CMAKE_COMMAND) -P CMakeFiles/testMonoBA.dir/cmake_clean.cmake
.PHONY : app/CMakeFiles/testMonoBA.dir/clean

app/CMakeFiles/testMonoBA.dir/depend:
	cd /home/max/Documents/ch6/BA_schur/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/max/Documents/ch6/BA_schur /home/max/Documents/ch6/BA_schur/app /home/max/Documents/ch6/BA_schur/build /home/max/Documents/ch6/BA_schur/build/app /home/max/Documents/ch6/BA_schur/build/app/CMakeFiles/testMonoBA.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : app/CMakeFiles/testMonoBA.dir/depend

