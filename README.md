# FSM-Based UART Communication System with FIFO Buffer

## Project Overview

This project implements a complete UART (Universal Asynchronous Receiver Transmitter) Communication System using Verilog HDL. The design consists of a UART Transmitter (TX), UART Receiver (RX), FIFO Buffer, Baud Rate Generator, and an FSM-based Controller to enable reliable serial communication between modules.

The project was developed and verified using Xilinx Vivado and demonstrates end-to-end serial data transmission and reception with buffering and error detection mechanisms.
## Key Features

### UART Transmitter (TX)
* FSM-based transmitter design
* Serial transmission of 8-bit data frames
* Start bit, data bits, parity bit, and stop bit generation
* Busy signal for transmission status monitoring
* Transmission counter for tracking transmitted frames

### UART Receiver (RX)
* FSM-based receiver design
* Serial-to-parallel data conversion
* Parity checking for error detection
* Framing error detection using stop bit verification
* Receive-complete indication through `rx_done`

### FIFO Buffer
* 4 × 8 FIFO memory implementation
* Independent read and write operations
* Full and Empty status flags
* Flow control between data source and UART transmitter

### Baud Rate Generator
* Configurable baud rate generation using a parameterized clock divider
* Provides synchronized timing for UART transmission and reception

### Controller FSM
* Manages FIFO read operations
* Loads data into the UART transmitter
* Initiates transmission automatically when data is available
* Coordinates communication between FIFO and UART modules

## System Architecture
Input Data
↓
FIFO Buffer
↓
Controller FSM
↓
UART Transmitter (TX)
↓
Serial Communication Channel
↓
UART Receiver (RX)
↓
Recovered Parallel Data

## Functional Verification
The design was successfully simulated in Vivado.

### Example Data Transfer
Transmitted Data:
AA → BB → CC → DD
Received Data:
AA → BB → CC → DD

### Verification Results
* Successful FIFO buffering and retrieval
* Correct UART transmission and reception
* Accurate parity generation and checking
* Framing error detection functionality verified
* Transmission counter operation verified
* No data loss during communication

## Technologies Used
* Verilog HDL
* Xilinx Vivado
* FSM-Based RTL Design
* Digital Communication Protocols
  
## Learning Outcomes
Through this project, I gained practical experience in:

* RTL Design using Verilog HDL
* FSM-Based System Design
* UART Communication Protocol
* FIFO Memory Architecture
* Clock and Baud Rate Generation
* Hardware Verification and Debugging
* FPGA Design Methodology
