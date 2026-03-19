# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - Unreleased

### Added

- `RoktEvent` base class with 13 event subclasses for placement lifecycle and user interactions
- `RoktConfig` for placement configuration (color mode, caching)
- `RoktColorMode` enum (light, dark, system)
- `RoktEventCallback` for placement lifecycle callbacks
- `RoktEmbeddedView` for inline embedded placements (iOS/tvOS)
- `RoktPlacementOptions` for internal SDK-Kit performance tracking
- `PaymentExtension` protocol for Shoppable Ads payment integrations
- `PaymentMethodType`, `PaymentItem`, `PaymentResult`, `PaymentPreparation`, `ContactAddress` value types
- Swift Package Manager support
- CocoaPods support
