const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const run_step = b.step("run", "Run the app.");
    const unit_test_step = b.step("unit-test", "Run the unit tests.");

    {
        const test_step = b.step("test", "Run the tests.");
        test_step.dependOn(unit_test_step);
    }

    const project_exe = b.addExecutable(.{
        .name = "project",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const project_install = b.addInstallArtifact(project_exe, .{});
    b.getInstallStep().dependOn(&project_install.step);

    const project_run = b.addRunArtifact(project_exe);
    project_run.step.dependOn(&project_install.step);
    run_step.dependOn(&project_run.step);
    if (b.args) |args| project_run.addArgs(args);

    const unit_test_exe = b.addTest(.{
        .name = "unit-test",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const unit_test_install = b.addInstallArtifact(unit_test_exe, .{});
    b.getInstallStep().dependOn(&unit_test_install.step);

    const unit_test_run = b.addRunArtifact(unit_test_exe);
    unit_test_run.step.dependOn(&unit_test_install.step);
    unit_test_step.dependOn(&unit_test_run.step);
}
