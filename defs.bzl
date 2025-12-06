"""Public rules for the bundler."""

load("//private:bundle_binary.bzl", bundle_binary_ = "bundle_binary")
load("//private:bundle_tar.bzl", bundle_tar_ = "bundle_tar")

bundle_binary = bundle_binary_
bundle_tar = bundle_tar_
