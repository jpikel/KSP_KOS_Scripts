> Source: https://ksp-kos.github.io/KOS/general/telnet.html (mirrored offline copy for local reference)

# kOS Telnet Server Documentation

## Overview

The kOS telnet server enables remote access to the kOS terminal from outside Kerbal Space Program using the telnet protocol. This allows users to control spacecraft through network connections via dedicated telnet client programs.

**Critical Requirement:** The game option "Simulate in Background" must be enabled in KSP's General settings for the telnet feature to function properly.

## Telnet Clients

### Recommended Programs

**Windows:** Putty is recommended as a free terminal emulator with XTERM compatibility support.

**Mac:** A telnet client comes pre-installed; access it through the command terminal as a command-line tool.

**Linux:** Most distributions include both telnet and xterm pre-installed for immediate use.

## Simulate in Background

Without this setting enabled, KSP pauses whenever focus switches to another application. Since using a telnet client shifts focus away from KSP, the server becomes frozen and unresponsive without this option active.

## Basic Usage

1. Enable the telnet server via the app control panel's green circle or by executing `SET CONFIG:TELNET TO TRUE`
2. Accept security warnings on first activation
3. Launch your telnet client
4. Select a CPU from the welcome menu by entering its number
5. Begin executing commands as if using the in-game terminal

Multiple simultaneous telnet connections to the same CPU are supported; all terminals mirror each other's display and input state.

## Special Keys

| Key | Function |
|-----|----------|
| Ctrl+L | Force screen refresh |
| Ctrl+C | Interrupt process execution |
| Ctrl+D | Detach and return to menu |
| Arrow Keys | Navigation (if terminal type recognized) |
| Ctrl+A | Home key alternative |
| Ctrl+E | End key alternative |
| Ctrl+H | Backspace alternative |
| Ctrl+M | Return key alternative |

## Putty Configuration

1. Select Telnet radio button
2. Enter host: `127.0.0.1`
3. Enter port: `5410`
4. Select "Never" for "Close window on exit"
5. Click Open

## Command-Line Usage

Execute in terminal:
```
telnet 127.0.0.1 5410
```

## Security Considerations

The telnet protocol provides no encryption. The default configuration runs on loopback address `127.0.0.1`, preventing external connections. To allow remote access, modify `CONFIG:IPADDRESS` or establish SSH tunnels. Port forwarding on routers may be required for external connections.

SSH was not implemented due to C# library constraints and development time limitations.

## Technical Protocol Requirements

Homemade telnet clients must implement:

- RFC857 (ECHO negotiation)
- RFC858 (SUPPRESS GO AHEAD)
- RFC854 (basic telnet infrastructure with IP interrupt as byte 255 + 244)
- RFC1091 (Terminal-Type option: XTERM or VT100 only)
- RFC1073 (NAWS for terminal size negotiation)

## Terminal Escape Sequences

**ASCII Standards:**
- `0x08`: Backspace
- `0x0d`: Return (left edge, no line advance)
- `0x0a`: Line feed (advance line, no left movement)

**VT100/XTERM Codes:**
- Arrows: `ESC [ A/B/C/D`
- Home: `ESC [ 1 ~`
- End: `ESC [ 4 ~`
- Delete: `ESC [ 3 ~`
- Page Up/Down: `ESC [ 5/6 ~`
- Clear screen: `ESC [ 2 J`
- Cursor position: `ESC [ row ; col H`
- Scroll up/down: `ESC [ S/T`

**XTERM-Specific:**
- Resize: `ESC [ 8 ; height ; width t`
- Set title: `ESC ] 2 ; titlestring BEL`
