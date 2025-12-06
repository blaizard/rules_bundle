load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
load("@rules_shell//shell:sh_binary.bzl", "sh_binary")
load("//private:bundle_binary.bzl", "bundle_binary")
load("//private:bundle_tar.bzl", "bundle_tar")

sh_binary(
    name = "dummy",
    srcs = [
        "dummy.sh",
    ],
    data = [
        "dummy.txt",
    ],
)

bundle_tar(
    name = "empty_tar",
    compression = None,
    output = "empty.tar",
)

diff_test(
    name = "reproducible_empty_tar",
    file1 = ":empty.tar",
    file2 = "expected_empty.tar",
)

bundle_tar(
    name = "generate_tar",
    compression = None,
    executables = {
        "/a/b/c": ":dummy",
    },
    output = "generated.tar",
)

diff_test(
    name = "reproducible_tar",
    file1 = ":generated.tar",
    file2 = "expected.tar",
)

bundle_tar(
    name = "generate_tar_gz",
    compression = "gz",
    executables = {
        "/a/b/c": ":dummy",
    },
    output = "generated.tar.gz",
)

diff_test(
    name = "reproducible_tar_gz",
    file1 = ":generated.tar.gz",
    file2 = "expected.tar.gz",
)

bundle_binary(
    name = "binary",
    executable = ":dummy",
)

diff_test(
    name = "reproducible_binary",
    file1 = ":binary",
    file2 = "expected_binary",
)

genrule(
    name = "binary_output",
    outs = ["binary_output.txt"],
    tools = [":binary"],
    cmd = "./$(location :binary) > \"$@\"",
)

diff_test(
    name = "test_binary_output",
    file1 = ":binary_output.txt",
    file2 = "expected_binary_output.txt",
)