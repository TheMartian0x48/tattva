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

### 1.1 Network Programming Basics

**Key Concepts**:
- TCP/IP fundamentals
- Sockets (bind, listen, accept, read, write)
- Blocking vs non-blocking I/O
- Connection lifecycle

**Reading List**:
- [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/) - Classic introduction to sockets
- [The C10K Problem](http://www.kegel.com/c10k.html) - Understanding scalability challenges
- Zig Standard Library: `std.net` documentation

**Progressive Implementation**:
1. Create a simple TCP echo server (accept connection, echo back)
2. Add multiple client support (one at a time)
3. Implement basic error handling
4. Add connection timeouts

**Files to Create/Modify**:
- `src/server.zig` - Basic TCP server
- `tests/server_test.zig` - Server tests

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

---

## Phase 3: Performance & Scalability

### 3.1 Async I/O and Concurrency

**Key Concepts**:
- Event loops (epoll, kqueue, io_uring)
- Async/await patterns
- Thread pools
- Lock-free data structures

**Reading List**:
- [The Linux Programming Interface - I/O Multiplexing](https://man7.org/tlpi/)
- [io_uring Introduction](https://kernel.dk/io_uring.pdf)
- [Zig Async/Await](https://ziglang.org/documentation/master/#Async-Functions)
- [Lock-Free Programming](https://preshing.com/20120612/an-introduction-to-lock-free-programming/)

**Progressive Implementation**:
1. Convert to async I/O (epoll/kqueue)
2. Implement event loop
3. Add worker thread pool
4. Use io_uring (Linux only)
5. Implement lock-free connection pool

**Files to Create/Modify**:
- `src/event_loop.zig` - Event loop
- `src/worker.zig` - Worker threads
- `src/async_io.zig` - Async I/O wrapper

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
