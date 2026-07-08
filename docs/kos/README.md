# kOS Documentation (offline mirror)

Local, offline copy of the official kOS documentation from
[ksp-kos.github.io/KOS](https://ksp-kos.github.io/KOS/), mirrored for quick
reference while writing scripts in this repo. Each file corresponds 1:1 to a
page on the live site (same relative path, `.md` instead of `.html`) and
starts with a `> Source:` line linking back to the original.

If something looks out of date, check the live site — kOS documentation
updates with new game/mod versions.

## Getting started

- [index.md](index.md) / [contents.md](contents.md) — site home and full table of contents
- [tutorials/quickstart.md](tutorials/quickstart.md) — start here if you're new to kOS
- [tutorials/basictutorial.md](tutorials/basictutorial.md), [tutorials/designpatterns.md](tutorials/designpatterns.md), [tutorials/pidloops.md](tutorials/pidloops.md), [tutorials/exenode.md](tutorials/exenode.md), [tutorials/display_bounds.md](tutorials/display_bounds.md), [tutorials/gui.md](tutorials/gui.md)

## Language

- [language/syntax.md](language/syntax.md), [language/features.md](language/features.md), [language/flow.md](language/flow.md), [language/variables.md](language/variables.md), [language/user_functions.md](language/user_functions.md), [language/anonymous.md](language/anonymous.md), [language/delegates.md](language/delegates.md)

## Math

- [math/basic.md](math/basic.md), [math/scalar.md](math/scalar.md), [math/vector.md](math/vector.md), [math/direction.md](math/direction.md), [math/geocoordinates.md](math/geocoordinates.md), [math/ref_frame.md](math/ref_frame.md)

## Commands

- [commands/runprogram.md](commands/runprogram.md), [commands/flight.md](commands/flight.md) (+ [cooked](commands/flight/cooked.md), [raw](commands/flight/raw.md), [pilot](commands/flight/pilot.md), [systems](commands/flight/systems.md)), [commands/prediction.md](commands/prediction.md), [commands/list.md](commands/list.md), [commands/parts.md](commands/parts.md), [commands/files.md](commands/files.md), [commands/terminalgui.md](commands/terminalgui.md), [commands/serialization.md](commands/serialization.md), [commands/communication.md](commands/communication.md), [commands/resource_transfer.md](commands/resource_transfer.md)

## Structures (the object/suffix reference)

- [structures/vessels.md](structures/vessels.md) and everything under `structures/vessels/` — `Vessel`, `Part`, `Engine`, `DockingPort`, `Node`, `Stage`, `Resource`, `DeltaV`, etc.
- [structures/orbits.md](structures/orbits.md), `structures/orbits/` — `Orbit`, `Orbitable`, `OrbitableVelocity`, `OrbitEta`
- [structures/celestial_bodies.md](structures/celestial_bodies.md), `structures/celestial_bodies/` — `Body`, `Atmosphere`
- [structures/communication.md](structures/communication.md), `structures/communication/` — `Connection`, `Message`, `MessageQueue`
- [structures/collections.md](structures/collections.md), `structures/collections/` — `List`, `Lexicon`, `Queue`, `Stack`, `Range`, `Iterator`, `Enumerable`, `UniqueSet`
- [structures/volumes_and_files.md](structures/volumes_and_files.md), `structures/volumes_and_files/` — `Volume`, `Path`, `VolumeFile`, `VolumeDirectory`, `FileContent`
- [structures/gui.md](structures/gui.md), `structures/gui_widgets/` — `Widget`, `Button`, `Label`, `TextField`, `Slider`, `Style`, etc. (for `general/gui.md` UIs)
- [structures/misc.md](structures/misc.md), `structures/misc/` — `PIDLoop`, `SteeringManager`, `Time`, `WARP`, `VecDraw`, `Config`, `String`, `Terminal`, etc.
- [structures/waypoint.md](structures/waypoint.md), [structures/reflection.md](structures/reflection.md)

## General

- [bindings.md](bindings.md) — bound variables (`SHIP`, `ALT`, `STAGE`, etc.)
- [general/cpu_vessel.md](general/cpu_vessel.md), [general/cpu_hardware.md](general/cpu_hardware.md), [general/boot.md](general/boot.md) — relevant to this repo's `boot/boot.ks`
- [general/kospartmodule.md](general/kospartmodule.md), [general/settingsWindows.md](general/settingsWindows.md), [general/gui.md](general/gui.md), [general/telnet.md](general/telnet.md), [general/volumes.md](general/volumes.md), [general/compiling.md](general/compiling.md), [general/skid.md](general/skid.md), [general/nametag.md](general/nametag.md), [general/parts_and_partmodules.md](general/parts_and_partmodules.md), [general/career_limits.md](general/career_limits.md)

## Addons

- [addons/AGX.md](addons/AGX.md), [addons/RemoteTech.md](addons/RemoteTech.md), [addons/KAC.md](addons/KAC.md), [addons/IR.md](addons/IR.md), [addons/OrbitalScience.md](addons/OrbitalScience.md), [addons/Trajectories.md](addons/Trajectories.md)

## Other

- [downloads_links.md](downloads_links.md), [library.md](library.md), [contribute.md](contribute.md), [getting_help.md](getting_help.md), [changes.md](changes.md), [about.md](about.md)
