const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    _ = b.addModule("libpcre", .{
        .root_source_file = .{ .path = "src/main.zig" },
    });

    const lib = b.addStaticLibrary(.{
        .name = "libpcre.zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    try linkPcre(b, lib);
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .name = "main_tests",
        .root_source_file = .{ .path = "src/main.zig" },
        .optimize = optimize,
        .target = target,
    });
    try linkPcre(b, main_tests);

    const main_tests_run = b.addRunArtifact(main_tests);
    main_tests_run.step.dependOn(&main_tests.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests_run.step);
}

pub fn linkPcre(b: *std.Build, exe: *std.Build.Step.Compile) !void {
    exe.linkLibC();
    if (builtin.os.tag == .windows) {
        try exe.addVcpkgPaths(.static);
    }
    if (builtin.os.tag == .macos) {
        // If `pkg-config libpcre` doesn't error, linkSystemLibrary("libpcre") will succeed.
        // If it errors, try "pcre", as either it will hit a .pc by that name, or the fallthru
        // `-lpcre` and standard includes will work.  (Or it's not installed.)
        var code: u8 = undefined;
        if (b.runAllowFail(&[_][]const u8{ "pkg-config", "libpcre" }, &code, .Inherit)) |_| {
            exe.linkSystemLibrary("libpcre");
        } else |_| {
            exe.linkSystemLibrary("pcre");
        }
    } else {
        exe.linkSystemLibrary("pcre");
    }
}
