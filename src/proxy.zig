const std = @import("std");
const Config = @import("config.zig").Config;

pub fn onRead(allocator: std.mem.Allocator, client: anytype) !void {
    // TODO: Read from client.fd
    // If request is complete, change state to SENDING_RESPONSE
    // Register interest in WRITE
    _ = allocator;
    _ = client;
    return error.NotImplemented;
}

pub fn onWrite(allocator: std.mem.Allocator, client: anytype) !void {
    // TODO: Write response to client.fd
    // If response is complete, close connection or reset state
    _ = allocator;
    _ = client;
    return error.NotImplemented;
}
