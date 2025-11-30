//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub const config = @import("config.zig");
pub const server = @import("server.zig");
pub const proxy = @import("proxy.zig");

test "basic test" {
    try std.testing.expect(true);
}
