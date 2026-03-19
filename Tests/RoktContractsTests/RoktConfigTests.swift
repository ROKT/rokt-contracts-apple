import XCTest
@testable import RoktContracts

final class RoktConfigTests: XCTestCase {

    private let maxCacheDuration = RoktConfig.CacheConfig.maxCacheDuration

    // MARK: - Builder defaults

    func testBuilderDefaults() {
        let config = RoktConfig.Builder().build()
        XCTAssertEqual(config.colorMode, .system)
        XCTAssertFalse(config.cacheConfig.isCacheEnabled())
    }

    func testBuilderWithColorMode() {
        let config = RoktConfig.Builder()
            .colorMode(.dark)
            .build()
        XCTAssertEqual(config.colorMode, .dark)
        XCTAssertFalse(config.cacheConfig.isCacheEnabled())
    }

    func testBuilderWithCacheConfig() {
        let config = RoktConfig.Builder()
            .cacheConfig(RoktConfig.CacheConfig())
            .build()
        XCTAssertTrue(config.cacheConfig.isCacheEnabled())
        XCTAssertEqual(config.cacheConfig.cacheDuration, maxCacheDuration)
    }

    func testBuilderWithBoth() {
        let config = RoktConfig.Builder()
            .colorMode(.light)
            .cacheConfig(RoktConfig.CacheConfig(
                cacheDuration: TimeInterval(10 * 60),
                cacheAttributes: ["email": "test@rokt.com"]
            ))
            .build()
        XCTAssertEqual(config.colorMode, .light)
        XCTAssertTrue(config.cacheConfig.isCacheEnabled())
        XCTAssertEqual(config.cacheConfig.cacheDuration, TimeInterval(10 * 60))
        XCTAssertEqual(config.cacheConfig.cacheAttributes, ["email": "test@rokt.com"])
    }

    // MARK: - CacheConfig

    func testCacheConfigDefaults() {
        let cache = RoktConfig.CacheConfig()
        XCTAssertEqual(cache.cacheDuration, maxCacheDuration)
        XCTAssertNil(cache.cacheAttributes)
        XCTAssertTrue(cache.isCacheEnabled())
    }

    func testCacheConfigWithValidDuration() {
        let cache = RoktConfig.CacheConfig(cacheDuration: TimeInterval(10 * 60))
        XCTAssertEqual(cache.cacheDuration, TimeInterval(10 * 60))
    }

    func testCacheConfigWithOverMaxDuration() {
        let cache = RoktConfig.CacheConfig(cacheDuration: TimeInterval(100 * 60))
        XCTAssertEqual(cache.cacheDuration, maxCacheDuration)
    }

    func testCacheConfigWithCacheAttributes() {
        let attrs = ["country": "US"]
        let cache = RoktConfig.CacheConfig(cacheAttributes: attrs)
        XCTAssertEqual(cache.cacheAttributes, attrs)
    }

    func testGetCacheAttributesOrFallback_withNil_returnsFallback() {
        let cache = RoktConfig.CacheConfig()
        let fallback = ["email": "test@rokt.com"]
        XCTAssertEqual(cache.getCacheAttributesOrFallback(fallback), fallback)
    }

    func testGetCacheAttributesOrFallback_withAttributes_returnsCacheAttributes() {
        let attrs = ["country": "US"]
        let cache = RoktConfig.CacheConfig(cacheAttributes: attrs)
        let fallback = ["email": "test@rokt.com"]
        XCTAssertEqual(cache.getCacheAttributesOrFallback(fallback), attrs)
    }

    // MARK: - ColorMode

    func testColorModeValues() {
        XCTAssertEqual(RoktColorMode.light.rawValue, 0)
        XCTAssertEqual(RoktColorMode.dark.rawValue, 1)
        XCTAssertEqual(RoktColorMode.system.rawValue, 2)
    }
}
