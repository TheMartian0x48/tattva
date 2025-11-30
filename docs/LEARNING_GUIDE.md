# Learning Guide for Zoxy Development

This document provides a structured learning path for building Zoxy from the ground up. Each section includes recommended reading, key concepts, and a progressive implementation approach.

---

## How to Use This Guide

1. **Read** the recommended resources for each topic
2. **Understand** the key concepts before coding
3. **Implement** features incrementally
4. **Test** thoroughly at each step
5. **Iterate** and refine based on learnings

---

## Phase 1: Foundation

### 1.1 Non-Blocking I/O & Event Loops
 
 **Key Concepts**:
 - Blocking vs Non-blocking Sockets
 - I/O Multiplexing (`kqueue`, `epoll`)
 - Event Loops
 - State Machines
 
 **Reading List**:
 - [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/) - Focus on `select()`/`poll()` sections
 - [The C10K Problem](http://www.kegel.com/c10k.html) - Why threads don't scale
 - [Kqueue Tutorial](https://wiki.netbsd.org/tutorials/kqueue_tutorial/) (for macOS/BSD)
 
 **Progressive Implementation**:
 1. Create a `kqueue` wrapper (`src/loop.zig`)
 2. Create a non-blocking socket listener
 3. Implement an event loop to accept connections
 4. Handle read/write events using a state machine
 
 **Files to Create/Modify**:
 - `src/loop.zig` - Event loop wrapper
 - `src/socket.zig` - Socket helpers
 - `src/server.zig` - Event-driven server
 
 **Practical Mini-Project**: 🎯
 
 **Project**: Build a "Single-Threaded Chat Server"
 - Accept multiple client connections using `kqueue`
 - Store active clients in a list/map
 - Broadcast messages to all clients when one writes
 - **Constraint**: Do NOT use `std.Thread.spawn`
 
 **Why**: This forces you to understand how Nginx and Node.js work under the hood.
 
 **Time**: 4-6 hours

---

### 1.2 HTTP/1.1 Protocol

**Key Concepts**:
- HTTP request/response format
- Headers, methods, status codes
- Chunked transfer encoding
- Keep-alive connections

**Reading List**:
- [RFC 7230 - HTTP/1.1 Message Syntax](https://tools.ietf.org/html/rfc7230)
- [MDN HTTP Overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [HTTP Made Really Easy](https://www.jmarshall.com/easy/http/)

**Progressive Implementation**:
1. Parse HTTP request line (method, path, version)
2. Parse HTTP headers (key-value pairs)
3. Handle request body (Content-Length)
4. Build HTTP response (status line, headers, body)
5. Implement chunked encoding

**Files to Create/Modify**:
- `src/http/parser.zig` - HTTP parser
- `src/http/request.zig` - Request struct
- `src/http/response.zig` - Response struct
- `tests/http_parser_test.zig` - Parser tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Static File Server"
- Parse HTTP GET requests
- Serve files from a directory
- Return proper status codes (200, 404, 500)
- Add Content-Type headers based on file extension
- Support Range requests for partial content

**Why**: You'll deeply understand HTTP request/response format and header handling.

**Time**: 4-6 hours

---

### 1.3 Basic Reverse Proxy

**Key Concepts**:
- Request forwarding
- Response streaming
- Connection pooling
- Error handling

**Reading List**:
- [What is a Reverse Proxy?](https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/)
- [Nginx Architecture](https://www.aosabook.org/en/nginx.html)
- Study existing proxies: Nginx, HAProxy documentation

**Progressive Implementation**:
1. Forward HTTP request to single upstream server
2. Stream response back to client
3. Handle upstream connection failures
4. Implement basic retry logic
5. Add connection pooling

**Files to Create/Modify**:
- `src/proxy.zig` - Proxy handler
- `src/upstream.zig` - Upstream connection management
- `tests/proxy_test.zig` - Proxy tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Request Logger Proxy"
- Forward all requests to a target server (e.g., httpbin.org)
- Log request method, path, headers to console
- Log response status code and size
- Add request/response timing
- Handle connection errors with retry (max 3 attempts)

**Why**: This is your first real proxy! You'll learn request forwarding and error handling.

**Time**: 3-5 hours

---

### 1.4 Configuration Management

**Key Concepts**:
- Configuration file formats (YAML, TOML, JSON)
- Configuration validation
- Hot reloading
- Environment variables

**Reading List**:
- [YAML Specification](https://yaml.org/spec/)
- [TOML Specification](https://toml.io/en/)
- Zig libraries: Look for YAML/TOML parsers

**Progressive Implementation**:
1. Define configuration struct
2. Parse YAML/TOML file
3. Validate configuration (required fields, types)
4. Support environment variable overrides
5. Implement hot reload (watch file changes)

**Files to Create/Modify**:
- `src/config.zig` - Configuration management
- `config.example.yaml` - Example configuration
- `tests/config_test.zig` - Config tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Config-Driven App Launcher"
- Read YAML/JSON config with app definitions
- Each app has: name, command, args, env vars
- Validate config (required fields, valid paths)
- Launch apps based on config
- Support hot-reload: watch config file, restart apps on change

**Why**: Learn config parsing, validation, and file watching - essential for production software.

**Time**: 3-4 hours

---

## Phase 2: Core Features

### 2.1 Load Balancing

**Key Concepts**:
- Load balancing algorithms
- Health checking
- Failover strategies
- Sticky sessions

**Reading List**:
- [Load Balancing Algorithms](https://www.nginx.com/blog/choosing-nginx-plus-load-balancing-techniques/)
- [Health Checks in HAProxy](https://www.haproxy.com/documentation/hapee/latest/load-balancing/health-checking/)
- [Consistent Hashing](https://en.wikipedia.org/wiki/Consistent_hashing)

**Progressive Implementation**:
1. Implement round-robin algorithm
2. Add least connections algorithm
3. Implement IP hash (consistent hashing)
4. Add health checks (active probing)
5. Implement automatic failover
6. Add weighted load balancing

**Files to Create/Modify**:
- `src/loadbalancer.zig` - Load balancer
- `src/health_check.zig` - Health checking
- `tests/loadbalancer_test.zig` - LB tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Multi-Backend Load Balancer"
- Start 3 simple HTTP servers on different ports (use your file server)
- Implement round-robin selection
- Add health checks: ping `/health` every 5 seconds
- Mark unhealthy backends and skip them
- Automatically re-add when healthy
- Track request count per backend

**Why**: Understand load balancing algorithms and health checking in practice.

**Time**: 4-6 hours

---

### 2.2 TLS/SSL Support

**Key Concepts**:
- TLS handshake
- Certificate management
- SNI (Server Name Indication)
- Cipher suites

**Reading List**:
- [TLS 1.3 RFC 8446](https://tools.ietf.org/html/rfc8446)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [Let's Encrypt - How It Works](https://letsencrypt.org/how-it-works/)
- [High Performance Browser Networking - TLS](https://hpbn.co/transport-layer-security-tls/)

**Progressive Implementation**:
1. Add TLS termination (accept HTTPS)
2. Load certificates from files
3. Implement SNI support
4. Add TLS to upstream connections
5. Integrate Let's Encrypt (ACME protocol)
6. Implement mTLS (mutual TLS)

**Files to Create/Modify**:
- `src/tls.zig` - TLS handling
- `src/cert_manager.zig` - Certificate management
- `tests/tls_test.zig` - TLS tests

**Practical Mini-Project**: 🎯

**Project**: Build an "HTTPS File Server"
- Generate self-signed certificate (use openssl)
- Modify your file server to accept HTTPS connections
- Implement TLS termination
- Support both HTTP and HTTPS on different ports
- Add certificate validation logging

**Why**: Hands-on experience with TLS/SSL before adding it to the proxy.

**Time**: 3-5 hours

---

### 2.3 Advanced Routing

**Key Concepts**:
- Trie data structure
- Regular expressions
- URL rewriting
- Header manipulation

**Reading List**:
- [Trie Data Structure](https://en.wikipedia.org/wiki/Trie)
- [Regular Expressions Tutorial](https://www.regular-expressions.info/)
- [URL Rewriting Best Practices](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)

**Progressive Implementation**:
1. Implement path-based routing (exact match)
2. Add prefix matching (e.g., `/api/*`)
3. Implement host-based routing
4. Add header-based routing
5. Implement URL rewriting
6. Add regex pattern matching

**Files to Create/Modify**:
- `src/router.zig` - Request router
- `src/route.zig` - Route definition
- `tests/router_test.zig` - Router tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Multi-Service Router"
- Route `/api/*` to backend service on port 3000
- Route `/static/*` to file server on port 8080
- Route `/admin/*` to admin service on port 9000
- Implement path rewriting: `/api/users` → `/users`
- Add host-based routing: `api.example.com` → port 3000
- Support wildcard patterns and regex

**Why**: Master routing logic and URL manipulation before production use.

**Time**: 4-6 hours

---

## Phase 3: Performance & Scalability

### 3.1 Advanced Async I/O (io_uring)

**Key Concepts**:
- Ring buffers
- Submission Queue (SQ) & Completion Queue (CQ)
- Zero-copy networking
- Kernel-bypass techniques

**Reading List**:
- [Lord of the io_uring](https://unixism.net/loti/)
- [Efficient IO with io_uring](https://kernel.dk/io_uring.pdf)

**Progressive Implementation**:
1. Implement `io_uring` backend for Linux (alongside `kqueue`)
2. Benchmark `io_uring` vs `epoll`/`kqueue`
3. Implement zero-copy writes (`SPLICE`)

**Files to Create/Modify**:
- `src/loop_linux.zig` - io_uring implementation

**Practical Mini-Project**: 🎯

**Project**: Build a "High-Performance File Server"
- Use `io_uring` to serve files
- Compare throughput with standard `read`/`write`

---

### 3.2 HTTP Caching

**Key Concepts**:
- Cache-Control headers
- ETag and Last-Modified
- Cache invalidation
- LRU eviction

**Reading List**:
- [RFC 7234 - HTTP Caching](https://tools.ietf.org/html/rfc7234)
- [Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)
- [LRU Cache Implementation](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU))

**Progressive Implementation**:
1. Implement in-memory cache (HashMap)
2. Respect Cache-Control headers
3. Implement ETag validation
4. Add LRU eviction policy
5. Implement cache invalidation API
6. Add cache statistics

**Files to Create/Modify**:
- `src/cache.zig` - Cache implementation
- `src/cache_policy.zig` - Cache policies
- `tests/cache_test.zig` - Cache tests

**Practical Mini-Project**: 🎯

**Project**: Build a "Caching Proxy Server"
- Cache GET responses in memory (HashMap)
- Respect Cache-Control: max-age, no-cache, no-store
- Implement ETag validation (If-None-Match)
- Add LRU eviction (max 100 items)
- Provide cache stats endpoint: hit rate, size, entries
- Support cache invalidation via DELETE requests

**Why**: Learn caching strategies and HTTP cache semantics hands-on.

**Time**: 5-7 hours

---

### 3.3 HTTP/2 Support

**Key Concepts**:
- Binary framing
- Multiplexing
- Server push
- Flow control

**Reading List**:
- [RFC 7540 - HTTP/2](https://tools.ietf.org/html/rfc7540)
- [HTTP/2 Explained](https://http2-explained.haxx.se/)
- [High Performance Browser Networking - HTTP/2](https://hpbn.co/http2/)

**Progressive Implementation**:
1. Implement HTTP/2 frame parsing
2. Add stream multiplexing
3. Implement flow control
4. Add server push capability
5. Implement HPACK compression

**Files to Create/Modify**:
- `src/http2/frame.zig` - HTTP/2 frames
- `src/http2/stream.zig` - Stream management
- `src/http2/hpack.zig` - HPACK compression

**Practical Mini-Project**: 🎯

**Project**: Build an "HTTP/2 Frame Parser"
- Parse HTTP/2 binary frames from raw bytes
- Support HEADERS, DATA, SETTINGS frames
- Implement HPACK header compression/decompression
- Create a simple HTTP/2 client that sends requests
- Visualize frame flow (print frame types and sizes)

**Why**: HTTP/2 is complex - start with parsing before full implementation.

**Time**: 8-10 hours (this is advanced!)

---

## Phase 4: Production Features

### 4.1 Observability

**Key Concepts**:
- Structured logging
- Metrics collection
- Distributed tracing
- Prometheus format

**Reading List**:
- [The Twelve-Factor App - Logs](https://12factor.net/logs)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [OpenTelemetry Specification](https://opentelemetry.io/docs/)
- [Distributed Tracing](https://microservices.io/patterns/observability/distributed-tracing.html)

**Progressive Implementation**:
1. Implement structured logging (JSON)
2. Add log levels and filtering
3. Collect basic metrics (request count, latency)
4. Export Prometheus metrics
5. Implement distributed tracing
6. Add real-time dashboard

**Files to Create/Modify**:
- `src/logging.zig` - Logging system
- `src/metrics.zig` - Metrics collection
- `src/tracing.zig` - Distributed tracing

**Practical Mini-Project**: 🎯

**Project**: Build a "Metrics Dashboard Server"
- Collect metrics: request count, latency, errors
- Export Prometheus format at `/metrics`
- Implement structured JSON logging
- Add request tracing with correlation IDs
- Create simple HTML dashboard showing live metrics
- Support log levels: DEBUG, INFO, WARN, ERROR

**Why**: Observability is critical for production - learn to instrument code properly.

**Time**: 5-7 hours

---

### 4.2 Security Features

**Key Concepts**:
- Rate limiting algorithms
- DDoS mitigation
- Input validation
- Security headers

**Reading List**:
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Rate Limiting Strategies](https://cloud.google.com/architecture/rate-limiting-strategies-techniques)
- [Security Headers](https://securityheaders.com/)
- [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)

**Progressive Implementation**:
1. Implement rate limiting (token bucket)
2. Add IP allowlist/blocklist
3. Implement request size limits
4. Add security headers injection
5. Implement basic WAF rules

**Files to Create/Modify**:
- `src/rate_limiter.zig` - Rate limiting
- `src/security.zig` - Security features
- `src/waf.zig` - WAF rules

**Practical Mini-Project**: 🎯

**Project**: Build a "Security Gateway"
- Implement token bucket rate limiter (100 req/min per IP)
- Add IP allowlist/blocklist
- Validate request size limits (max 1MB)
- Inject security headers (X-Frame-Options, CSP, etc.)
- Block common attack patterns (SQL injection in query params)
- Log security events to separate file

**Why**: Security is non-negotiable in production - practice defense in depth.

**Time**: 4-6 hours

---

## Additional Resources

### Books
- **"Computer Networking: A Top-Down Approach"** by Kurose & Ross
- **"High Performance Browser Networking"** by Ilya Grigorik (free online)
- **"The Linux Programming Interface"** by Michael Kerrisk
- **"Designing Data-Intensive Applications"** by Martin Kleppmann

### Online Courses
- [MIT 6.824: Distributed Systems](https://pdos.csail.mit.edu/6.824/)
- [Stanford CS144: Introduction to Computer Networking](https://cs144.github.io/)

### Reference Implementations
- [Nginx Source Code](https://github.com/nginx/nginx)
- [HAProxy Source Code](https://github.com/haproxy/haproxy)
- [Envoy Proxy](https://github.com/envoyproxy/envoy)

### Zig-Specific Resources
- [Zig Language Reference](https://ziglang.org/documentation/master/)
- [Zig Standard Library](https://ziglang.org/documentation/master/std/)
- [Zig Learn](https://ziglearn.org/)

---

## Learning Tips

1. **Start Small**: Don't try to implement everything at once
2. **Test Continuously**: Write tests as you go
3. **Read Code**: Study how Nginx and HAProxy solve problems
4. **Benchmark**: Measure performance at each phase
5. **Document**: Write down what you learn
6. **Ask Questions**: Join Zig community, ask for help
7. **Iterate**: Refactor as you learn better approaches

---

## Milestones & Checkpoints

After each phase, you should be able to:

**Phase 1**: Run a basic HTTP reverse proxy that forwards requests
**Phase 2**: Load balance across multiple upstreams with TLS
**Phase 3**: Handle 10K+ req/s with low latency
**Phase 4**: Deploy in production with monitoring and security

---

## Community & Support

- **Zig Discord**: [discord.gg/zig](https://discord.gg/zig)
- **Zig Forum**: [ziggit.dev](https://ziggit.dev/)
- **GitHub Discussions**: Use for project-specific questions

---

**Remember**: This is a learning journey. Take your time, understand deeply, and enjoy the process! 🚀
