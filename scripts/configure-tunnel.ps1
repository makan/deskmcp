param(
  [Parameter(Mandatory = $true)]
  [ValidatePattern('^tunnel_[A-Za-z0-9_-]+$')]
  [string]$TunnelId,
  [int]$GatewayPort = 0,
  [int]$TunnelClientPort = 0
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'port-defaults.ps1')
$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
. (Join-Path $PSScriptRoot 'resolve-tunnel-client.ps1')
$TunnelClient = Resolve-DeskMcpTunnelClient -ProjectRoot $Root
$settingsPath = Join-Path $env:APPDATA 'DesktopMCP\settings.json'
$settings = if (Test-Path -LiteralPath $settingsPath) { Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json } else { $null }
if (-not [string]::IsNullOrWhiteSpace($env:DESKTOP_MCP_PORT)) { $GatewayPort = [int]$env:DESKTOP_MCP_PORT }
elseif ($GatewayPort -eq 0 -and $settings.gatewayPort -ge 1 -and $settings.gatewayPort -le 65535) { $GatewayPort = [int]$settings.gatewayPort }
elseif ($GatewayPort -eq 0) { $GatewayPort = $DeskMCPDefaultGatewayPort }
if ($TunnelClientPort -eq 0 -and $settings.tunnelClientPort -ge 1 -and $settings.tunnelClientPort -le 65535) { $TunnelClientPort = [int]$settings.tunnelClientPort }
elseif ($TunnelClientPort -eq 0) { $TunnelClientPort = $DeskMCPDefaultTunnelClientPort }
if ($GatewayPort -lt 1 -or $GatewayPort -gt 65535) { throw 'GatewayPort must be between 1 and 65535.' }
if ($TunnelClientPort -lt 1 -or $TunnelClientPort -gt 65535) { throw 'TunnelClientPort must be between 1 and 65535.' }
if ($GatewayPort -eq $TunnelClientPort) { throw 'GatewayPort and TunnelClientPort must be different.' }
if ([string]::IsNullOrWhiteSpace($env:HEALTH_LISTEN_ADDR)) { $env:HEALTH_LISTEN_ADDR = "127.0.0.1:$TunnelClientPort" }

& $TunnelClient init `
  --sample sample_mcp_remote_no_auth `
  --profile desktop-mcp `
  --tunnel-id $TunnelId `
  --mcp-server-url "http://127.0.0.1:$GatewayPort/mcp"

if ($LASTEXITCODE -ne 0) {
  throw "tunnel-client init failed with exit code $LASTEXITCODE"
}

Write-Output 'DeskMCP tunnel profile initialized: desktop-mcp'
Write-Output 'Next: set CONTROL_PLANE_API_KEY in this process environment, then run doctor-tunnel.ps1.'