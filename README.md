# FIFO Design Verification Test Bench

This repository contains a test bench implemented in [SystemVerilog](https://en.wikipedia.org/wiki/SystemVerilog) to verify the functionality of a FIFO (First-In-First-Out) design. The verification methodology employed in this test bench is constrainted randomization, which allows for comprehensive and efficient testing of the FIFO.

## Introduction

The FIFO Design Verification Test Bench is a collection of SystemVerilog files that aim to validate the correctness of a FIFO design implementation. By utilizing constrainted randomization, the test bench generates a wide range of random test scenarios to ensure comprehensive verification coverage. This methodology allows for the detection of potential design flaws, edge cases, and corner-case scenarios.

## Usage

To run the FIFO design verification test bench, follow these steps:

1. visit edaplayground.com
2. create an account
3. copy the contents of design.sv to design.sv on the website
4. copy the contents of testbench.sv to testbench.sv on the website
5. on the left, choose SystemVerilog/Verilog as the language under languages and libraries
6. on the left, choose Aldec Riviera Pro 2022.04 under Tools & Simulators
7. click on "Open EPWave after run" also under Tools & Simulators if you wish to analyze the waveforms
8. hit Save then Run

During the simulation, the test bench will automatically generate random stimulus and monitor the behavior of the FIFO design under test. Any errors, mismatches, or violations will be reported and logged.

