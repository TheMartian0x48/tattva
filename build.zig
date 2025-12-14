const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create modules for each component
    const io_mod = b.addModule("io", .{
        .root_source_file = b.path("src/io/src/io.zig"),
        .target = target,
    });

    const uring_mod = b.addModule("uring", .{
        .root_source_file = b.path("src/uring/src/uring.zig"),
        .target = target,
    });

    const buffer_mod = b.addModule("buffer", .{
        .root_source_file = b.path("src/buffer/src/buffer.zig"),
        .target = target,
    });

    const net_mod = b.addModule("net", .{
        .root_source_file = b.path("src/net/src/net.zig"),
        .target = target,
    });

    const http_types_mod = b.addModule("http_types", .{
        .root_source_file = b.path("src/http_types/src/http_types.zig"),
        .target = target,
    });

    const http_parser_mod = b.addModule("http_parser", .{
        .root_source_file = b.path("src/http_parser/src/http_parser.zig"),
        .target = target,
    });

    const middleware_mod = b.addModule("middleware", .{
        .root_source_file = b.path("src/middleware/src/middleware.zig"),
        .target = target,
    });

    const router_mod = b.addModule("router", .{
        .root_source_file = b.path("src/router/src/router.zig"),
        .target = target,
    });

    const rate_limit_mod = b.addModule("rate_limit", .{
        .root_source_file = b.path("src/rate_limit/src/rate_limit.zig"),
        .target = target,
    });

    const server_mod = b.addModule("server", .{
        .root_source_file = b.path("src/server/src/server.zig"),
        .target = target,
    });

    // Main executable (demo)
    const exe = b.addExecutable(.{
        .name = "tattva-demo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("io", io_mod);
    exe.root_module.addImport("uring", uring_mod);
    exe.root_module.addImport("buffer", buffer_mod);
    exe.root_module.addImport("net", net_mod);
    exe.root_module.addImport("http_types", http_types_mod);
    exe.root_module.addImport("http_parser", http_parser_mod);
    exe.root_module.addImport("middleware", middleware_mod);
    exe.root_module.addImport("router", router_mod);
    exe.root_module.addImport("rate_limit", rate_limit_mod);
    exe.root_module.addImport("server", server_mod);
    b.installArtifact(exe);

    // Run command for demo
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the demo server");
    run_step.dependOn(&run_cmd.step);

    // Examples
    const examples = [_]struct { name: []const u8, path: []const u8 }{
        .{ .name = "hello_world", .path = "examples/hello_world.zig" },
        .{ .name = "echo_server", .path = "examples/echo_server.zig" },
        .{ .name = "benchmark", .path = "examples/benchmark.zig" },
    };

    for (examples) |example| {
        const example_exe = b.addExecutable(.{
            .name = example.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.path),
                .target = target,
                .optimize = optimize,
            }),
        });
        example_exe.root_module.addImport("io", io_mod);
        example_exe.root_module.addImport("uring", uring_mod);
        example_exe.root_module.addImport("buffer", buffer_mod);
        example_exe.root_module.addImport("net", net_mod);
        example_exe.root_module.addImport("http_types", http_types_mod);
        example_exe.root_module.addImport("http_parser", http_parser_mod);
        example_exe.root_module.addImport("middleware", middleware_mod);
        example_exe.root_module.addImport("router", router_mod);
        example_exe.root_module.addImport("rate_limit", rate_limit_mod);
        example_exe.root_module.addImport("server", server_mod);

        const install_example = b.addInstallArtifact(example_exe, .{});
        const example_step = b.step(
            b.fmt("example-{s}", .{example.name}),
            b.fmt("Build and install the {s} example", .{example.name}),
        );
        example_step.dependOn(&install_example.step);

        const run_example = b.addRunArtifact(example_exe);
        const run_example_step = b.step(
            b.fmt("run-{s}", .{example.name}),
            b.fmt("Run the {s} example", .{example.name}),
        );
        run_example_step.dependOn(&run_example.step);
    }

    // Tests
    const test_step = b.step("test", "Run all tests");

    const modules = [_]struct { name: []const u8, mod: *std.Build.Module }{
        .{ .name = "io", .mod = io_mod },
        .{ .name = "uring", .mod = uring_mod },
        .{ .name = "buffer", .mod = buffer_mod },
        .{ .name = "net", .mod = net_mod },
        .{ .name = "http_types", .mod = http_types_mod },
        .{ .name = "http_parser", .mod = http_parser_mod },
        .{ .name = "middleware", .mod = middleware_mod },
        .{ .name = "router", .mod = router_mod },
        .{ .name = "rate_limit", .mod = rate_limit_mod },
        .{ .name = "server", .mod = server_mod },
    };

    for (modules) |module| {
        const unit_tests = b.addTest(.{
            .root_module = module.mod,
        });

        const run_unit_tests = b.addRunArtifact(unit_tests);
        test_step.dependOn(&run_unit_tests.step);
    }
}
