const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary("libpcre.zig", "src/main.zig");
    lib.setBuildMode(mode);
    lib.setTarget(target);
    try linkPcre(lib);
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    try linkPcre(main_tests);
    main_tests.setBuildMode(mode);
    main_tests.setTarget(target);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

pub fn linkPcre(exe: *std.build.LibExeObjStep) !void {
    exe.linkLibC();
    if (builtin.os.tag == .windows) {
        try exe.addVcpkgPaths(.static);
        exe.linkSystemLibrary("pcre");
    } else {
        exe.linkSystemLibrary("libpcre");
    }
}
