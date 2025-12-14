const std = @import("std");
const server = @import("server");
const rate_limit = @import("rate_limit");

pub fn main() void {
    std.debug.print("Benchmark Example\n", .{});
    std.debug.print("=================\n\n", .{});

    server.init();
    rate_limit.init();
    std.debug.print("\nBenchmark server ready!\n", .{});
}
