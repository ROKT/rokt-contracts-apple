# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.3] - 2026-04-02

### Added

- Make PaymentExtension Available in ObjC ([#13](https://github.com/ROKT/rokt-contracts-apple/pull/13))

### Fixed

- Drop v-prefix from release tags to match podspec ([#8](https://github.com/ROKT/rokt-contracts-apple/pull/8))

### Changed

- Upgrade trunk to 1.25.0 ([#10](https://github.com/ROKT/rokt-contracts-apple/pull/10))
- Bump codecov/codecov-action from 5.5.3 to 6.0.0 ([#11](https://github.com/ROKT/rokt-contracts-apple/pull/11))
- Bump peter-evans/create-pull-request from 7.0.11 to 8.1.0 ([#9](https://github.com/ROKT/rokt-contracts-apple/pull/9))

## [0.1.2] - 2026-03-24

### Added

- Add Shoppable Ads payment lifecycle events ([#5](https://github.com/ROKT/rokt-contracts-apple/pull/5))
- `RoktEvent.CartItemInstantPurchaseInitiated` — purchase initiated for a catalog item
- `RoktEvent.CartItemInstantPurchaseFailure` — purchase failed for a catalog item
- `RoktEvent.InstantPurchaseDismissal` — user dismissed the instant purchase overlay
- `RoktEvent.CartItemDevicePay` — device payment (Apple Pay) triggered for a catalog item

### Fixed

- Fix release workflows not appearing in GitHub Actions ([#6](https://github.com/ROKT/rokt-contracts-apple/pull/6))

## [0.1.0] - 2026-03-24

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
