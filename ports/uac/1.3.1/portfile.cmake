vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE 8c12d80e8d9d3897ad900f941f5688af6f0f5b17)
set(SHA1_VALUE
    3eced4d9b83878e2410975bfc4d3ea3ad575bbe810efe6780285d2e5653bd6622497c94eb536ceeb80b963fdd0782e11e2e7a9e9a2455e0fc9696ef9dd81d0aa
)

vcpkg_from_github(
  OUT_SOURCE_PATH
  SOURCE_PATH
  REPO
  moduleus/uac
  REF
  ${REF_VALUE}
  SHA512
  ${SHA1_VALUE}
  HEAD_REF
  main)

set(VCPKG_REGISTRY_REF_VALUE 1f459854aa2858745c44008488857f8804a28c92)
set(VCPKG_REGISTRY_SHA1_VALUE
    db769148f24f5148a4b722f21b694d547517789435fc1544a2b8ee17829c1a3841abbc8c56ed7e52c0c3a932f89b31bf4152b13e0530f3d279eb321db0115d24
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
  vcpkg_cmake_config_fixup(PACKAGE_NAME "uac" CONFIG_PATH
                           "lib/cmake/Uac-${VERSION}${suffix}")
else()
  file(GLOB ALL_VERSION_PATH "${CURRENT_PACKAGES_DIR}/lib/cmake/Uac-*${suffix}")
  foreach(dir ${ALL_VERSION_PATH})
    file(RELATIVE_PATH relative_dir ${CURRENT_PACKAGES_DIR} ${dir})
    vcpkg_cmake_config_fixup(PACKAGE_NAME "uac" CONFIG_PATH "${relative_dir}")
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
