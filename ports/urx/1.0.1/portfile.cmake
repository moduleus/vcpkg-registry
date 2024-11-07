vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE cd06c35793f01d087ad6bfb2bb7598b7e8f7cf4f)
set(SHA1_VALUE
    d81c1d1ca549fc3a85516f6ad3ed6fa159bd4db431a80c8539104e28bf0b6b32a58b90dd27e091224b8083322459258281fdc36e48a62d827db65067c1b4b6a9
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

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS ${FEATURE_OPTIONS})
vcpkg_cmake_install()

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

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")

if("matlab" IN_LIST FEATURES)
  if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)
  endif()
endif()
