FROM rustlang/rust:nightly-bookworm AS builder

WORKDIR /app
COPY . .
RUN cargo build --release --bin epoxy-server

FROM debian:bookworm-slim

# Install runtime dependencies: OpenSSL 3 shared library and CA roots.
# Without libssl3 the binary fails with:
#   error while loading shared libraries: libssl.so.3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl3 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/target/release/epoxy-server .
COPY config.toml .

EXPOSE 4000
CMD ["./epoxy-server", "config.toml"]
