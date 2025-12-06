"""Bundle an executable into an self extractable binary."""

load("//private:bundle_tar.bzl", "bundle_tar")

def _bundle_binary_script_impl(ctx):
    args = ctx.actions.args()
    args.add("--output", ctx.outputs.executable)
    args.add("--entry-point", ctx.attr.bootstrap_script)
    if ctx.attr.compression:
        args.add("--compression", "gz")
    args.add(ctx.file.archive)

    ctx.actions.run(
        inputs = [ctx.file.archive],
        outputs = [ctx.outputs.executable],
        progress_message = "Bundling self extractable binary {}...".format(str(ctx.label)),
        arguments = [
            args,
            "--",
        ] + ctx.attr.arguments,
        executable = ctx.executable._archive_to_script,
    )

    return [DefaultInfo(
        executable = ctx.outputs.executable,
        files = depset([ctx.outputs.executable]),
    )]

_bundle_binary_script = rule(
    doc = "Bundle an archive into an executable script.",
    implementation = _bundle_binary_script_impl,
    attrs = {
        "archive": attr.label(
            doc = "The archive to be bundled.",
            allow_single_file = True,
        ),
        "arguments": attr.string_list(
            doc = "List of arguments to be embedded in the bootstrap script.",
        ),
        "bootstrap_script": attr.string(
            doc = "Entry point of the executable.",
        ),
        "compression": attr.bool(
            doc = "If the tarball is compressed or not.",
        ),
        "_archive_to_script": attr.label(
            default = Label("//private/python:archive_to_script"),
            cfg = "exec",
            executable = True,
        ),
    },
    executable = True,
)

def bundle_binary(name, executable, compression = True, bootstrap_script = ".bundle_binary_bootstrap", args = None, **kwargs):
    """Bundle a binary and its runfiles into self contained file.
    
    Args:
        name: The name of the rule.
        executable: The executable target to bundle.
        compression: Whether compression should be set or not.
        bootstrap_script: Entry point of the executable.
        args: List of arguments to be embedded in the bootstrap script.
    """

    archive_name = "{}.tar.gz".format(name) if compression else "{}.tar".format(name)
    bundle_tar(
        name = "{}.bundle".format(name),
        executables = {
            "": executable,
        },
        bootstrap_script = bootstrap_script,
        compression = "gz" if compression else None,
        output = archive_name,
    )

    _bundle_binary_script(
        name = name,
        bootstrap_script = bootstrap_script,
        compression = compression,
        archive = archive_name,
        arguments = args or [],
        **kwargs
    )
