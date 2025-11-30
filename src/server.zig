const std = @import("std");
const Config = @import("config.zig").Config;
const proxy = @import("proxy.zig");

pub const Server = struct {
    allocator: std.mem.Allocator,
    config: Config,

    pub fn init(allocator: std.mem.Allocator, config: Config) Server {
        return Server{
            .allocator = allocator,
            .config = config,
        };
    }

    pub fn start(self: *Server) !void {
        const address = try std.net.Address.parseIp("127.0.0.1", self.config.port);
        var server = try address.listen(.{
            .reuse_address = true,
        });
        defer server.deinit();

        std.debug.print("Listening on port {d}...\n", .{self.config.port});

        while (true) {
            const connection = try server.accept();
            // TODO: Handle connection in a separate thread or async
            try proxy.handleConnection(self.allocator, connection, self.config);
        }
    }
};
