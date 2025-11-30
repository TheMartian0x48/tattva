const std = @import("std");
const Config = @import("config.zig").Config;

pub fn handleConnection(allocator: std.mem.Allocator, connection: std.net.Server.Connection, config: Config) !void {
    _ = allocator;
    _ = config;
    defer connection.stream.close();

    var buffer: [1024]u8 = undefined;
    const bytes_read = try connection.stream.read(&buffer);
    
    std.debug.print("Received {d} bytes\n", .{bytes_read});
    
    // Echo back for now
    _ = try connection.stream.write(buffer[0..bytes_read]);
}
