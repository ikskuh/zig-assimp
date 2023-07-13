const std = @import("std");

const Assimp = @import("Sdk.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    var sdk = Assimp.init(b);

    var formats = Assimp.FormatSet.all;

    const dyn_ex = b.addExecutable(.{
        .name = "dynamic-example",
        .target = target,
        .optimize = optimize,
    });
    dyn_ex.addCSourceFile("src/example.cpp", &[_][]const u8{"-std=c++17"});
    dyn_ex.linkLibrary(sdk.createLibrary(.dynamic, formats, target, optimize));
    for (sdk.getIncludePaths()) |path| {
        dyn_ex.addIncludePath(path);
    }
    dyn_ex.linkLibC();
    dyn_ex.linkLibCpp();
    b.installArtifact(dyn_ex);

    const stat_ex = b.addExecutable(.{
        .name = "static-example",
        .target = target,
        .optimize = optimize,
    });
    stat_ex.addCSourceFile("src/example.cpp", &[_][]const u8{"-std=c++17"});
    sdk.addTo(stat_ex, .static, formats);
    stat_ex.linkLibC();
    stat_ex.linkLibCpp();
    b.installArtifact(stat_ex);
}
