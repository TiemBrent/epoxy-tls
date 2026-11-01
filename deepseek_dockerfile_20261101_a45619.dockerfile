FROM rustlang/rust:nightly-bookworm AS builder

WORKDIR /app
COPY . .
RUN cargo build --release --bin epoxy-server

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/target/release/epoxy-server .
COPY config.toml .
EXPOSE 4000
CMD ["./epoxy-server", "config.toml"]
