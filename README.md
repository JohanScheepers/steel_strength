# Steel Strength Calculator

A comprehensive Flutter application designed for structural engineers to calculate the capacities and properties of both **light and heavy steel structures**. The application performs robust engineering checks in accordance with South African National Standards (SANS).

## Features

The app includes a full suite of calculation modules for verifying structural integrity:

*   **Bending Capacity:** Calculates Factored Moment Resistance ($M_r$) for beams.
*   **Shear Capacity:** Verifies the web area's resistance to vertical slicing forces ($V_r$).
*   **Axial Compression & Buckling:** Determines column slenderness and computes the compressive resistance ($C_r$).
*   **Lateral-Torsional Buckling (LTB):** Calculates the critical elastic buckling moment ($M_u$) and reduced moment capacity ($M_r'$) for unbraced and partially braced beams.
*   **Serviceability Limit State (SLS):** Checks beam deflection under uniformly distributed loads against strict live-load ($L/360$) and total-load ($L/250$) limits.
*   **Interaction Equations:** Evaluates combined axial compression and bending stresses to ensure the structural member passes the interaction ratio check ($\le 1.0$).

## Supported Sections

The built-in database supports a wide variety of both heavy structural steel and light-gauge cold-formed sections, including:
*   **Universal Beams (UB)** & **Universal Columns (UC)**
*   **IPE Sections**
*   **Parallel Flange Channels (PFC)**
*   **Square & Rectangular Hollow Sections (SHS / RHS)**
*   **Equal Angles**
*   **Cold-Formed Lipped Channels** (Light steel framing)

## Standards

All engineering formulas and capacity reduction factors ($\phi$) implemented in this app are based on:
*   **SANS 10162-1:** The structural use of steel.
*   **SANS 10160:** Basis of structural design and actions for buildings and industrial structures.

For a detailed overview of the standards applied, please refer to [Standards.md](Standars.md).

## Technology Stack

*   **Framework:** Flutter (Cross-platform support for Web, Desktop, and Mobile)
*   **State Management:** `signals_flutter` for high-performance, reactive UI updates.
*   **Routing:** `go_router` for seamless navigation between calculation modules.
*   **Animations:** `cue` package for smooth, physics-based UI entrance effects and transitions.
*   **Reporting:** `pdf` package for generating exportable calculation reports.
*   **Data:** Local JSON database containing geometric and torsional properties ($I_x, I_y, J, C_w$, etc.) for steel sections.

## Getting Started

1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. Clone this repository.
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```
