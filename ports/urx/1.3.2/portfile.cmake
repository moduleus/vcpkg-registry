vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE 4d97039487934352720abef29d6f9cec95bd305a)
set(SHA1_VALUE bd9243bb67bdc6e0fc927b8e4a46c86d90e0f142e502ff08a921263e106723705ba3bfbb45e6203aead4c2dca091f10ee96ac02f04b9d4a6a1f670353b80a428
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

set(VCPKG_REGISTRY_REF_VALUE bd64e329dcd525c25ad0e24fcdf356ed5ef1d3a0)
set(VCPKG_REGISTRY_SHA1_VALUE 623c48448ac68bacfd2ded4c75d6665cc70105f6178c86de7cd1e7dc5941f3a6caac101c8c3ef982ae61371e30a5874cd65fa2039d4c693350523191629018c1
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
