MACRO(TEST_COMPILER_VISIBILITY)
IF(NOT WIN32 AND NOT CMAKE_COMPILER_IS_ICC)
  SET(CMAKE_REQUIRED_FLAGS "-fvisibility=hidden")
  CHECK_C_SOURCE_COMPILES(
"void __attribute__((visibility(\"default\"))) test() {}
#ifdef __INTEL_COMPILER
#error ICC breaks with binutils and visibility
#endif
int main(){}
" HAVE_VISIBILITY)
  SET(CMAKE_REQUIRED_FLAGS "")

  IF(HAVE_VISIBILITY)
    SET(ADD_CFLAGS "${ADD_CFLAGS} -fvisibility=hidden")
    ADD_DEFINITIONS(-DHAVE_GCC_VISIBILITY)
  ENDIF(HAVE_VISIBILITY)
ENDIF(NOT WIN32 AND NOT CMAKE_COMPILER_IS_ICC)
ENDMACRO(TEST_COMPILER_VISIBILITY)


MACRO(TEST_NASM_COMPILER_VISIBILITY)
IF(NOT DEFINED HAVE_NASM_VISIBILITY)
  MESSAGE(STATUS "Performing Test HAVE_NASM_VISIBILITY")
  SET(SOURCE "global _foo:function hidden\n_foo:")
  FILE(WRITE "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/src.nasm" "${SOURCE}")

  TRY_COMPILE(HAVE_NASM_VISIBILITY
        ${CMAKE_BINARY_DIR}
        ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/src.nasm
        OUTPUT_VARIABLE OUTPUT)

  WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
    "Performing nasm visibility test with the following output:\n"
    "${OUTPUT}\n"
    "Source file was:\n${SOURCE}\n" APPEND)

  IF(HAVE_NASM_VISIBILITY)
    MESSAGE(STATUS "Performing Test HAVE_NASM_VISIBILITY - Success")
  ELSE(HAVE_NASM_VISIBILITY)
    MESSAGE(STATUS "Performing Test HAVE_NASM_VISIBILITY - Failure")
  ENDIF(HAVE_NASM_VISIBILITY)
ENDIF(NOT DEFINED HAVE_NASM_VISIBILITY)

IF(HAVE_NASM_VISIBILITY)
  SET(CMAKE_ASM_FLAGS "-DHAVE_NASM_VISIBILITY")
ENDIF(HAVE_NASM_VISIBILITY)
ENDMACRO(TEST_NASM_COMPILER_VISIBILITY)