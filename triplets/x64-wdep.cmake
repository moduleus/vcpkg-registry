# Windows
# Dynamic library
# Environment passthrough for VCPKG_TOKEN
# Pass VCPKG_Python3_EXECUTABLE

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN)
set(VCPKG_ENV_PASSTHROUGH VCPKG_Python3_EXECUTABLE)