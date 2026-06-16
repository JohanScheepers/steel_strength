# Steel Standards

In South Africa, structural engineering design is governed by the South African National Standards (SANS), which are developed and maintained by the South African Bureau of Standards (SABS).

When building a steel works application for the South African market, the underlying calculus engine for calculating actions, bending moments, and member resistances must adhere strictly to two primary code suites: SANS 10160 (for loading) and SANS 10162 (for steel design) (Walls, 2016).

## 1. The Loading Framework: SANS 10160

Before you can differentiate or integrate along a beam to find its internal forces, you must compute the structural actions using **SANS 10160: Basis of structural design and actions for buildings and industrial structures** (MAHACHI, n.d.).

Unlike the older 1989 regulations, the modern SANS 10160 suite is explicitly benchmarked against the **European Eurocodes (EN 1990 / EN 1991)** (MAHACHI, n.d.). However, it uses a modified target level of reliability:

* **Eurocodes** typically target a safety index of $\beta = 3.8$ (MAHACHI, n.d.).
* **SANS 10160** targets a more context-specific reliability index of $\beta = 3.0$, meaning the partial load factors are calibrated slightly differently to fit local economic and material conditions (MAHACHI, n.d.).

**Critical Parts for Your App:**
* **SANS 10160-1:** Basis of structural design (defines load combinations).

* **SANS 10160-2:** Self-weight and imposed loads.

* **SANS 10160-3:** Wind actions (essential for steel portal frames and warehouses).

* **SANS 10160-4:** Seismic actions (recently updated to better integrate steel-specific ductile design requirements) (Roth & Gebremeskel, 2017)

## 2. Structural Steel Design: SANS 10162

Once the forces are derived, the capacity verifications split depending on how the steel member was manufactured (Walls, 2016). Interestingly, South Africa draws from a diverse global mix of design cultures (Walls, 2016).

**A. Hot-Rolled Steelwork: SANS 10162-1**
This covers standard structural shapes like I-beams (IPE, HEB profiles), channels, angles, and universal columns (Walls, 2016)

* **The Origin:** Unlike the loading code (which leans Eurocentric), **SANS 10162-1** is fundamentally adapted from the **Canadian Steel Code (CSA S16)** (Dekker, n.d.; Walls, 2016). 

* **Design Philosophy:** It operates on Limit-States / Load and Resistance Factor Design (LRFD) principles (MAHACHI, n.d.; Walls, 2016). Instead of dividing by partial safety factors ($\gamma_M$) like the Eurocodes, your Dart equations will multiply nominal resistance by a capacity reduction factor ($\phi$) (Walls, 2016).

```
SANS 10162-1 Design Format:
Design Capacity (Rd) = φ × Nominal Capacity (Rn)
```
For your capacity calculation loops, hardcode the standard South African partial resistance factors ($\phi$) defined in Section 13 (Walls, 2016):

* **Structural Steel** ($\phi$): 0.90 (Walls, 2016)
* **Bolts** ($\phi_b$): 0.80 (Walls, 2016)
* **Weld Metal** ($\phi_w$): 0.67 (Walls, 2016)
* **Bearing of Bolts on Steel** ($\phi_{br}$): 0.67 (Walls, 2016)

**Important Axis Notation Note for your Dart UI/Data Models:** If you are importing standard European shapes (like IPE profiles) into your app database, be careful with axis labeling. Eurocode 3 defines the major axis as **y-y** and the minor axis as **z-z** (Walls, 2016). SANS 10162-1 sticks to North American notation: **x-x** is the major axis, and **y-y** is the minor axis (Walls, 2016).

**B. Cold-Formed Steelwork: SANS 10162-2**
If your software targets light-gauge steel construction, purlins, or lipped channels, you must switch execution tracks to this module (MAHACHI, n.d.).

* **The Origin: SANS 10162-2** is adopted directly from the **Australian/New Zealand Standard (AS/NZS 4600)** (MAHACHI, n.d.; Walls, 2016).

* **Design Philosophy:** It utilizes the Effective Width Method or the Direct Strength Method to account for the prominent local buckling risks inherent to thin-walled steel (MAHACHI, n.d.)

## 3. The South African Steel "Bible" (SAISC Red Book)

While not a legally binding standard itself, the **Southern African Institute of Steel Construction (SAISC)** publishes the Structural Steel Connections manual and The Red Book (Walls, 2016).

Every structural engineer in South Africa uses this as their primary tool. For your application to feel localized and highly practical, you should pre-load your database with:

1. **Standard Local Steel Grades:** Primarily **S355JR** (with a nominal yield strength $f_y = 355\text{ MPa}$ up to $16\text{ mm}$ thickness) (Walls, 2016).
2. **Local Geometric Libraries:** The properties for Corrugated/IBR roof sheeting, cold-formed lipped channels, and standard hot-rolled elements distributed by local mills.

## References

Dekker, N. W. (n.d.). Generic formulation of member strength as a step towards a unified structural code - SAICE. Journal of the South African Institution of Civil Engineering, 46(3), 17–21. https://saice.org.za/downloads/journal/vol46-3-2004/civileng_v46_n3_c.pdf

MAHACHI, J. (n.d.). Calibration of partial resistance factors for cold-formed steel in South Africa. University of Johannesburg. https://ujcontent.uj.ac.za/view/pdfCoverPage?instCode=27UOJ_INST&filePid=135866330007691&download=true

Roth, C. P., & Gebremeskel, A. (2017). Updated provisions of SANS 10160-4 for steel structures. Journal of the South African Institution of Civil Engineering, 59(1), 45–47. http://dx.doi.org/10.17159/2309-8775/2017/v59n1a6
Cited by: 2

Walls, R. S. (2016). A comparison of technical and practical aspects of Eurocode 3-1-1 and SANS 10162-1 hot-rolled steelwork design codes. Journal of the South African Institution of Civil Engineering, 58(1), 17–25. https://www.scielo.org.za/scielo.php?script=sci_arttext&pid=S1021-20192016000100002
Cited by: 7