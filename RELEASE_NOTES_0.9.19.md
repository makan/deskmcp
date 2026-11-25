# DeskMCP 0.9.19

## Added

- Added a live received-command counter to the Control Panel so the number of commands handled since startup is visible beneath the Gateway status.
- Added configurable Gateway and Tunnel Client ports in Settings, with defaults of `8120` and `8888`.

## Fixed

- Added validation for Gateway and Tunnel Client port values to reject invalid or conflicting configuration before startup.
- Fixed long Workspace paths in the Windows Control Panel so the complete path is displayed and handled correctly.

## Validation

- Release-stage and installer validation results will be recorded after the Windows x64 installer build and smoke tests complete.