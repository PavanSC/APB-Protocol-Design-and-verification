# APB-Protocol-Design-and-verification
Advanced Peripheral Bus (APB) Protocol
The Advanced Peripheral Bus (APB) is part of the AMBA (Advanced Microcontroller Bus Architecture) family developed by ARM, designed for low-power and low-latency communication between peripherals in a System-on-Chip (SoC). APB provides a simple interface optimized for minimal power consumption and reduced complexity, making it suitable for interfacing with low-bandwidth peripherals such as UARTs, timers, and general-purpose I/O.

Key Features:
Simple Interface: Uses a single clock edge for all operations, simplifying design and integration.

Low Power Consumption: Ideal for energy-efficient applications.

Non-pipelined Communication: Transactions are straightforward and occur in a sequential manner.

Ease of Integration: Simplified signal protocol reduces the overhead of connecting multiple peripherals.


Signal Overview:
PCLK: Clock signal for timing operations.

PRESETn: Reset signal, active low.

PADDR: Address bus specifying the peripheral register.

PWRITE: Indicates write (1) or read (0) operation.

PWDATA: Data bus for write operations.

PRDATA: Data bus for read operations.

PSEL: Select signal for peripheral.

PENABLE: Enables data transfer phase.


Operation:
Setup Phase: The master drives the address, control signals, and PSEL.

Enable Phase: PENABLE is asserted, and data transfer occurs based on the PWRITE signal.

Transfer Completion: PENABLE is de-asserted, completing the transaction.

APB is widely used in modern SoCs for its simplicity and reliability in connecting a wide range of peripherals.
