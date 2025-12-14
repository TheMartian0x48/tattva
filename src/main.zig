const std = @import("std");
const io = @import("io");
const uring = @import("uring");
const buffer = @import("buffer");
const net = @import("net");
const http_types = @import("http_types");
const http_parser = @import("http_parser");
const middleware = @import("middleware");
const router = @import("router");
const rate_limit = @import("rate_limit");
const server = @import("server");

pub fn main() void {
    std.debug.print("Tattva Demo Server\n", .{});
    std.debug.print("==================\n\n", .{});

    io.init();
    uring.init();
    buffer.init();
    net.init();
    http_types.init();
    http_parser.init();
    middleware.init();
    router.init();
    rate_limit.init();
    server.init();
}
