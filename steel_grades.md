# Steel Grades

To build an accurate software application like Steel Strength, it is important to understand how steel grades are structured. In South Africa, the steel grading system is in a unique transitional phase: it blends the historic, locally developed **SANS 1431** standard with the modern, European-harmonized **SANS 50025 / EN 10025** standard.

Depending on the scale of the steel work, the application will encounter different grades. The complete breakdown of the steel grades utilized across the South African market ranges from heavy industrial frames to light backyard fabrications.

## 1. Decoding the Grade Nomenclature

Before looking at the specific grades, it helps to understand what the letters and numbers actually mean on an engineering drawing or material certificate:

* **The Old SA System (SANS 1431):** e.g., **350WA**

    * **350**: Minimum Yield Strength in Megapascals (MPa).
    * **W**:Weldable structural steel.
    * **A**: Grade impact category (A means no mandatory low-temperature impact test required; C and DD require Charpy V-notch impact toughness testing at $0^\circ\text{C}$ and $-20^\circ\text{C}$ respectively).
* **The New EN System (SANS 50025/ EN 10025):** e.g., **S355JR**
    * **S**: Structural Steel.
    * **355**: The minimum Yield Strength ($f_y$) in MPa.
    * **JR**: Impact testing properties (JR means it absorbs 27 Joules of impact energy at $+20^\circ\text{C}$; J0 means at $0^\circ\text{C}$; J2 means at $-20^\circ\text{C}$).

## 2. The Core Steel Grades in South Africa

**A. Grade 355 / 350WA (The Heavy Structural King)**
This is the absolute standard for hot-rolled structural steel in South Africa. If an engineer is specifying Universal Beams (UB), Universal Columns (UC), heavy IPE sections, or large plates for a warehouse or shopping mall, they are using this grade.

* **Yield Strength ($f_y$):** $355 \text{ MPa}$ (drops slightly to $345 \text{ MPa}$ for very thick plates over 16mm).

* **App Context:** This is the default setting for any heavy industrial calculations. It offers the best ratio of high strength to cost for major load-bearing elements.

**B. Grade 275 / 300WA (The Transition Grade)**
Historically, South Africa used a lot of Grade 300WA steel. Under the newer EN-harmonized standards, this track mostly aligns with S275.

* **Yield Strength ($f_y$):** $275 \text{ MPa}$ to $300 \text{ MPa}$.

* **App Context:** Frequently found in medium-sized architectural steel frames, certain plates, and imported steel sections. It is a reliable mid-tier structural steel.

**C. Grade 235 / 240WA (Commercial Quality / Mild Steel)**
This is what most non-engineers simply call "mild steel." It is exceptionally ductile, easy to bend, easy to weld, and can be cut quickly with basic tools.

* **Yield Strength ($f_y$):** $235 \text{ MPa}$ to $240 \text{ MPa}$.

* **App Context:** This is the steel profile grade used for very small steel works. If a local welder buys small angle irons, flat bars, or solid round bars from a standard steel merchant, it will be this grade.

**D. Grade 200 / SAE 1008 (The Tubing Standard)**
Cold-formed hollow profiling operates differently. Standard square tubing (SHS) and rectangular tubing (RHS) sold off-the-shelf in small dimensions (like 25x25x2 or 50x50x2) are usually rolled from very mild, commercial-quality sheet steel.

* **Yield Strength ($f_y$): $\approx 200 \text{ MPa}$.**

* **App Context:** Vital for small works like carports, gate frames, and window burglar bars. ***Warning:*** If your app calculates a carport post using 355 MPa when the fabricator used standard commercial 200 MPa tubing, the column could buckle under heavy wind or rain loads.

**E. Grade 220 / S220GD (Lipped Channels / Purlins)**
Cold-formed lipped channels used for roof purlins or light steel framing are typically galvanized or zinc-coated thin-gauge steels.

* **Yield Strength ($f_y$):** $220 \text{ MPa}$ (though higher-strength options like Grade 550 exist for specialized light-gauge framing).

* **App Context:** Critical for light roof canopy structures and purlin spacing calculations.

## 3. Specialty & High-Strength Grades (Advanced Engineering)

If you expand Steel Strength to handle high-tech civil works, mining infrastructure, or earthmoving applications, you will encounter these premium grades:

* **Grade 450WA / S460:** High-strength structural steel used when columns need to bear massive multi-story loads without becoming physically too thick.

* **VascoMax / ROQ-tuf / Hardox (Quenched & Tempered):** These are extremely hard, high-strength wear plates (Grades 400, 500, etc.) used heavily in the South African mining sector for lining the chutes of dump trucks and conveyor systems to resist abrasive rock impacts.

* **Weathering Steels (e.g., Cor-Ten / S355J0WP):** These special grades oxidize (rust) on the surface to form a protective patina, allowing them to be used unpainted in exposed architectural or industrial applications.