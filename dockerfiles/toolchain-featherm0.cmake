# this toolchain file comes from gnuradio project

set(CMAKE_SYSTEM_NAME Linux)
#set(CMAKE_C_COMPILER  $ENV{CC})
#set(CMAKE_CXX_COMPILER  $ENV{CXX})
set(CMAKE_CXX_FLAGS $ENV{CXXFLAGS}  CACHE STRING "" FORCE )
set(CMAKE_C_FLAGS $ENV{CFLAGS} CACHE STRING "" FORCE ) #same flags for C sources
set(CMAKE_LDFLAGS_FLAGS ${CMAKE_CXX_FLAGS} CACHE STRING "" FORCE ) #same flags for C sources
SET(CMAKE_SYSROOT $ENV{ARDUINOSAM_ROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_LIBRARY_PATH $ENV{ARDUINOSAM_ROOT}/ )
SET(CMAKE_FIND_ROOT_PATH $ENV{ARDUINOSAM_ROOT})
# search for programs ls in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)