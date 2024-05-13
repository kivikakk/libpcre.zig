# [libpcre.zig](https://github.com/kivikakk/libpcre.zig)

![Build status](https://github.com/kivikakk/libpcre.zig/workflows/build/badge.svg)

To use via the zig package manager:

```sh
$ zig fetch --save https://github.com/kivikakk/libpcre.zig/archive/<commit hash>.tar.gz
```

Then add the following to `build.zig` (system `pcre` will be linked against automatically):

```zig
const pcre_pkg = b.dependency("libpcre.zig", .{ .optimize = optimize, .target = target });
const pcre_mod = pcre_pkg.module("libpcre");
exe.root_module.addImport("pcre", pcre_mod);
```

To use as a vendored library, add the following to your `build.zig`:

```zig
const linkPcre = @import("vendor/libpcre.zig/build.zig").linkPcre;
try linkPcre(exe);
exe.addPackagePath("libpcre", "vendor/libpcre.zig/src/main.zig");
```

Supported operating systems:

* Linux: `apt install pkg-config libpcre3-dev`
* macOS: `brew install pkg-config pcre`
* ~~Windows: install [vcpkg](https://github.com/microsoft/vcpkg#quick-start-windows), `vcpkg integrate install`, `vcpkg install pcre --triplet x64-windows-static`~~

  Zig doesn't have vcpkg integration any more. Suggestions welcome!
