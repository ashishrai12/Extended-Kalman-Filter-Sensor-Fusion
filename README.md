# Extended Kalman Filter Sensor Fusion

[![Rust CI](https://github.com/ashishrai12/Radar-and-LiDAR-Fusion-for-Object-Detection-and-Tracking/actions/workflows/rust-ci.yml/badge.svg)](https://github.com/ashishrai12/Radar-and-LiDAR-Fusion-for-Object-Detection-and-Tracking/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A high-performance Rust library for robotic state estimation, featuring a Differentiable Extended Kalman Filter (DEKF) with neural-network-driven adaptive noise estimation. This project also includes a classical MATLAB simulation for visualization and benchmarking.

## Overview

This library implements a **Differentiable Extended Kalman Filter (DEKF)** that:

1.  **Standard EKF**: Uses `nalgebra` for efficient linear algebra operations in the prediction ($x = Fx + Bu$) and update steps.
2.  **Adaptive Q-Network**: Employs `dfdx` to create a small neural network that predicts the diagonal elements of the Process Noise matrix $Q$ from innovation residuals.
3.  **Learning**: Provides a `train_step` function that minimizes Mean Squared Error (MSE) between predicted states and high-resolution LiDAR ground truth.

## Project Structure

```mermaid
graph TD
    Root[Extended Kalman Filter Sensor Fusion] --> Src[src/]
    Root --> Examples[examples/]
    Root --> Tests[tests/]
    Root --> Matlab[matlab/]
    Root --> Docs[docs/]
    Root --> Data[data/]
    Root --> Scripts[scripts/]
    Root --> Github[.github/]

    Src --> DEKF[dekf.rs]
    Src --> EKF[ekf.rs]
    Src --> QNet[q_network.rs]
    Src --> Lib[lib.rs]

    Examples --> FusionEx[radar_lidar_fusion.rs]
    Tests --> Integration[integration_test.rs]
    Matlab --> MRS[RadarLidarFusion.m]
    Github --> CI[workflows/rust-ci.yml]
```

## Rust Library

### Architecture

```text
┌─────────────────────────────────────────────────────────┐
│                    DEKF Pipeline                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Innovation Residual (y = z - Hx)                       │
│           │                                             │
│           ├──────────────────────┐                      │
│           │                      │                      │
│           ▼                      ▼                      │
│  ┌──────────────────┐   ┌──────────────────┐            │
│  │   Q-Network      │   │  Standard EKF    │            │
│  │   (dfdx MLP)     │   │   (nalgebra)     │            │
│  │                  │   │                  │            │
│  │  Input: y (4D)   │   │  x = Fx + Bu     │            │
│  │  Output: Q_diag  │   │  P = FPF^T + Q   │            │
│  └──────────────────┘   └──────────────────┘            │
│           │                      │                      │
│           └──────────┬───────────┘                      │
│                      ▼                                  │
│           Adaptive State Prediction                     │
│                      │                                  │
│                      ▼                                  │
│              MSE Loss vs Ground Truth                   │
│                      │                                  │
│                      ▼                                  │
│              Backprop & Update Q-Network                │
│└────────────────────────────────────────────────────────┘
```

### Quick Start

```rust
use ekf_sensor_fusion::DifferentiableEKF;
use nalgebra::{DMatrix, DVector};

// Create DEKF for 4D state (x, y, vx, vy), 2D measurement, 1D control
let mut dekf = DifferentiableEKF::new(4, 2, 1);

// ... set up matrices and run prediction/update ...
```

To run the provided radar-lidar fusion example:
```bash
cargo run --example radar_lidar_fusion
```

## MATLAB Simulation

Located in `/matlab`, this script provides a high-fidelity visualization of the fusion process.

- **Real-time Tracking**: Visualizes ground truth vs. sensor detections vs. fused path.
- **Error Analysis**: Quantifies performance with RMSE plots.

[View MATLAB Documentation](./matlab/README.md)

## Performance Visualization

### Real-time Tracking
<img width="1237" height="552" alt="Fusion Visualization" src="https://github.com/user-attachments/assets/1e64c686-0e35-4440-9114-8e30bca4e5fe" />

### Error Analysis
<img width="568" height="394" alt="Tracking Performance" src="https://github.com/user-attachments/assets/20400868-9ae4-4948-8136-da5ed41fc2dd" />

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
