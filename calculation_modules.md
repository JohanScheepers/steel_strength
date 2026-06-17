# Calculation Modules

Here are the essential calculation modules we should add next to comply with SANS 10160 and SANS 10162-1, along with the architectural formulas your Dart code will need to execute.

## 1. Shear Capacity Verification ($V_r$)

Before a beam bends to its maximum, it can fail near its supports due to the vertical "slicing" force (shear). SANS 10162-1 looks primarily at the capacity of the web area to resist this force.

The Physics & Formula:

$$V_r = \phi \cdot 0.66 \cdot f_y \cdot A_w$$

Where:
* $\phi = 0.90$
* $A_w =\text{Web Area} = h \times t_w$ (Total depth $\times$ web thickness)
* $0.66 \cdot f_y$ represents the shear yield strength (derived from the Von Mises yield criterion).

Dart Implementation snippet:
``` Dart
double calculateShearResistance(SteelSection section) {
  double Aw = section.h * section.tw; // mm^2
  double nominalShear = 0.66 * fy * Aw; // Newtons
  return (phi * nominalShear) / 1e3; // Convert to kN
}
```

## 2. Axial Compression / Column Buckling ($C_r$)

In steel structures like portal frames, columns experience heavy vertical crushing loads. They rarely fail by crushing; instead, they buckle sideways. This calculation requires calculating the Slenderness Ratio ($\lambda$), which determines how prone the column is to buckling.

**The Logic Pipeline:**
1. **Determine Effective Length ($KL$):** Where $L$ is the physical height and $K$ is the effective length factor based on end restraints (e.g., $K=1.0$ for pinned-pinned, $K=0.7$ for fixed-pinned).
2. **Calculate Radius of Gyration ($r$):** Found using $r = \sqrt{I/A}$. Your database must include the cross-sectional area ($A$) and radii of gyration ($r_x, r_y$).
3. **Find Slenderness ($\frac{KL}{r}$):** Columns always buckle around their weakest axis (usually the Y-axis for I-sections).
4. **SANS 10162-1 Compressive Resistance:**
$$C_r = \phi \cdot A \cdot f_y \cdot (1 + \lambda^{2n})^{-1/n}$$
(Where $n=1.34$ for hot-rolled structural steel sections).

## 3. Lateral-Torsional Buckling (LTB) for Unbraced Beams

Our initial bending calculation assumed the beam was "laterally supported" (e.g., cast inside a concrete floor slab so it can't twist). If a steel beam is open and unsupported over a long length, it will suddenly twist and kick out sideways under a load long before it hits its full plastic moment ($M_r$).

**What the App Needs to Calculate:**
* **Unsupported Length ($L_u$):** The distance between lateral structural braces (like purlins or cross-beams).
* **Critical Elastic Buckling Moment ($M_u$):** A complex differential calculation that factors in warping torsional constants ($J$ and $C_w$) of the steel section.
* **Reduced Moment Capacity ($M_r'$):** If $L_u$ exceeds the section's limit, the app must dynamically scale down the bending strength using the SANS LTB reduction curves.

## 4. Serviceability Limit State (SLS): Deflection Integration

While the modules above ensure the building won't collapse (Ultimate Limit State), we must also check that the beam doesn't sag so much that it cracks ceilings or panics occupants. This is where your calculus numerical integration shines.

**The Limits according to SANS 10160:**
* **Live Load Deflection Limit:** Max deflection $\delta_{max} \le \frac{\text{Span}}{360}$
* **Total Load Deflection Limit:** Max deflection $\delta_{max} \le \frac{\text{Span}}{250}$

Using the code we discussed earlier, your app can take any random loading setup (point loads, variable trapezoidal loads from wind), integrate the bending diagram twice to map the exact deflection profile, and flags a warning if the peak exceeds $\frac{L}{360}$.

## 5. Combined Axial Force and Bending (Interaction Equations)

Real-world elements, like the rafters or columns in an industrial warehouse frame, experience both compression and bending simultaneously. SANS 10162-1 mandates an interaction check:
$$\frac{C_f}{C_r} + \frac{U_{1x} M_{fx}}{M_{rx}} + \frac{U_{1y} M_{fy}}{M_{ry}} \le 1.0$$

If this combined ratio exceeds 1.0, the member fails under the combined stress, even if it passes bending and compression checks individually.

