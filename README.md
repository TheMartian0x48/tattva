# Zoxy

![License](https://img.shields.io/badge/license-%20%20GNU%20GPLv3%20-green)
![Zig Version](https://img.shields.io/badge/Zig-%3E%3D0.15.2-orange)
![Status](https://img.shields.io/badge/status-early_development-red)

## About

> [!WARNING]
> This project is currently in **early stages of development**. Features and APIs are subject to change.

Zoxy is a high-performance reverse proxy server built with Zig. Designed for simplicity and speed, Zoxy aims to provide a robust solution for routing and managing network traffic with minimal overhead.

## Features

- **High Performance**: Built with Zig for optimal speed and memory safety.
- **Simple Configuration**: Easy-to-understand configuration for quick setup.
- **Lightweight**: Minimal dependencies and small binary size.

*Planned Features:*
- Load Balancing
- TLS Termination
- Request/Response Modification
- Advanced Logging & Metrics

## Getting Started

### Prerequisites

- [Zig Compiler](https://ziglang.org/download/) (version >= 0.15.2)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/TheMartian0x48/zoxy.git
    cd zoxy
    ```

2.  **Build the project:**

    ```bash
    zig build
    ```

### Usage

To run the server with default settings:

```bash
zig build run
```

The server will start listening on the configured port (default: 8080).

## Configuration

Configuration is currently handled via `src/config.zig`. Future versions will support external configuration files (JSON/YAML/TOML).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.