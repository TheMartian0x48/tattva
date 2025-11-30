# Contributing to Zoxy

Thank you for your interest in contributing to Zoxy! This document provides guidelines for contributing to the project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/zoxy.git
   cd zoxy
   ```
3. **Set up the development environment**:
   ```bash
   zig build
   zig build test
   ```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Use descriptive branch names:
- `feature/http-parser` - New features
- `fix/connection-leak` - Bug fixes
- `docs/api-reference` - Documentation
- `refactor/router-logic` - Code refactoring

### 2. Make Your Changes

- Write clean, idiomatic Zig code
- Follow the project's code style
- Add tests for new functionality
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run all tests
zig build test

# Run the application
zig build run

# Run with specific configuration
zig build run -- --config config.yaml
```

### 4. Commit Your Changes

Write clear, descriptive commit messages:

```bash
git commit -m "feat: add HTTP/1.1 request parser

- Implement zero-copy parsing
- Add support for chunked encoding
- Include comprehensive tests"
```

**Commit Message Format**:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Adding or updating tests
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `chore:` - Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear description of changes
- Reference to related issues
- Screenshots/benchmarks if applicable

## Code Style Guidelines

### Zig Style

Follow the [Zig Style Guide](https://ziglang.org/documentation/master/#Style-Guide):

```zig
// Good: Clear naming, proper error handling
pub fn parseHttpRequest(allocator: std.mem.Allocator, data: []const u8) !Request {
    if (data.len == 0) return error.EmptyRequest;
    
    var request = Request.init(allocator);
    errdefer request.deinit();
    
    // Parse logic...
    return request;
}

// Bad: Unclear naming, no error handling
pub fn parse(a: std.mem.Allocator, d: []const u8) Request {
    var r = Request.init(a);
    // Parse logic...
    return r;
}
```

### Best Practices

1. **Memory Management**
   - Always use `defer` for cleanup
   - Use `errdefer` for error path cleanup
   - Prefer stack allocation when possible

2. **Error Handling**
   - Use Zig's error unions
   - Provide descriptive error types
   - Document error conditions

3. **Testing**
   - Write tests for all public APIs
   - Include edge cases and error conditions
   - Use descriptive test names

4. **Documentation**
   - Document all public functions
   - Include usage examples
   - Explain non-obvious design decisions

## Project Structure

```
zoxy/
├── src/
│   ├── main.zig           # Entry point
│   ├── server.zig         # TCP server
│   ├── proxy.zig          # Proxy logic
│   ├── config.zig         # Configuration
│   ├── router.zig         # Request routing
│   ├── http/              # HTTP protocol
│   ├── middleware/        # Middleware components
│   └── utils/             # Utility functions
├── docs/                  # Documentation
├── tests/                 # Integration tests
└── build.zig              # Build configuration
```

## Areas for Contribution

See [ROADMAP.md](ROADMAP.md) for planned features. Great starting points:

### Beginner-Friendly
- Documentation improvements
- Example configurations
- Unit tests for existing code
- Bug fixes

### Intermediate
- HTTP/1.1 parser implementation
- Configuration file parsing (YAML/TOML)
- Logging system
- Basic middleware (CORS, compression)

### Advanced
- Load balancing algorithms
- TLS/SSL support
- HTTP/2 implementation
- Performance optimizations

## Testing

### Unit Tests

Place tests in the same file as the code:

```zig
test "parseHttpRequest handles valid request" {
    const allocator = std.testing.allocator;
    const data = "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n";
    
    const request = try parseHttpRequest(allocator, data);
    defer request.deinit();
    
    try std.testing.expectEqualStrings("GET", request.method);
    try std.testing.expectEqualStrings("/", request.path);
}
```

### Integration Tests

Create integration tests in `tests/` directory:

```zig
// tests/proxy_test.zig
const std = @import("std");
const Server = @import("server").Server;

test "proxy forwards request to upstream" {
    // Setup test server
    // Send request
    // Verify response
}
```

### Benchmarks

Include benchmarks for performance-critical code:

```zig
test "benchmark HTTP parsing" {
    const allocator = std.testing.allocator;
    const data = "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n";
    
    var timer = try std.time.Timer.start();
    var i: usize = 0;
    while (i < 10000) : (i += 1) {
        const request = try parseHttpRequest(allocator, data);
        request.deinit();
    }
    const elapsed = timer.read();
    
    std.debug.print("Parsed 10000 requests in {}ns\n", .{elapsed});
}
```

## Performance Considerations

- Profile before optimizing
- Use `zig build -Doptimize=ReleaseFast` for benchmarks
- Consider memory allocation patterns
- Minimize syscalls in hot paths

## Documentation

### Code Documentation

```zig
/// Parses an HTTP/1.1 request from raw bytes.
///
/// Returns a Request struct containing parsed headers and body.
/// The caller owns the returned Request and must call deinit().
///
/// Errors:
/// - error.InvalidRequest: Malformed HTTP request
/// - error.OutOfMemory: Allocation failure
pub fn parseHttpRequest(allocator: std.mem.Allocator, data: []const u8) !Request {
    // Implementation
}
```

### Documentation Files

Update relevant docs when making changes:
- `README.md` - For user-facing changes
- `docs/ARCHITECTURE.md` - For architectural changes
- `docs/ROADMAP.md` - When completing roadmap items

## Community

- **Issues**: Report bugs or request features
- **Discussions**: Ask questions or share ideas
- **Pull Requests**: Submit your contributions

## License

By contributing to Zoxy, you agree that your contributions will be licensed under the GNU GPLv3 license.

## Questions?

Feel free to open an issue or discussion if you have questions about contributing!

---

**Happy Coding! 🚀**
