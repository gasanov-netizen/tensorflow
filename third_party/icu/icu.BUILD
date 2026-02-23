load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

licenses(["notice"])  # Apache 2.0

exports_files([
    "LICENSE",
])

# Headers-only target for consumers that only need ICU public headers.
# Delegates to the native ICU 77.1 headers target in source/common.
cc_library(
    name = "headers",
    deps = [
        "//source/common:headers",
    ],
)

# Full ICU common library (icuuc).
# Delegates to the monolithic icuuc target added via icu_monolithic.patch
# in source/common/BUILD.bazel, which compiles all source/common sources.
cc_library(
    name = "icuuc",
    deps = [
        "//source/common:icuuc",
    ],
)

# Aggregate common library target used by TensorFlow and TF Text.
# Provides both headers and the full icuuc implementation.
cc_library(
    name = "common",
    deps = [
        ":icuuc",
    ],
)

# NFKC normalization support.
# NFKC uses the normalizer2 engine compiled as part of the monolithic
# icuuc library, so this simply depends on :common.
cc_library(
    name = "nfkc",
    deps = [
        ":common",
    ],
)

# NFKC_Casefold normalization support.
# Also uses the normalizer2 engine from icuuc.
cc_library(
    name = "nfkc_cf",
    deps = [
        ":common",
    ],
)
