import assert from 'node:assert/strict';
import test from 'node:test';
import { DEFAULT_GATEWAY_PORT, DEFAULT_TUNNEL_CLIENT_PORT, resolveGatewayPort } from '../src/ports.js';

test('Gateway default port is 8120', () => {
  assert.equal(DEFAULT_GATEWAY_PORT, 8120);
  assert.equal(DEFAULT_TUNNEL_CLIENT_PORT, 8888);
  assert.equal(resolveGatewayPort(String(DEFAULT_GATEWAY_PORT)), 8120);
});

test('Gateway port accepts valid TCP port boundaries', () => {
  assert.equal(resolveGatewayPort('1'), 1);
  assert.equal(resolveGatewayPort('65535'), 65535);
});

test('Gateway port rejects empty, non-integer, and out-of-range values', () => {
  for (const value of ['', ' ', '0', '-1', '65536', '8120x', '8.12e3', '1.5']) {
    assert.throws(() => resolveGatewayPort(value), /Invalid DeskMCP port/);
  }
});
