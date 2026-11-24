import XCTest
@testable import DeskMCPCore

final class ServicePortSettingsTests: XCTestCase {
    func testDefaults() {
        XCTAssertEqual(DeskMCPServicePorts.defaultGatewayPort, 8120)
        XCTAssertEqual(DeskMCPServicePorts.defaultTunnelClientPort, 8888)
    }

    func testValidPortBoundaries() {
        XCTAssertTrue(DeskMCPServicePorts.isValid(1))
        XCTAssertTrue(DeskMCPServicePorts.isValid(65535))
        XCTAssertFalse(DeskMCPServicePorts.isValid(0))
        XCTAssertFalse(DeskMCPServicePorts.isValid(-1))
        XCTAssertFalse(DeskMCPServicePorts.isValid(65536))
    }

    func testGatewayEnvironmentOverridePrecedesSavedPort() {
        XCTAssertEqual(DeskMCPServicePorts.resolveGatewayPort(saved: 9000, environment: "8120"), 8120)
        XCTAssertEqual(DeskMCPServicePorts.resolveGatewayPort(saved: 9000, environment: nil), 9000)
        XCTAssertEqual(DeskMCPServicePorts.resolveGatewayPort(saved: 9000, environment: ""), 9000)
        XCTAssertEqual(DeskMCPServicePorts.resolveGatewayPort(saved: 9000, environment: "invalid"), 9000)
    }

    func testGatewayAndTunnelClientPortsMustBeDifferent() {
        XCTAssertFalse(DeskMCPServicePorts.portsConflict(savedGateway: 8120, environment: nil, tunnelClient: 8888))
        XCTAssertTrue(DeskMCPServicePorts.portsConflict(savedGateway: 9000, environment: nil, tunnelClient: 9000))
        // DESKTOP_MCP_PORT overrides the saved Gateway port, so the effective value is compared.
        XCTAssertTrue(DeskMCPServicePorts.portsConflict(savedGateway: 8120, environment: "8888", tunnelClient: 8888))
        XCTAssertFalse(DeskMCPServicePorts.portsConflict(savedGateway: 8888, environment: "9000", tunnelClient: 8888))
        // An invalid override is ignored and the saved value is compared.
        XCTAssertTrue(DeskMCPServicePorts.portsConflict(savedGateway: 8888, environment: "invalid", tunnelClient: 8888))
    }

    func testStrictParsing() {
        XCTAssertEqual(DeskMCPServicePorts.parse("8120"), 8120)
        XCTAssertEqual(DeskMCPServicePorts.parse(" 8888 "), 8888)
        XCTAssertNil(DeskMCPServicePorts.parse(""))
        XCTAssertNil(DeskMCPServicePorts.parse("8120x"))
        XCTAssertNil(DeskMCPServicePorts.parse("+8120"))
        XCTAssertNil(DeskMCPServicePorts.parse("1.5"))
        XCTAssertNil(DeskMCPServicePorts.parse("0"))
        XCTAssertNil(DeskMCPServicePorts.parse("-1"))
        XCTAssertNil(DeskMCPServicePorts.parse("65536"))
    }
}