"""Loads a lightweight subset of the ICU library for Unicode processing."""

load("//third_party:repo.bzl", "tf_http_archive", "tf_mirror_urls")

# NOTE: If you upgrade this, generate the data files by following the
# instructions in third_party/icu/data/BUILD

def repo():
    tf_http_archive(
        name = "icu",
        strip_prefix = "icu",
        sha256 = "588e431f77327c39031ffbb8843c0e3bc122c211374485fa87dc5f3faff24061",
        urls = tf_mirror_urls("https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz"),
        build_file = "//third_party/icu:icu.BUILD",
        system_build_file = "//third_party/icu:BUILD.system",
        patch_file = ["//third_party/icu:udata.patch"],
        link_files = {
            "//third_party/icu:source_common.BUILD": "source/common/BUILD.bazel",
            "//third_party/icu:source_stubdata.BUILD": "source/stubdata/BUILD.bazel",
        },
    )
