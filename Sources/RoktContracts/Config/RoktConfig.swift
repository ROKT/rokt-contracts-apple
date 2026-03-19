import Foundation

/// Color mode for Rokt UI placements.
///
/// Controls the visual theme of Rokt placements. When set to ``system``,
/// the placement follows the device's current appearance setting.
///
/// - Note: In Objective-C, use `RoktColorModeLight`, `RoktColorModeDark`, `RoktColorModeSystem`.
@objc(RoktColorMode)
public enum RoktColorMode: Int {
    /// Light appearance.
    case light = 0
    /// Dark appearance.
    case dark = 1
    /// Follow the system appearance setting.
    case system = 2
}

/// Configuration for Rokt placements.
///
/// Use `RoktConfig` to customize placement behavior including color mode,
/// caching behavior, and cache key attributes.
///
/// ## Example
///
/// ```swift
/// let config = RoktConfig(
///     cacheDuration: NSNumber(value: 3600),
///     cacheAttributes: ["region": "US"],
///     colorMode: .dark
/// )
/// ```
///
/// ### Cache Behavior
///
/// - `cacheDuration`: Maximum cache duration in seconds (max 5400 / 90 minutes).
///   If `nil` or invalid, defaults to 90 minutes.
/// - `cacheAttributes`: Subset of placement attributes used as the cache key.
///   If `nil`, all attributes are used.
@objc(RoktConfig)
public class RoktConfig: NSObject {
    /// Maximum duration for the placement cache, in seconds.
    /// Maximum allowed value is 5400 (90 minutes). Defaults to 90 minutes if nil.
    @objc public var cacheDuration: NSNumber?

    /// Subset of attributes used as the cache key.
    /// If nil, all attributes passed to `selectPlacements` are used.
    @objc public var cacheAttributes: [String: String]?

    /// Color mode for Rokt UI placements.
    @objc public var colorMode: RoktColorMode = .system

    @objc override public init() { super.init() }

    @objc public init(
        cacheDuration: NSNumber? = nil,
        cacheAttributes: [String: String]? = nil,
        colorMode: RoktColorMode = .system
    ) {
        self.cacheDuration = cacheDuration
        self.cacheAttributes = cacheAttributes
        self.colorMode = colorMode
        super.init()
    }
}
