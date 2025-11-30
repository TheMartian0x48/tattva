const std = @import("std");
const os = std.os;

pub fn createNonBlocking() !os.fd_t {
    // TODO: Create a socket and set it to non-blocking mode
    return error.NotImplemented;
}

pub fn bindAndListen(port: u16) !os.fd_t {
    // TODO: Create socket, bind to port, and start listening
    _ = port;
    return error.NotImplemented;
}

pub fn accept(listener_fd: os.fd_t) !os.fd_t {
    // TODO: Accept a new connection in non-blocking mode
    _ = listener_fd;
    return error.NotImplemented;
}
