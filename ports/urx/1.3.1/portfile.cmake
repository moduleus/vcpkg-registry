vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE 74804500cdf2afd0277eab62055b7ec898d434e6)
set(SHA1_VALUE
    d64f41ddc7599fa066445dd943982e0d7fb1f14331b49c60eadd1314abf93a7e9b32e494506080fed636e5f3f6d97184ac568d4bb2cd1cb762bd7316e400b9af
)

vcpkg_from_github(
  OUT_SOURCE_PATH
  SOURCE_PATH
  REPO
  moduleus/urx
  REF
  ${REF_VALUE}
  SHA512
  ${SHA1_VALUE}
  HEAD_REF
  main)

set(VCPKG_REGISTRY_REF_VALUE fec744b0a5d62e9fe8181042bfd6d3afbb6f6b07)
set(VCPKG_REGISTRY_SHA1_VALUE
    cf48b85488748c0d2ea5c56db28d4bedb3a55dbef77f2a61d515d6538df5ebf82a778a6586f84535a72b799cf4d448f921a49b213409e09719de8063d2841db2
)

vcpkg_from_github(
  OUT_SOURCE_PATH
  SOURCE_PATH_VCPKG_REGISTRY
  REPO
  moduleus/vcpkg-registry
  REF
  ${VCPKG_REGISTRY_REF_VALUE}
  SHA512
  ${VCPKG_REGISTRY_SHA1_VALUE}
  HEAD_REF
  main)

file(REMOVE ${SOURCE_PATH}/vcpkg-registry)
file(COPY ${SOURCE_PATH_VCPKG_REGISTRY}/
     DESTINATION ${SOURCE_PATH}/vcpkg-registry)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
set(suffix "")
if(${BUILD_STATIC})
  set(suffix "_static")
endif()

vcpkg_check_features(
  OUT_FEATURE_OPTIONS
  FEATURE_OPTIONS
  FEATURES
  hdf5
  WITH_HDF5
  python
  WITH_PYTHON
  python-wheel
  WITH_PYTHON_WHL
  tests
  BUILD_TESTING
  matlab
  WITH_MATLAB)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" CRT_STATIC)
if(CRT_STATIC)
  set(CRT_SHARED_LIBS "-DCRT_SHARED_LIBS:BOOL=OFF")
else()
  set(CRT_SHARED_LIBS "-DCRT_SHARED_LIBS:BOOL=ON")
endif()

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS ${FEATURE_OPTIONS}
                      ${CRT_SHARED_LIBS})
vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(${REF_VALUE} STREQUAL ${VERSION})
  vcpkg_cmake_config_fixup(PACKAGE_NAME "urx" CONFIG_PATH
                           "lib/cmake/Urx-${VERSION}${suffix}")
else()
  file(GLOB ALL_VERSION_PATH "${CURRENT_PACKAGES_DIR}/lib/cmake/Urx-*${suffix}")
  foreach(dir ${ALL_VERSION_PATH})
    file(RELATIVE_PATH relative_dir ${CURRENT_PACKAGES_DIR} ${dir})
    vcpkg_cmake_config_fixup(PACKAGE_NAME "urx" CONFIG_PATH "${relative_dir}")
  endforeach()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/license")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/license")

# Don't delete debug/share. whl will be installed here. Need Python scripts for
# tests ?
set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")

if("matlab" IN_LIST FEATURES)
  if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)
  endif()
endif()
