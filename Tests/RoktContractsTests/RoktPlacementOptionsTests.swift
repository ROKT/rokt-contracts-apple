import XCTest
@testable import RoktContracts

final class RoktPlacementOptionsTests: XCTestCase {

    func testInit() {
        let options = RoktPlacementOptions(timestamp: 1710000000000)
        XCTAssertEqual(options.jointSdkSelectPlacements, 1710000000000)
        XCTAssertTrue(options.dynamicPerformanceMarkers.isEmpty)
    }

    func testSetPerformanceMarker() {
        let options = RoktPlacementOptions(timestamp: 1710000000000)
        options.setDynamicPerformanceMarkerValue(NSNumber(value: 1710000000100), forKey: "sdk_forward_start")
        XCTAssertEqual(options.dynamicPerformanceMarkers["sdk_forward_start"], NSNumber(value: 1710000000100))
    }

    func testMultipleMarkers() {
        let options = RoktPlacementOptions(timestamp: 1000)
        options.setDynamicPerformanceMarkerValue(NSNumber(value: 1100), forKey: "marker_a")
        options.setDynamicPerformanceMarkerValue(NSNumber(value: 1200), forKey: "marker_b")
        XCTAssertEqual(options.dynamicPerformanceMarkers.count, 2)
    }
}
