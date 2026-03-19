# Windows
# Static library
# Dynamic Crt
# Environment passthrough for VCPKG_TOKEN
# Sanitize
# Python always dynamic

set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CXX_FLAGS "-fsanitize=address")
set(VCPKG_C_FLAGS "-fsanitize=address")

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN VCPKG_Python3_EXECUTABLE)
if(DEFINED ENV{VCPKG_Python3_EXECUTABLE})
  set(VCPKG_HASH_ADDITIONAL_FILES "$ENV{VCPKG_Python3_EXECUTABLE}")
endif()

if("${PORT}" STREQUAL "python3")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
