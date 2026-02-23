# Custom BUILD for ICU 77.1 source/common directory.
# Replaces the native BUILD.bazel via link_files in workspace.bzl.
#
# The native ICU 77.1 BUILD only covers a subset of the library needed
# for Unicode data update tools. This file provides a monolithic icuuc
# target that compiles ALL source files, giving full ICU common
# functionality (including ucnv, udata, etc.) needed by TensorFlow.

load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

cc_library(
    name = "headers",
    hdrs = glob([
        "unicode/*.h",
        "*.h",
    ]),
    includes = ["."],
)

cc_library(
    name = "icuuc",
    srcs = glob(
        [
            "*.c",
            "*.cpp",
        ],
    ),
    hdrs = glob([
        "unicode/*.h",
        "*.h",
    ]),
    includes = ["."],
    copts = [
        "-DU_COMMON_IMPLEMENTATION",
        "-DU_HAVE_STD_ATOMICS",
    ] + select({
        "@platforms//os:android": [
            "-fdata-sections",
            "-DU_HAVE_NL_LANGINFO_CODESET=0",
            "-Wno-deprecated-declarations",
        ],
        "@platforms//os:macos": [
            "-Wno-shorten-64-to-32",
            "-Wno-unused-variable",
        ],
        "@platforms//os:ios": [
            "-Wno-shorten-64-to-32",
            "-Wno-unused-variable",
        ],
        "@platforms//os:windows": [
            "/utf-8",
            "/DLOCALE_ALLOW_NEUTRAL_NAMES=0",
        ],
        "//conditions:default": [],
    }),
    tags = ["requires-rtti"],
    deps = [
        "//source/stubdata",
    ],
)
