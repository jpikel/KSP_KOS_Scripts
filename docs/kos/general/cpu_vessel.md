> Source: https://ksp-kos.github.io/KOS/general/cpu_vessel.html (mirrored offline copy for local reference)

# CPU Vessel (SHIP) — kOS Documentation Summary

## Key Concept

The documentation defines the "CPU Vessel" as "whichever vessel happens to currently contain the CPU in which the executing code is running." This is distinct from the "active vessel," which refers to the craft the camera focuses on and receives keyboard input.

## Important Distinctions

The document clarifies that these terms can differ during scenarios involving multiple vessels in close proximity (within 2.5 km physics range, such as docking operations). A kOS program executes on its CPU vessel regardless of which vessel KSP designates as "active."

## The SHIP Variable

The built-in variable `SHIP` always references the current CPU vessel. Whenever documentation mentions the CPU vessel, you can substitute the `SHIP` variable as its equivalent.

## Practical Applications

For operations involving vessel-specific functions—such as establishing coordinate frames (`SHIP-RAW`), adding maneuver nodes, or controlling autopilot systems—the system uses the CPU vessel rather than the active vessel for all determinations and control decisions.
