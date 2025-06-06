# Windows
# Static library
# Dynamic Crt
# Release only
# Environment passthrough for VCPKG_TOKEN
# Python always dynamic

set(VCPKG_TARGET_ARCHITECTURE x86)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_BUILD_TYPE release)

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN)
set(VCPKG_ENV_PASSTHROUGH VCPKG_Python3_EXECUTABLE)

if("${PORT}" STREQUAL "python3")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
