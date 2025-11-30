const std = @import("std");
const server = @import("server.zig");

pub fn main() !void {
    // Run the one-process-per-client blocking call server
    // try server.oneProcessPerClientBlockingCall();
    // Run the one-process-per-client unblocking call server
    try server.oneProcessPerClientUnBlockingCall();
}
