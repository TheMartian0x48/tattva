const std = @import("std");
const os = std.os;

pub const EventType = enum {
    READ,
    WRITE,
};

pub const Event = struct {
    fd: os.fd_t,
    type: EventType,
};

pub const Loop = struct {
    kq: os.fd_t,

    pub fn init() !Loop {
        // TODO: Create kqueue file descriptor
        return error.NotImplemented;
    }

    pub fn deinit(self: *Loop) void {
        // TODO: Close kqueue file descriptor
        _ = self;
    }

    pub fn add(self: *Loop, fd: os.fd_t, eventType: EventType) !void {
        // TODO: Register interest in event for fd
        _ = self;
        _ = fd;
        _ = eventType;
        return error.NotImplemented;
    }

    pub fn wait(self: *Loop, events: []Event) !usize {
        // TODO: Wait for events and populate the events slice
        _ = self;
        _ = events;
        return error.NotImplemented;
    }
};
