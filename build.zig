const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary("libpcre.zig", "src/main.zig");
    lib.setBuildMode(mode);
    lib.setTarget(target);
    deps.addAllTo(lib);
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    main_tests.setTarget(target);
    deps.addAllTo(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
