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

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN)
set(VCPKG_ENV_PASSTHROUGH VCPKG_Python3_EXECUTABLE)

if("${PORT}" STREQUAL "python3")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
