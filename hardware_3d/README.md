# 3D Printable Engineering Concepts (Joey Quick-Start)

If you want a **click-and-view experience on iPhone first**, open:

- `iphone_quick_view.html`
- or direct viewers:
  - `ai_chip_viewer.html`
  - `ai_satellite_viewer.html`
- static previews:
  - `ai_chip_preview.svg`
  - `ai_satellite_preview.svg`

## What you get

1. `ai_chip_module.scad` — AI chip package concept with substrate, die package, thermal fins, memory stacks, mounting points, and connector shelf.
2. `ai_satellite_platform.scad` — next-generation satellite concept with AI compute bus, solar arrays, robotic docking ports, and thrusters.
3. iPhone-friendly browser viewers (touch rotate + zoom) for both concepts.

## Exporting to STL (ready for slicers)

From this directory:

```bash
# AI chip module
openscad -o ai_chip_module.stl ai_chip_module.scad

# AI satellite platform
openscad -o ai_satellite_platform.stl ai_satellite_platform.scad
```

## Suggested print profiles

- Nozzle: `0.4 mm`
- Layer height: `0.16–0.24 mm`
- Wall count: `3`
- Infill: `20%` (chip) / `15%` (satellite)
- Material:
  - PLA for visual prototyping
  - PETG/ABS for tougher fit-check parts

## 3D printer hookup workflow

1. Export STL from OpenSCAD.
2. Open STL in your slicer (PrusaSlicer, Cura, Bambu Studio, etc.).
3. Select your exact printer and material profile.
4. Slice and export toolpath (`.gcode`, `.bgcode`, etc.).
5. Transfer file to printer via SD card / USB / Wi-Fi.
6. Level bed, preheat, and print.

## Mineral-to-Hardware roadmap (high-level)

Given your flourspar/mineral operations, a practical path is:

1. Use these models for enclosure + integration mockups.
2. Build a pilot line for mechanical parts first (CNC + 3D print + wiring harnesses).
3. Source compute dies and memory from foundries initially; focus your proprietary edge on packaging, thermal architecture, ruggedization, and robotic integration.
4. Progress to advanced materials processing once throughput, quality systems, and capex model are proven.

## Engineering note

These are **mechanical concept models** for manufacturing visualization and fit checks, not functional semiconductor/satellite hardware.
