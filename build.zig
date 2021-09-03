const std = @import("std");

const Assimp = @import("Sdk.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    var sdk = Assimp.init(b);

    const formats = Assimp.FormatSet.all
        .remove(.XGL)
        .remove(.X)
        .remove(.Unreal)
        .remove(.OFF)
        .remove(.Obj)
        .remove(.Assbin)
        .remove(.Assxml)
        .remove(.Blender)
        .remove(.glTF)
        .remove(.glTF2)
        .remove(.FBX)
        .remove(.IFC)
        .remove(.OpenGEX)
        .remove(.Q3BSP)
        .remove(.C4D);

    const dyn_ex = b.addExecutable("dynamic-example", null);
    dyn_ex.setBuildMode(mode);
    dyn_ex.addCSourceFile("src/example.cpp", &[_][]const u8{"-std=c++17"});
    dyn_ex.linkLibrary(sdk.createLibrary(.dynamic, formats));
    for (sdk.getIncludePaths()) |path| {
        dyn_ex.addIncludeDir(path);
    }
    dyn_ex.linkLibC();
    dyn_ex.linkLibCpp();
    dyn_ex.install();

    const stat_ex = b.addExecutable("static-example", null);
    stat_ex.setBuildMode(mode);
    stat_ex.addCSourceFile("src/example.cpp", &[_][]const u8{"-std=c++17"});
    sdk.addTo(stat_ex, .static, formats);
    stat_ex.linkLibC();
    stat_ex.linkLibCpp();
    stat_ex.install();
}
