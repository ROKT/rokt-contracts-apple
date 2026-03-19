import Foundation

/// Internal SDK-Kit communication contract for performance tracking.
///
/// `RoktPlacementOptions` carries timing data between the mParticle SDK and
/// the Rokt Kit to measure integration performance. This type is not intended
/// for use by partner applications.
///
/// - Important: This is an internal type used by the SDK integration layer.
///   Partner applications should not create or modify instances directly.
@objc(RoktPlacementOptions)
public class RoktPlacementOptions: NSObject {
    /// Timestamp (milliseconds since epoch) when `selectPlacements` was called.
    @objc public let jointSdkSelectPlacements: Int64

    /// Dynamic performance markers for additional timing data.
    @objc public private(set) var dynamicPerformanceMarkers: [String: NSNumber] = [:]

    @objc public init(timestamp: Int64) {
        jointSdkSelectPlacements = timestamp
        super.init()
    }

    /// Records a performance marker with the given key and timestamp value.
    @objc public func setDynamicPerformanceMarkerValue(_ value: NSNumber, forKey key: String) {
        dynamicPerformanceMarkers[key] = value
    }
}
