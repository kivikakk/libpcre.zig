const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("libpcre.zig", "src/main.zig");
    lib.setBuildMode(mode);
    lib.addIncludeDir("/usr/local/Cellar/pcre/8.44/include");
    lib.addLibPath("/usr/local/Cellar/pcre/8.44/lib");
    lib.linkSystemLibrary("pcre");
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.addIncludeDir("/usr/local/Cellar/pcre/8.44/include");
    main_tests.addLibPath("/usr/local/Cellar/pcre/8.44/lib");
    main_tests.linkSystemLibrary("pcre");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
