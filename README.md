# FIFO Design Verification Test Bench

This repository contains a test bench implemented in [SystemVerilog](https://en.wikipedia.org/wiki/SystemVerilog) to verify the functionality of a FIFO (First-In-First-Out) design. The verification methodology employed in this test bench is constrainted randomization, which allows for comprehensive and efficient testing of the FIFO.

## Introduction

The FIFO Design Verification Test Bench is a collection of SystemVerilog files that aim to validate the correctness of a FIFO design implementation. By utilizing constrainted randomization, the test bench generates a wide range of random test scenarios to ensure comprehensive verification coverage. This methodology allows for the detection of potential design flaws, edge cases, and corner-case scenarios.

## Important Notes
- PLEASE NOTE THAT I HAVE NOT WRITTEN THE DESIGN, I HAVE ONLY VERIFIED IT
- design.sv IS NOT WRITTEN BY ME
- EVERYTHING ELSE IS DONE BY ME
- sorry for shouting that out lol, I just wanted it to be seen

## Usage

To run the FIFO design verification test bench, follow these steps:

1. Visit this link: https://www.edaplayground.com/x/SvJN
2. Top right, hit login and create an account
3. Eda Playground might open a new playground for you, so go ahead and click on my link again to open my playground
4. On the left, click on "Open EPWave after run" under Tools & Simulators if you wish to analyze the waveforms
5. hit Save then Run

During the simulation, the test bench will automatically generate random stimulus and monitor the behavior of the FIFO design under test. Any errors, mismatches, or violations will be reported and logged.

