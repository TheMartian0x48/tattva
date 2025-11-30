const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const num_clients = 5;
    var threads = try std.ArrayList(std.Thread).initCapacity(allocator, num_clients);
    defer threads.deinit();

    std.debug.print("Spawning {} clients to test chat server...\n", .{num_clients});
    std.debug.print("Make sure the chat server is running on port 8888!\n\n", .{});

    var i: usize = 0;
    while (i < num_clients) : (i += 1) {
        const thread = try std.Thread.spawn(.{}, clientThread, .{i});
        try threads.append(allocator, thread);
        std.time.sleep(100 * std.time.ns_per_ms); // Stagger connections
    }

    for (threads.items) |thread| {
        thread.join();
    }

    std.debug.print("\n✓ All clients completed successfully!\n", .{});
}

fn clientThread(id: usize) !void {
    const address = try std.net.Address.parseIp("127.0.0.1", 8888);
    const stream = try std.net.tcpConnectToAddress(address);
    defer stream.close();

    std.debug.print("Client {} connected\n", .{id});

    // Read welcome message
    var buffer: [100]u8 = undefined;
    const bytes_read = stream.read(&buffer) catch |err| {
        std.debug.print("Client {} failed to read welcome: {}\n", .{ id, err });
        return;
    };

    if (bytes_read > 0) {
        std.debug.print("Client {} received: {s}", .{ id, buffer[0..bytes_read] });
    }

    // Send a few messages
    var msg_count: usize = 0;
    while (msg_count < 3) : (msg_count += 1) {
        var msg_buf: [100]u8 = undefined;
        const msg = try std.fmt.bufPrint(&msg_buf, "Message {} from client {}\n", .{ msg_count, id });
        try stream.writeAll(msg);
        std.debug.print("Client {} sent: {s}", .{ id, msg });
        std.time.sleep(500 * std.time.ns_per_ms);
    }

    std.time.sleep(1 * std.time.ns_per_s);
    std.debug.print("Client {} disconnecting\n", .{id});
}
