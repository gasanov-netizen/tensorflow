# Code that exposes C++ libraries to Python via pybind11.

load("//tensorflow_text:tftext.bzl", "if_pywrap", "pybind_extension", "pywrap_binaries", "pywrap_library")

licenses(["notice"])

package(default_visibility = [
    "//nlp/sage/nlu/features/python:__pkg__",
    "//nlp/semantic_parsing/learning/neural/portable/tools/release:__pkg__",
    "//tensorflow_text:__subpackages__",
])

pybind_extension(
    name = "tflite_registrar",
    srcs = [
        "tflite_registrar.cc",
    ],
    common_lib_packages = ["tensorflow/python"],
    deps = [
        # lite:framework tensorflow dep,
        # lite/c:common tensorflow dep,
        # lite/kernels:builtin_ops tensorflow dep,
        "//tensorflow_text/core/kernels:tflite_ops",
    ],
)

pybind_extension(
    name = "pywrap_fast_bert_normalizer_model_builder",
    srcs = ["pywrap_fast_bert_normalizer_model_builder.cc"],
    common_lib_packages = ["tensorflow/python"],
    copts = ["-fexceptions"],
    features = ["-use_header_modules"],
    deps = [
        "//tensorflow_text/core/kernels:fast_bert_normalizer_model_builder",
    ],
)

py_test(
    name = "pywrap_fast_bert_normalizer_model_builder_test",
    srcs = ["pywrap_fast_bert_normalizer_model_builder_test.py"],
    data = [
        "//tensorflow_text:python/ops/test_data/fast_bert_normalizer_model.fb",
        "//tensorflow_text:python/ops/test_data/fast_bert_normalizer_model_lower_case_nfd_strip_accents.fb",
    ],
    tags = [
        "-sickbay",  # Depends on ICU version.
    ],
    deps = [
        "@absl_py//absl/flags",
        "//tensorflow:tensorflow_py",  # tensorflow package dep
    ] + if_pywrap([
        "//tensorflow/python:_pywrap_tensorflow",
        ":pybinds_library",
    ]),
)

pybind_extension(
    name = "pywrap_fast_wordpiece_tokenizer_model_builder",
    srcs = ["pywrap_fast_wordpiece_tokenizer_model_builder.cc"],
    common_lib_packages = ["tensorflow/python"],
    copts = ["-fexceptions"],
    data = [
        "pywrap_fast_wordpiece_tokenizer_model_builder.pyi",
    ],
    features = ["-use_header_modules"],
    deps = [
        "//tensorflow_text/core/kernels:fast_wordpiece_tokenizer_model_builder",
    ],
)

py_test(
    name = "pywrap_fast_wordpiece_tokenizer_model_builder_test",
    srcs = ["pywrap_fast_wordpiece_tokenizer_model_builder_test.py"],
    data = [
        "//tensorflow_text:python/ops/test_data/fast_wordpiece_tokenizer_model.fb",
    ],
    deps = [
        "//tensorflow:tensorflow_py",  # tensorflow package dep
    ] + if_pywrap([
        "//tensorflow/python:_pywrap_tensorflow",
        ":pybinds_library",
    ]),
)

pybind_extension(
    name = "pywrap_phrase_tokenizer_model_builder",
    srcs = ["pywrap_phrase_tokenizer_model_builder.cc"],
    common_lib_packages = ["tensorflow/python"],
    copts = ["-fexceptions"],
    features = ["-use_header_modules"],
    visibility = [
        "//knowledge/cerebra/nlu/models/smartv2/input:__pkg__",
        "//tensorflow_text:__subpackages__",
    ],
    deps = [
        "//tensorflow_text/core/kernels:phrase_tokenizer_model_builder",
    ],
)

py_test(
    name = "pywrap_phrase_tokenizer_model_builder_test",
    srcs = ["pywrap_phrase_tokenizer_model_builder_test.py"],
    data = [
        "//tensorflow_text:python/ops/test_data/phrase_tokenizer_model_test.fb",
    ],
    deps = [
        "//tensorflow:tensorflow_py",  # tensorflow package dep
    ] + if_pywrap([
        "//tensorflow/python:_pywrap_tensorflow",
        ":pybinds_library",
    ]),
)

