# Chat Server - Phase 1 Mini-Project

A simple TCP chat server to learn network programming basics.

## Project Goals

Learn the fundamentals of:
- TCP socket programming (bind, listen, accept)
- Managing multiple client connections
- Broadcasting messages between clients
- Handling client disconnections
- Basic command parsing

## Your Task

Implement a chat server by completing the TODOs in `src/main.zig`. The starter code provides structure and hints.

### Step-by-Step Guide

1. **Setup TCP Listener** (in `main()`)
   - Create a TCP socket listening on port 8888
   - Use `std.net.Address.parseIp()` and `.listen()`

2. **Accept Connections** (in `main()`)
   - Loop to accept incoming connections
   - Print connection info
   - Create a Client struct for each connection

3. **Define Client Struct**
   - Store: stream, address, name, allocator
   - Add `init()` and `deinit()` methods

4. **Handle Client Messages** (in `handleClient()`)
   - Read messages from client in a loop
   - Check for `/quit` command
   - Broadcast messages to other clients

5. **Implement Broadcasting** (in `broadcast()`)
   - Send message to all clients except sender
   - Handle write errors gracefully

6. **Add ChatServer Struct** (optional but recommended)
   - Manage list of connected clients
   - Use mutex for thread-safe access
   - Methods: `addClient()`, `removeClient()`, `broadcast()`

## Building

```bash
zig build
```

## Running

Start the server:
```bash
zig build run
```

The server will listen on `localhost:8888`.

## Testing

Connect multiple clients using telnet:

```bash
# Terminal 1
telnet localhost 8888

# Terminal 2
telnet localhost 8888

# Terminal 3
telnet localhost 8888
```

Type messages in any terminal and see them broadcast to others!

## Commands to Implement

- `/quit` - Disconnect from the server

## Learning Resources

- [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/) - Sections on sockets
- [Zig std.net documentation](https://ziglang.org/documentation/master/std/#std.net)
- [Zig by Example - TCP Server](https://zigbyexample.github.io/)

## Hints

### Creating a TCP Listener
```zig
const address = try std.net.Address.parseIp("127.0.0.1", 8888);
var server = try address.listen(.{ .reuse_address = true });
defer server.deinit();
```

### Accepting Connections
```zig
while (true) {
    const connection = try server.accept();
    // Handle connection...
}
```

### Reading from Client
```zig
var buffer: [1024]u8 = undefined;
const bytes_read = try stream.read(&buffer);
if (bytes_read == 0) break; // Connection closed
const message = buffer[0..bytes_read];
```

### Writing to Client
```zig
try stream.writeAll("Hello, client!\n");
```

## Challenges (After Basic Implementation)

1. **Multi-threading**: Handle each client in a separate thread
2. **Usernames**: Let clients set custom usernames
3. **Private Messages**: Implement `/msg <user> <message>`
4. **Chat Rooms**: Support multiple channels
5. **Message History**: Show last 10 messages to new clients
6. **Timestamps**: Add timestamps to messages

## Expected Time

- Basic implementation: 2-4 hours
- With challenges: 6-8 hours

## Debugging Tips

1. Use `std.debug.print()` liberally to see what's happening
2. Test with telnet - it shows raw TCP behavior
3. Kill telnet with Ctrl+C to test disconnect handling
4. Use `netstat -an | grep 8888` to see active connections

## Common Issues

**"Address already in use"**
- Wait a few seconds or change the port
- Make sure you're using `.reuse_address = true`

**Messages not appearing**
- Check if you're broadcasting correctly
- Ensure you're not sending to the sender

**Server crashes on disconnect**
- Handle errors in `stream.read()` and `stream.writeAll()`
- Use `catch` or `try` appropriately

## Next Steps

After completing this project:
- Move on to **Static File Server** (HTTP basics)
- Read about HTTP/1.1 protocol
- Understand request/response format

---

**Difficulty**: Beginner

**Prerequisites**: Basic Zig syntax, understanding of TCP/IP concepts

**What You'll Learn**: Network programming fundamentals that are essential for building Zoxy!
