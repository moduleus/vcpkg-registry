vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE c73760198f086240a73364341b926d518c49fe90)
set(SHA1_VALUE
    7aee7d1e21722221db471b0634afa01e99c841283e0505b5ab658641eca9971f1ce60fc25db4a27c42c1c0fab417b17e7b9f363c520111542448ff56afc2db7b
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

set(VCPKG_REGISTRY_REF_VALUE 3db2857a7a15c9cc044c7bd387b4820156c7b6d9)
set(VCPKG_REGISTRY_SHA1_VALUE
    f66cd5b6d39f69233f95a5e484e92ad46bfcb40f4231a1f920b4943d2dea64017af2db163d9192f2fb71f7eac0c171115e2e8cc16d50827104a87907f9de5fa9
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
