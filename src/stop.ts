import { requestShutdown } from './control-server.js';
import { DEFAULT_GATEWAY_PORT, resolveGatewayPort } from './ports.js';

const rawPort = process.argv[2] ?? process.env.DESKTOP_MCP_PORT ?? String(DEFAULT_GATEWAY_PORT);
const port = resolveGatewayPort(rawPort);

const response = await requestShutdown(port);
if (response !== 'OK shutdown') {
  throw new Error(`Unexpected DeskMCP control response: ${response}`);
}

console.error(`[deskmcp] graceful shutdown requested on port ${port}`);
