export const DEFAULT_GATEWAY_PORT = 8120;
export const DEFAULT_TUNNEL_CLIENT_PORT = 8888;

export function resolveGatewayPort(raw: string): number {
  const value = raw.trim();
  if (!/^\d+$/u.test(value)) {
    throw new Error(`Invalid DeskMCP port: ${raw}`);
  }
  const port = Number(value);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error(`Invalid DeskMCP port: ${raw}`);
  }
  return port;
}
