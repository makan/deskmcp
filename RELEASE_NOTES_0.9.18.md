# DeskMCP 0.9.18

## Fixes

- Fixed a Gateway shutdown race that could surface `No process is associated with this object` while the process exit callback was running.
- Reconfigured managed Tunnel profiles when their stored endpoint becomes stale.
- Built VirtualDesktopAccessor with the static MSVC runtime to remove the separate Visual C++ runtime dependency from the bundled native DLL.
- Migrated legacy default ports to Gateway `8120` and Tunnel Client `8888` without overwriting custom ports.

## Validation

Installer validation results will be recorded after the Windows x64 release-stage and installer smoke tests complete.