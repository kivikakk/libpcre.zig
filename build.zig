const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) !void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    _ = b.addModule("libpcre", .{
        .source_file = .{ .path = "src/main.zig" },
    });

    const lib = b.addStaticLibrary(.{
        .name = "libpcre.zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    try linkPcre(lib);
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .name = "main_tests",
        .root_source_file = .{ .path = "src/main.zig" },
        .optimize = optimize,
        .target = target,
    });
    try linkPcre(main_tests);

    const main_tests_run = b.addRunArtifact(main_tests);
    main_tests_run.step.dependOn(&main_tests.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests_run.step);
}

pub fn linkPcre(exe: *std.build.LibExeObjStep) !void {
    exe.linkLibC();
    if (builtin.os.tag == .windows) {
        try exe.addVcpkgPaths(.static);
    }
    exe.linkSystemLibrary("pcre");
}
