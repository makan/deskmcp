$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'port-defaults.ps1')
$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
. (Join-Path $PSScriptRoot 'resolve-tunnel-client.ps1')
$TunnelClient = Resolve-DeskMcpTunnelClient -ProjectRoot $Root
if ([string]::IsNullOrWhiteSpace($env:HEALTH_LISTEN_ADDR)) {
  $settingsPath = Join-Path $env:APPDATA 'DesktopMCP\settings.json'
  $settings = if (Test-Path -LiteralPath $settingsPath) { Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json } else { $null }
  $port = if ($settings.tunnelClientPort -ge 1 -and $settings.tunnelClientPort -le 65535) { [int]$settings.tunnelClientPort } else { $DeskMCPDefaultTunnelClientPort }
  $env:HEALTH_LISTEN_ADDR = "127.0.0.1:$port"
}

if ([string]::IsNullOrWhiteSpace($env:CONTROL_PLANE_API_KEY)) {
  throw 'CONTROL_PLANE_API_KEY is not set in the current process environment.'
}

& $TunnelClient run --profile desktop-mcp
exit $LASTEXITCODE