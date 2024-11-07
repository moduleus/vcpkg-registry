# Windows
# Dynamic library
# Environment passthrough for VCPKG_TOKEN
# Python always dynamic

set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED VCPKG_TOKEN)
