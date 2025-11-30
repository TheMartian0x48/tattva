const std = @import("std");

pub const Config = struct {
    port: u16,
    target_url: []const u8,
};

pub fn load(allocator: std.mem.Allocator) !Config {
    _ = allocator;
    // TODO: Load from file or env
    return Config{
        .port = 8080,
        .target_url = "http://example.com",
    };
}
