
* I/O model
    * Nonblocking + event loop
* Concurrency model
    * Single event-loop + worker thread pool
* Protocol & connection handling
    * Keep-alive, pipelining, multiplexing: support HTTP/1.1 keep-alive, HTTP/2 multiplexing and HTTP/3 (QUIC) for best client performance.
    * Connection pooling to backends: reuse backend TCP/TLS connections; avoid per-request connect cost.
    * HTTP/2/3 connection management: multiplexing reduces backend concurrency needs but watch head-of-line and flow control.
    * Backpressure & buffering: stream data where possible; limit in-memory buffering and apply backpressure on slow clients/backends.
* TLS
    * Terminate TLS in proxy (common): simplifies routing/inspection/rewrite.
    * TLS passthrough for services that need end-to-end TLS.
    * Accelerators: use hardware or dedicated process if needed.
    * Session/Ticket reuse and OCSP stapling for performance.