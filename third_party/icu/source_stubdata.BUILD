# Custom BUILD for ICU 77.1 source/stubdata directory.
# Replaces the native BUILD.bazel via link_files in workspace.bzl.
#
# The native BUILD references //icu4c/source/common:headers which is
# the repo path, not the tarball path (//source/common:headers).
# This file fixes the dep path.

load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

cc_library(
    name = "stubdata",
    srcs = ["stubdata.cpp"],
    hdrs = ["stubdata.h"],
    includes = ["."],
    copts = [
        "-DU_COMMON_IMPLEMENTATION",
    ],
    deps = [
        "//source/common:headers",
    ],
)
