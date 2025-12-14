const std = @import("std");
const server = @import("server");

pub fn main() void {
    std.debug.print("Hello World Example\n", .{});
    std.debug.print("===================\n\n", .{});

    server.init();
    std.debug.print("\nHello, World!\n", .{});
}
