load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

licenses(["notice"])  # Apache 2.0

exports_files([
    "LICENSE",
])

cc_library(
    name = "headers",
    hdrs = glob(["source/common/unicode/*.h"]),
    includes = [
        "source/common",
    ],
    deps = [
    ],
)

cc_library(
    name = "common",
    hdrs = glob(["source/common/unicode/*.h"]),
    includes = [
        "source/common",
    ],
    deps = [
        ":icuuc",
    ],
)

cc_library(
    name = "icuuc",
    srcs = glob(
        [
            "source/common/**/*.c",
            "source/common/**/*.cpp",
            "source/stubdata/**/*.cpp",
        ],
    ),
    hdrs = glob([
        "source/common/*.h",
        "source/stubdata/**/*.h",
    ]),
    includes = [
        "source/stubdata",
    ],
    copts = [
        "-DU_COMMON_IMPLEMENTATION",
        "-DU_HAVE_STD_ATOMICS",  # TODO(gunan): Remove when TF is on ICU 64+.
    ] + select({
        ":android": [
            "-fdata-sections",
            "-DU_HAVE_NL_LANGINFO_CODESET=0",
            "-Wno-deprecated-declarations",
        ],
        ":apple": [
            "-Wno-shorten-64-to-32",
            "-Wno-unused-variable",
        ],
        ":windows": [
            "/utf-8",
            "/DLOCALE_ALLOW_NEUTRAL_NAMES=0",
        ],
        "//conditions:default": [],
    }),
    tags = ["requires-rtti"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":headers",
    ],
)

# Generates a C file from the full ICU data package (icudt77l.dat) that
# includes NFKC normalization tables, collation data, etc.  This replaces
# the empty stub embedded by @icu//:common and lets pybind extensions use the
# full ICU feature set without relying on libtensorflow_framework to export
# ICU symbols (it doesn't).
genrule(
    name = "gen_icudt77_full",
    srcs = ["source/data/in/icudt77l.dat"],
    outs = ["icudt77_full.c"],
    cmd = """
        xxd -i $(location source/data/in/icudt77l.dat) > $@ && \
        sed -i 's/[a-z_]*icudt77l_dat\\b/icudt77_dat/g' $@ && \
        sed -i 's/[a-z_]*icudt77l_dat_len\\b/icudt77_dat_len/g' $@
    """,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "icudt77_full_data",
    srcs = [":gen_icudt77_full"],
    # alwayslink ensures data is pulled into the .so even if no function
    # references icudt77_dat directly.
    alwayslink = True,
    # Allow the stub definition in icuuc to coexist; the linker will pick
    # the first one encountered (which is this full-data one since we list
    # it first in common_with_data deps).
    linkopts = select({
        "@platforms//os:windows": [],
        "//conditions:default": ["-Wl,--allow-multiple-definition"],
    }),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "common_with_data",
    hdrs = glob(["source/common/unicode/*.h"]),
    includes = [
        "source/common",
    ],
    visibility = ["//visibility:public"],
    deps = [
        # full data MUST come before icuuc (stubdata) in the dep list
        ":icudt77_full_data",
        ":icuuc",
    ],
)

# from an already-loaded shared library (e.g., libtensorflow_framework.so)
# rather than embedding the stub empty package.
cc_library(
    name = "icuuc_no_stub",
    srcs = glob(
        [
            "source/common/**/*.c",
            "source/common/**/*.cpp",
        ],
        exclude = ["source/common/stubdata/**"],
    ),
    hdrs = glob([
        "source/common/*.h",
    ]),
    includes = [
        "source/stubdata",
    ],
    copts = [
        "-DU_COMMON_IMPLEMENTATION",
        "-DU_HAVE_STD_ATOMICS",
    ] + select({
        ":android": [
            "-fdata-sections",
            "-DU_HAVE_NL_LANGINFO_CODESET=0",
            "-Wno-deprecated-declarations",
        ],
        ":apple": [
            "-Wno-shorten-64-to-32",
            "-Wno-unused-variable",
        ],
        ":windows": [
            "/utf-8",
            "/DLOCALE_ALLOW_NEUTRAL_NAMES=0",
        ],
        "//conditions:default": [],
    }),
    tags = ["requires-rtti"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":headers",
    ],
)

config_setting(
    name = "android",
    values = {"crosstool_top": "//external:android/crosstool"},
)

config_setting(
    name = "apple",
    values = {"cpu": "darwin"},
)

config_setting(
    name = "windows",
    values = {"cpu": "x64_windows"},
)

cc_library(
    name = "nfkc",
    deps = [
        ":common",
    ],
)


