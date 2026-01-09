vcpkg_minimum_required(VERSION 2023-08-09)

set(REF_VALUE 0a7892919b11429ba1a377ba3f98d91e1e426c7f)
set(SHA1_VALUE 164e0d591abb3bfb61814b2bbd01d9f3a02984e6fe6282835c1b7a433afb50ce195edda6a7da0a526f34e75c15ed0ce6bcac81cbe95c7cf717cdac31197fd875
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

set(VCPKG_REGISTRY_REF_VALUE bd1864f76973e3b6b0685b7078a7fb2687ce0f96)
set(VCPKG_REGISTRY_SHA1_VALUE dc6919b7af7efbec2eb4b8d83999381a6f09d20777460d28834ae54e9892704a7ecf0c3c4bf57760fec6856dd525b43a3f8b40f44c9c84a774f11c4fa6741b18
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
