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
/// Use `RoktConfig.Builder` to construct a configuration with color mode
/// and optional caching behavior.
///
/// ## Example
///
/// ```swift
/// let config = RoktConfig.Builder()
///     .colorMode(.dark)
///     .cacheConfig(RoktConfig.CacheConfig(
///         cacheDuration: TimeInterval(3600),
///         cacheAttributes: ["region": "US"]
///     ))
///     .build()
/// ```
@objc(RoktConfig)
public class RoktConfig: NSObject {
    /// Color mode for Rokt UI placements.
    @objc public let colorMode: RoktColorMode

    /// Cache configuration. If `nil`, caching is disabled.
    @objc public let cacheConfig: CacheConfig

    init(colorMode: RoktColorMode, cacheConfig: CacheConfig) {
        self.colorMode = colorMode
        self.cacheConfig = cacheConfig
        super.init()
    }

    // MARK: - CacheConfig

    /// Configuration for caching of layouts.
    ///
    /// Providing a `CacheConfig` to the builder enables caching.
    /// Not providing one (the default) disables caching.
    ///
    /// - `cacheDuration`: Maximum cache duration in seconds (max 5400 / 90 minutes).
    ///   If invalid, defaults to 90 minutes.
    /// - `cacheAttributes`: Subset of placement attributes used as the cache key.
    ///   If `nil`, all attributes are used.
    @objc(RoktCacheConfig)
    public class CacheConfig: NSObject {
        /// The duration for which the experience should be cached, in seconds.
        @objc public let cacheDuration: TimeInterval

        /// Optional attributes used as the cache key; if nil, falls back to all attributes.
        @objc public let cacheAttributes: [String: String]?

        /// Internal flag indicating whether caching is enabled.
        let enableCache: Bool

        /// Maximum allowed cache duration (90 minutes).
        @objc public static let maxCacheDuration = TimeInterval(90 * 60)

        /// Initializes the cache configuration with caching enabled.
        ///
        /// - Parameters:
        ///   - cacheDuration: Duration in seconds. Maximum is 90 minutes; defaults to 90 minutes if not provided or invalid.
        ///   - cacheAttributes: Optional attributes to use as cache key. If nil, all attributes from `selectPlacements` are used.
        @objc public init(
            cacheDuration: TimeInterval = maxCacheDuration,
            cacheAttributes: [String: String]? = nil
        ) {
            self.cacheDuration = (cacheDuration > 0 && cacheDuration < CacheConfig.maxCacheDuration)
                ? cacheDuration
                : CacheConfig.maxCacheDuration
            self.cacheAttributes = cacheAttributes
            enableCache = true
            super.init()
        }

        /// Internal initializer allowing explicit control over whether caching is enabled.
        init(
            cacheDuration: TimeInterval = maxCacheDuration,
            cacheAttributes: [String: String]? = nil,
            enableCache: Bool
        ) {
            self.cacheDuration = (cacheDuration > 0 && cacheDuration < CacheConfig.maxCacheDuration)
                ? cacheDuration
                : CacheConfig.maxCacheDuration
            self.cacheAttributes = cacheAttributes
            self.enableCache = enableCache
            super.init()
        }

        /// Returns the configured cache attributes, or falls back to the provided attributes.
        @objc public func getCacheAttributesOrFallback(
            _ fallbackAttributes: [String: String]
        ) -> [String: String] {
            return cacheAttributes ?? fallbackAttributes
        }

        /// Whether caching is enabled.
        @objc public func isCacheEnabled() -> Bool {
            return enableCache
        }
    }

    // MARK: - Builder

    /// Builder for constructing `RoktConfig` instances.
    ///
    /// ```swift
    /// let config = RoktConfig.Builder()
    ///     .colorMode(.dark)
    ///     .cacheConfig(RoktConfig.CacheConfig())
    ///     .build()
    /// ```
    @objc(RoktConfigBuilder)
    public class Builder: NSObject {
        private var _colorMode: RoktColorMode?
        private var _cacheConfig: CacheConfig?

        /// Sets the color mode.
        @objc @discardableResult
        public func colorMode(_ colorMode: RoktColorMode) -> Builder {
            _colorMode = colorMode
            return self
        }

        /// Sets the cache configuration. Providing a `CacheConfig` enables caching.
        @objc @discardableResult
        public func cacheConfig(_ cacheConfig: CacheConfig) -> Builder {
            _cacheConfig = cacheConfig
            return self
        }

        /// Builds the `RoktConfig`.
        ///
        /// If no color mode is set, defaults to `.system`.
        /// If no cache config is set, caching is disabled.
        @objc public func build() -> RoktConfig {
            return RoktConfig(
                colorMode: _colorMode ?? .system,
                cacheConfig: _cacheConfig ?? CacheConfig(enableCache: false)
            )
        }
    }
}
