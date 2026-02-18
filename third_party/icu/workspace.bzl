"""Loads a lightweight subset of the ICU library for Unicode processing."""

load("//third_party:repo.bzl", "tf_mirror_urls")

# NOTE: If you upgrade this, generate the data files by following the
# instructions in third_party/icu/data/BUILD

def _icu_repo_impl(ctx):
    """Custom repository rule for ICU that removes nested BUILD.bazel files.

    ICU 77.1 ships with BUILD.bazel files inside source/common/,
    source/stubdata/, etc. These create Bazel package boundaries that
    prevent the root BUILD file's glob from finding source files.
    We delete them after extraction so our own icu.BUILD can glob
    across the entire source tree.
    """
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Delete nested BUILD.bazel files shipped in ICU 77.1 that create
    # package boundaries and block glob from the root BUILD file.
    nested_build_files = [
        "source/common/BUILD.bazel",
        "source/stubdata/BUILD.bazel",
        "source/i18n/BUILD.bazel",
        "source/tools/gennorm2/BUILD.bazel",
        "source/tools/toolutil/BUILD.bazel",
        "source/data/unidata/norm2/BUILD.bazel",
    ]
    for f in nested_build_files:
        ctx.delete(f)

    # Apply patches (e.g. udata.patch for ATTRIBUTE_WEAK and U_STATIC_IMPLEMENTATION).
    for patch_file in ctx.attr.patch_file:
        ctx.patch(ctx.path(Label(patch_file)), strip = 1)

    # Symlink our BUILD file into the repo root.
    ctx.delete("BUILD.bazel")
    ctx.delete("BUILD")
    ctx.symlink(ctx.path(Label(ctx.attr.build_file)), "BUILD.bazel")

_icu_repo = repository_rule(
    implementation = _icu_repo_impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "strip_prefix": attr.string(),
        "build_file": attr.string(mandatory = True),
        "patch_file": attr.string_list(default = []),
    },
)

def repo():
    _icu_repo(
        name = "icu",
        strip_prefix = "icu",
        sha256 = "588e431f77327c39031ffbb8843c0e3bc122c211374485fa87dc5f3faff24061",
        urls = tf_mirror_urls("https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz"),
        build_file = "//third_party/icu:icu.BUILD",
        patch_file = ["//third_party/icu:udata.patch"],
    )
