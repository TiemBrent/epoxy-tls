# Use the official Rust nightly image to satisfy the build requirement
FROM rustlang/rust:nightly-bookworm AS builder

WORKDIR /app

# Copy the entire repository
COPY . .

# Build the epoxy-server binary in release mode
# The server code is located in the 'server' directory
RUN cargo build --release --bin epoxy-server

# Use a minimal Debian image for the final runtime
FROM debian:bookworm-slim

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/release/epoxy-server .

# Copy the configuration file
COPY config.toml .

# Expose the port the server will listen on
EXPOSE 4000

# Run the server with the configuration file
CMD ["./epoxy-server", "config.toml"]