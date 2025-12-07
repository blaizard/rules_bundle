# rules_bundle

![Bazel](https://img.shields.io/badge/Bazel-Build-green)
![License](https://img.shields.io/github/license/blaizard/rules_bundle)
![CI](https://github.com/blaizard/rules_bundle/actions/workflows/ci.yml/badge.svg)

**A Bazel rule set to bundle executable targets and their runfiles into a single, distributable archive.**

`rules_bundle` solves the problem of distributing Bazel-built binaries. By default, Bazel binaries rely on a complex tree of runfiles (shared libraries, data dependencies, helper scripts) that are difficult to ship to another machine. This rule packs everything into a single file, either a standard `.tar.gz` or a self-extracting executable script, ensuring your application runs anywhere.

## Features

* **Hermetic Packing**: Bundles the binary and its entire runfiles tree.
* **Reproducible**: The generated bundles are reproducible.
* **Multiple Formats**:
    * `tar`: Standard tarball (e.g., `app.tar.gz`).
    * `binary`: Self-extracting Bash script. Runs the binary immediately upon execution.
* **Minimal Dependencies**: Uses standard dependencies available in most environments.

---

## Getting Started

### Bzlmod

Add the following to your `MODULE.bazel`:

```starlark
bazel_dep(name = "rules_bundle", version = "1.0.0")
```

### Usage

Load the rule in your `BUILD.bazel` file and wrap your existing binary target.

```starlark
load("@rules_bundle//:defs.bzl", "bundle_binary", "bundle_tar")

cc_binary(
    name = "server",
    srcs = ["main.cc"],
    data = ["config.json"],
)

# Creates 'server_bundle', a self-extracting executable.
bundle_binary(
    name = "server_bundle",
    executable = ":server",
)

# Creates 'server_bundle.tar.gz', a compressed archive containing the executable and all its runfiles.
bundle_tar(
    name = "server_bundle_tar_gz",
    compression = "gz",
    executables = {
        "/server": ":server",
    },
    output = "server_bundle.tar.gz",
)
```

## Alternatives

Here are a few other good alternatives:

- [rules_appimage](https://github.com/lalten/rules_appimage): If you are looking to distribute your application specifically as an AppImage, check out rules_appimage. It creates AppImage binaries (ELF + SquashFS) which typically rely on FUSE (Filesystem in Userspace) to mount the application at runtime.
- [par_binary](https://github.com/google/subpar): A formerly popular set of rules for creating self-contained .par (Python ARchive) executables.
- [rules_python](https://github.com/bazel-contrib/rules_python): The native py_binary rule can produce a zip file (often enabled via the `--build_python_zip` flag or the `python_zip_file` output group).

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

Build & Test
```bash
bazel test //...
```
