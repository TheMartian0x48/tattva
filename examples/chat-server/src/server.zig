const std = @import("std");

const Client = struct {
    address: std.net.Address,
    allocator: std.mem.Allocator,
    stream: std.net.Stream,
    name: []const u8,
};

const ChatServer = struct {
    allocator: std.mem.Allocator,
    clients: std.ArrayList(Client),
    mutex: std.Thread.Mutex,
};

/// One process per client blocking call implementation.
/// This spawns a new thread for each connected client and uses blocking I/O.
pub fn oneProcessPerClientBlockingCall() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const port = 8888;

    // Setup server
    const address = try std.net.Address.parseIp("127.0.0.1", port);
    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    std.debug.print("Chat server listening on port {d}\n", .{port});
    std.debug.print("Connect with: telnet localhost {d}\n", .{port});

    var chatServer = ChatServer{
        .allocator = allocator,
        .clients = try std.ArrayList(Client).initCapacity(allocator, 1024),
        .mutex = std.Thread.Mutex{},
    };

    var count: u32 = 0;

    while (true) {
        const conn = server.accept() catch |err| {
            std.debug.print("Client connection failed: {any}\n", .{err});
            continue;
        };

        // Generate username
        var name_buf: [32]u8 = undefined;
        const name = try std.fmt.bufPrint(&name_buf, "user-{d}", .{count});
        const name_owned = try allocator.dupe(u8, name);

        const client = Client{
            .address = conn.address,
            .allocator = allocator,
            .stream = conn.stream,
            .name = name_owned,
        };
        count = count + 1;
        _ = try std.Thread.spawn(.{}, handleClient, .{ &chatServer, client });
    }

    // Cleanup (unreachable in infinite loop, but good practice)
    for (chatServer.clients.items) |client| {
        client.stream.close();
        allocator.free(client.name);
    }
}

fn handleClient(chatServer: *ChatServer, client: Client) !void {
    // Add client to the list
    chatServer.mutex.lock();
    try chatServer.clients.append(chatServer.allocator, client);
    chatServer.mutex.unlock();

    // Log connection
    std.debug.print("[SERVER] Client connected: {s} ({any})\n", .{ client.name, client.address });

    // Send welcome message
    var welcome_buf: [256]u8 = undefined;
    const welcome = try std.fmt.bufPrint(&welcome_buf, "Welcome to the chat server, {s}! Type your messages and press Enter.\n", .{client.name});
    try client.stream.writeAll(welcome);

    var buffer: [1024]u8 = undefined;

    // Handle incoming messages
    while (client.stream.read(&buffer)) |bytes_read| {
        if (bytes_read == 0) break;
        const msg = buffer[0..bytes_read];

        // Format message with sender name
        var formatted_buf: [2048]u8 = undefined;
        const formatted = std.fmt.bufPrint(&formatted_buf, "[{s}] {s}", .{ client.name, msg }) catch {
            // If formatting fails, just send original message
            broadcast(chatServer, msg, client.name);
            continue;
        };

        broadcast(chatServer, formatted, client.name);
    } else |_| {}

    // Cleanup
    client.stream.close();
    std.debug.print("[SERVER] Client disconnected: {s} ({any})\n", .{ client.name, client.address });

    // Remove client from list (fixed: only remove if found)
    chatServer.mutex.lock();
    defer chatServer.mutex.unlock();

    for (chatServer.clients.items, 0..) |c, i| {
        if (c.address.eql(client.address)) {
            // Free the name before removing
            client.allocator.free(c.name);
            _ = chatServer.clients.swapRemove(i);
            break;
        }
    }
}

fn broadcast(chatServer: *ChatServer, msg: []const u8, sender_name: []const u8) void {
    chatServer.mutex.lock();
    defer chatServer.mutex.unlock();

    for (chatServer.clients.items) |client| {
        // Don't send message back to sender
        if (std.mem.eql(u8, client.name, sender_name)) {
            continue;
        }

        // Send to other clients
        client.stream.writeAll(msg) catch |err| {
            std.debug.print("[ERROR] Failed to send to {s}: {any}\n", .{ client.name, err });
        };
    }
}

pub fn oneProcessPerClientNonBlockingCall() !void {}
