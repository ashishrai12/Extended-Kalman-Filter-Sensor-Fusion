# Multi-stage Dockerfile for Extended Kalman Filter Sensor Fusion

# Build Stage
FROM rust:1.75-slim AS builder

WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy workspace files
COPY . .

# Build the project (Release mode)
RUN cargo build --release

# Development/Runtime Stage
FROM rust:1.75-slim

WORKDIR /usr/src/app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
# (Assuming we want to run the provided example by default)
COPY --from=builder /usr/src/app/target/release/examples/radar_lidar_fusion /usr/local/bin/radar_lidar_fusion

# Default command: Run the fusion example
CMD ["radar_lidar_fusion"]
