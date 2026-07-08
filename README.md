# KSP_KOS_Scripts
Kerbal Operating System Scripts

Some of the scripts that I have been working on for Kerbal Operating System mod for Kerbal Space Program

A lot of these are works in progress and I have tried my best to make references

My comments are lacking, but most of the scripts are fairly short at the moment.

## Repository layout

- Top-level `.ks` files — active scripts for launch, docking, rendezvous, orbital maneuvers, science, SSTOs, rovers, and general flight control
- `lib_*.ks` — shared libraries (orbit math, Lambert solver, staging, input handling, UI, physics)
- `boot/` — boot scripts loaded on vessel startup
- `attic/` — deprecated or superseded scripts kept for reference
- `*_log.csv` — flight/mission logs written by the corresponding scripts

## Notes

- This repo was reorganized to use `main` as the default branch
- Local Claude Code settings (`.claude/settings.local.json`) are gitignored and not tracked
