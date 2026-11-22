# DeskMCP Port Configuration

DeskMCP exposes two configurable local service ports:

| Setting | Default | Purpose |
| --- | ---: | --- |
| Gateway Port | 8120 | Local DeskMCP Gateway HTTP server |
| Tunnel Client Port | 8888 | Local tunnel-client health, readiness, metrics, and UI server |

Both values accept integer TCP ports from 1 through 65535. Empty, non-integer, zero, negative, and out-of-range values are rejected. The Control Panel checks whether a changed port can be bound before saving it and reports a port-in-use error when the bind check fails.

## Persistence

- Windows: `%APPDATA%\DesktopMCP\settings.json`, in the `gatewayPort` and `tunnelClientPort` properties. Existing settings are preserved when the port properties are written.
- macOS: `UserDefaults.standard`, using the `gatewayPort` and `tunnelClientPort` keys in the DeskMCP application's preferences domain.

No credentials or environment-specific secrets are stored in these port settings.

## Gateway precedence

The effective Gateway port follows this order:

1. `DESKTOP_MCP_PORT` environment variable, when set and valid.
2. Saved Control Panel Gateway Port.
3. Default `8120`.

The Control Panel passes the effective value to the Gateway process through `DESKTOP_MCP_PORT`. The same effective port is used for Gateway health checks, graceful stop, restart, and the Tunnel MCP server URL. When `DESKTOP_MCP_PORT` is set, the Settings UI explains that it overrides the saved Gateway value; remove the environment variable to edit the Gateway port in Settings.

## Tunnel Client precedence and restart

DeskMCP starts `tunnel-client` with `HEALTH_LISTEN_ADDR=127.0.0.1:<Tunnel Client Port>`. The official tunnel-client configuration precedence is CLI flags, environment variables, YAML/profile configuration, then defaults. Therefore this runtime environment setting overrides the profile's `health.listen_addr` without rewriting unrelated profile configuration.

Changing either port saves the values and restarts the affected services. If a Tunnel is configured, DeskMCP regenerates its MCP server URL using the effective Gateway port and reconnects the Tunnel. The Tunnel status checks, health/readiness probes, metrics requests, and local UI URL use the configured Tunnel Client port.

## Manual scripts

- `scripts/configure-tunnel.ps1` accepts `-GatewayPort` and `-TunnelClientPort`; when omitted, it reads the saved Windows settings and falls back to the documented defaults. `DESKTOP_MCP_PORT` overrides `-GatewayPort`.
- `scripts/run-tunnel.ps1` and `scripts/doctor-tunnel.ps1` read the saved Windows Tunnel Client port and set `HEALTH_LISTEN_ADDR` only when the caller has not already supplied it.
- Release signing probes the Gateway on `DESKTOP_MCP_PORT`, or `8120` when it is unset.

## Platform behavior

Windows persists both values in the existing JSON settings document. macOS persists the same keys in its existing UserDefaults store. Both panels validate the same TCP port range, display the same defaults, and pass the effective ports to the service processes.