# LQR Controller for Crazyflie

This repository implements a Linear Quadratic Regulator (LQR) controller for the Crazyflie 2.X drone. It is designed to be built as an **App Layer** in the **Out-of-Tree-Controller** example within the Crazyflie firmware file structure.

## Repository Structure

- **`app-lqr/`**: Contains the C source code and Makefile.
  - `src/`: Source files implementing the control logic.
  - `Makefile`: Build configuration.
- **`lqr_params.m`**: MATLAB script used to calculate the optimal gain matrix ($K$) based on the system model and cost weights ($Q$ and $R$).

## Prerequisites

To build, flash, and control this system, you need:

1.  **Crazyflie Firmware**: Clone the official repository:
    ```bash
    git clone [https://github.com/bitcraze/crazyflie-firmware.git](https://github.com/bitcraze/crazyflie-firmware.git)
    ```
2.  **Crazyflie Python Client**: Required for the control GUI and setting parameters.
    - [Installation Instructions](https://github.com/bitcraze/crazyflie-clients-python)
3.  **Toolchain**: Ensure you have the ARM GCC toolchain installed and in your path.
4.  **MATLAB** (Optional): Required if you wish to re-tune the LQR gains.

## Installation & Setup

To use this controller, you must place the application folder inside the firmware's `examples` directory.

1.  **Clone or Download** this repository.
2.  **Move** the `app-lqr` folder from this repository into `crazyflie-firmware/examples/`.
    
    *Your directory structure should look like this:*
    ```text
    crazyflie-firmware/
    ├── src/
    ├── examples/
    │   ├── app-lqr/       <-- Put the folder here
    │   │   ├── src/
    │   │   ├── Makefile
    │   ├── helloworld/
    │   └── ...
    ```
In order to use the LQR controller, you need to go into the Python GUI:
`cfclient`
In the GUI click on "View" -> "Parameters" -> select stabilizer.controller and set it to 6 to activate the Out-of-Tree-Controller

## Build & Flash Instructions

### 1. Build the Firmware
Navigate to the new folder inside the firmware and compile:

```bash
cd crazyflie-firmware/examples/app-lqr
make
