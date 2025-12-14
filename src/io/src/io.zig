const std = @import("std");

/// IO module - placeholder for I/O operations
pub fn init() void {
    std.debug.print("This is io\n", .{});
}

test "io module" {
    init();
}
