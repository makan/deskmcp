import Foundation

public enum DeskMCPServicePorts {
    public static let defaultGatewayPort = 8120
    public static let defaultTunnelClientPort = 8888

    public static func isValid(_ port: Int) -> Bool {
        (1...65535).contains(port)
    }

    public static func parse(_ value: String) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              trimmed.utf8.allSatisfy({ $0 >= 48 && $0 <= 57 }),
              let port = Int(trimmed), isValid(port) else { return nil }
        return port
    }

    public static func resolveGatewayPort(saved: Int, environment: String?) -> Int {
        if let raw = environment?.trimmingCharacters(in: .whitespacesAndNewlines),
           !raw.isEmpty, let override = parse(raw) { return override }
        return isValid(saved) ? saved : defaultGatewayPort
    }

    /// True when the effective Gateway port (after any DESKTOP_MCP_PORT override) equals the Tunnel Client port.
    public static func portsConflict(savedGateway: Int, environment: String?, tunnelClient: Int) -> Bool {
        resolveGatewayPort(saved: savedGateway, environment: environment) == tunnelClient
    }
}