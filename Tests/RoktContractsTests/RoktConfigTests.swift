import XCTest
@testable import RoktContracts

final class RoktConfigTests: XCTestCase {

    func testDefaultInit() {
        let config = RoktConfig()
        XCTAssertNil(config.cacheDuration)
        XCTAssertNil(config.cacheAttributes)
        XCTAssertEqual(config.colorMode, .system)
    }

    func testCustomInit() {
        let config = RoktConfig(
            cacheDuration: NSNumber(value: 3600),
            cacheAttributes: ["region": "US"],
            colorMode: .dark
        )
        XCTAssertEqual(config.cacheDuration, NSNumber(value: 3600))
        XCTAssertEqual(config.cacheAttributes, ["region": "US"])
        XCTAssertEqual(config.colorMode, .dark)
    }

    func testColorModeValues() {
        XCTAssertEqual(RoktColorMode.light.rawValue, 0)
        XCTAssertEqual(RoktColorMode.dark.rawValue, 1)
        XCTAssertEqual(RoktColorMode.system.rawValue, 2)
    }

    func testMutableProperties() {
        let config = RoktConfig()
        config.cacheDuration = NSNumber(value: 5400)
        config.cacheAttributes = ["email": "test@example.com"]
        config.colorMode = .light
        XCTAssertEqual(config.cacheDuration, NSNumber(value: 5400))
        XCTAssertEqual(config.cacheAttributes?["email"], "test@example.com")
        XCTAssertEqual(config.colorMode, .light)
    }
}
