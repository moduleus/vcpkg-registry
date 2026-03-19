# Windows
# Dynamic library
# Release only
# Environment passthrough for VCPKG_TOKEN
# Python always dynamic

set(VCPKG_TARGET_ARCHITECTURE x86)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)
set(VCPKG_BUILD_TYPE release)

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN VCPKG_Python3_EXECUTABLE)
if(DEFINED ENV{VCPKG_Python3_EXECUTABLE})
  set(VCPKG_HASH_ADDITIONAL_FILES "$ENV{VCPKG_Python3_EXECUTABLE}")
endif()