pybind_extension(
    name = "pywrap_model_converter",
    srcs = ["pywrap_model_converter.cc"],
    common_lib_packages = ["tensorflow/python"],
    copts = ["-fexceptions"],
    features = ["-use_header_modules"],
    deps = [
        "//tensorflow_text/core/kernels/sentencepiece:model_converter",
    ],
)

pybind_extension(
    name = "pywrap_whitespace_tokenizer_config_builder",
    srcs = ["pywrap_whitespace_tokenizer_config_builder.cc"],
    common_lib_packages = ["tensorflow/python"],
    copts = ["-fexceptions"],
    features = ["-use_header_modules"],
    deps = [
        "//tensorflow_text/core/kernels:whitespace_tokenizer_config_builder",
    ],
)

py_test(
    name = "pywrap_whitespace_tokenizer_config_builder_test",
    srcs = ["pywrap_whitespace_tokenizer_config_builder_test.py"],
    deps = [
        "//tensorflow:tensorflow_py",  # tensorflow package dep
    ] + if_pywrap([
        "//tensorflow/python:_pywrap_tensorflow",
        ":pybinds_library",
    ]),
)

pywrap_library(
    name = "pybinds_library",
    common_lib_def_files_or_filters = {
        "tensorflow_text/core/pybinds/libpybinds_library_common": ":_pybinds_library.def",
    },
    common_lib_filters = {
        "tensorflow/tensorflow_framework": select({
            "@org_tensorflow//tensorflow:windows": [],
            "//conditions:default": [
                "@org_tensorflow//tensorflow:tensorflow_framework_pywrap_filter",
            ],
        }),
        "tensorflow/tensorflow_cc": select({
            "@org_tensorflow//tensorflow:windows": [],
            "//conditions:default": ["@org_tensorflow//tensorflow:tensorflow_cc_pywrap_filter"],
        }),
    },
    common_lib_versions = {
        "tensorflow/tensorflow_framework": "2",
        "tensorflow/tensorflow_cc": "2",
    },
    common_lib_linkopts = {
        "tensorflow/tensorflow_framework": select({
            "@org_tensorflow//tensorflow:windows": [],
            "@org_tensorflow//tensorflow:macos": [
                "-lpthread",
                "-ldl",
                "-lm",
            ],
            "//conditions:default": [
                "-z defs",
                "-lpthread",
                "-ldl",
                "-lm",
            ],
        }),
        "tensorflow/tensorflow_cc": select({
            "@org_tensorflow//tensorflow:windows": [
                "-DEFAULTLIB:ws2_32.lib",
                "-DEFAULTLIB:advapi32.lib",
                "-DEFAULTLIB:crypt32.lib",
                "-DEFAULTLIB:Normaliz.lib",
                "-DEFAULTLIB:ntdll.lib",
            ],
            "@org_tensorflow//tensorflow:macos": [
                "-lpthread",
                "-ldl",
                "-lm",
            ],
            "//conditions:default": [
                "-lpthread",
                "-ldl",
                "-lm",
            ],
        }),
    },
    extra_deps = [
        "@icu//:common_with_data",
        "@flatbuffers",
        "@com_googlesource_code_re2//:re2",
        "//tensorflow/lite:framework",
        "//tensorflow/lite/kernels/shim:tflite_op_shim",
        "//tensorflow/lite/kernels/shim:tensor_view",
        "//tensorflow/lite:string_util",
    ],
    deps = [
        ":pywrap_fast_bert_normalizer_model_builder",
        ":pywrap_fast_wordpiece_tokenizer_model_builder",
        ":pywrap_model_converter",
        ":pywrap_phrase_tokenizer_model_builder",
        ":pywrap_whitespace_tokenizer_config_builder",
        ":tflite_registrar",
    ],
)

pywrap_binaries(
    name = "pybinds_binaries",
    dep = ":pybinds_library",
    visibility = ["//visibility:public"],
)
