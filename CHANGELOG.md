# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - Unreleased

### Added

- `RoktEvent.CartItemInstantPurchaseInitiated` — purchase initiated for a catalog item
- `RoktEvent.CartItemInstantPurchaseFailure` — purchase failed for a catalog item
- `RoktEvent.InstantPurchaseDismissal` — user dismissed the instant purchase overlay
- `RoktEvent.CartItemDevicePay` — device payment (Apple Pay) triggered for a catalog item

### Changed

- Clarified `RoktEvent.CartItemInstantPurchase` documentation as the purchase-completed event

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
