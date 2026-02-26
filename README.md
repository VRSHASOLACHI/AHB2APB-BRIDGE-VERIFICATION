# AHB2APB-BRIDGE-VERIFICATION
This project focuses on the functional verification of an AHB to APB bridge using a SystemVerilog UVM (Universal Verification Methodology)–based environment. The AHB2APB bridge acts as a protocol converter between the high-performance AHB bus, typically used by processors, and the low-power APB bus.

# UVM-Based Verification of AHB to APB Bridge

## Project Overview
This project focuses on the functional verification of an **AHB to APB bridge** using **SystemVerilog and UVM (Universal Verification Methodology)**.  
The AHB2APB bridge converts high-performance AHB transactions into low-power APB transactions, enabling communication between processors and peripheral devices such as GPIO, UART, and timers.

The verification environment validates protocol compliance, data integrity, and correct transaction translation across both bus interfaces.

---

## Objectives
- Develop a complete **UVM-based verification environment** for an AHB2APB bridge  
- Verify correct handling of **single and burst read/write transactions**  
- Validate **AHB and APB protocol handshakes**  
- Implement **assertion-based verification**  
- Measure **functional, code, FSM, and assertion coverage**  
- Identify design issues and propose fixes based on simulation results  

---

## Protocols Verified
- **AHB (Advanced High-performance Bus)**
- **APB (Advanced Peripheral Bus)**

---

## Testbench Architecture
The UVM testbench follows a layered architecture and includes:
- AHB Agent (Sequencer, Driver, Monitor)
- APB Agent (Sequencer, Driver, Monitor)
- Scoreboard for data comparison
- Assertions for protocol checking
- Functional coverage collection
- Top-level environment and test

The DUT is connected via a virtual interface to both AHB and APB agents.

---

## Test Scenarios Implemented
1. Single Write Transaction  
2. Single Read Transaction  
3. Burst Write Transaction  
4. Burst Read Transaction  
5. Slave Access Failure / Invalid Address Access  

---

## Assertions Implemented
Assertions were added to validate critical protocol behavior:
- HRESP validity when HREADY is high  
- HREADY stability after write transactions  
- Valid HTRANS during active transfers  
- Correct APB write handshake (PSELx, PWRITE, PENABLE)  
- Correct APB read handshake (PSELx, PENABLE, PWRITE low)  

Assertion coverage was analyzed to assess protocol checking effectiveness.

---

## Coverage Summary
### Functional Coverage
- Total bins: 338  
- Bins hit: 181  
- Coverage: **53.55%**  

### Code Coverage
- Statement, toggle, condition, FSM state, and transition coverage were analyzed  
- FSM and toggle coverage indicate scope for additional corner-case testing  

### Assertion Coverage
- Assertion execution and branch coverage were collected  
- Some assertions remained partially exercised, indicating areas for stimulus improvement  

---

## Observations
- All AHB transactions returned `HRESP = ERROR`
- APB monitor did not capture any valid transactions
- Scoreboard reported empty APB transaction queue
- Indicates synchronization or protocol issues in DUT or sampling logic

---

## Design Issues Identified
- Out-of-range address generation causing error responses
- APB handshake violations (PENABLE asserted without PSELx)
- Uninitialized write data paths
- Potential HTRANS or timing misalignment issues

Suggested fixes were documented, including constrained address generation, improved monitor sampling, and enhanced protocol assertions.

---

## Tools Used
- SystemVerilog
- UVM
- QuestaSim
- EDA Playground

---

## Conclusion
This project demonstrates practical experience in **UVM-based verification**, including stimulus generation, assertion-based checking, coverage analysis, and debug of protocol-level issues.  
The work highlights the importance of coverage-driven verification and systematic debug when validating SoC interconnect components such as bus bridges.

---

## References
- ARM AMBA AHB and APB Protocol Specifications  
- UVM Class Reference Manual  
