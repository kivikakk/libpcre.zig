const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("libpcre.zig", "src/main.zig");
    lib.setBuildMode(mode);
    lib.linkLibC();
    lib.linkSystemLibrary("libpcre");
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.linkLibC();
    main_tests.linkSystemLibrary("libpcre");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
