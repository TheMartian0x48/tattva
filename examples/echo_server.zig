const std = @import("std");
const server = @import("server");
const net = @import("net");

pub fn main() void {
    std.debug.print("Echo Server Example\n", .{});
    std.debug.print("===================\n\n", .{});

    server.init();
    net.init();
    std.debug.print("\nEcho server ready!\n", .{});
}
