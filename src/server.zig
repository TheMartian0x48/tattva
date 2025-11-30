const std = @import("std");
const Config = @import("config.zig").Config;
const proxy = @import("proxy.zig");
const Loop = @import("loop.zig").Loop;
const socket = @import("socket.zig");

pub const Server = struct {
    allocator: std.mem.Allocator,
    config: Config,
    loop: Loop,

    const ClientState = enum {
        READING_REQUEST,
        SENDING_RESPONSE,
        CLOSED,
    };

    const Client = struct {
        fd: std.os.fd_t,
        state: ClientState,
        // buffer: [4096]u8, // TODO: Add buffer
    };

    pub fn init(allocator: std.mem.Allocator, config: Config) Server {
        return Server{
            .allocator = allocator,
            .config = config,
            .loop = undefined, // TODO: Initialize loop
        };
    }

    pub fn start(self: *Server) !void {
        // TODO: Initialize loop
        // self.loop = try Loop.init();
        // defer self.loop.deinit();

        // TODO: Create listener socket
        // const listener_fd = try socket.bindAndListen(self.config.port);
        // try self.loop.add(listener_fd, .READ);

        std.debug.print("Listening on port {d}...\n", .{self.config.port});

        // TODO: Main event loop
        // while (true) {
        //     var events: [64]loop.Event = undefined;
        //     const n = try self.loop.wait(&events);
        //     for (events[0..n]) |event| {
        //         // Handle events
        //     }
        // }

        return error.NotImplemented;
    }
};
