# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2026-07-01

### Added

- Add `isRetryable` to `PaymentSheetResult` so transient payment failures (network / timeout / HTTP 429 / 5xx) can be surfaced as retryable, letting the host UI keep the offer for a retry. Backward-compatible: existing initializers and `failed(error:)` default it to `false`.

## [2.0.2] - 2026-05-18

### Added

- Add address line 2 to ContactAddress ([#25](https://github.com/ROKT/rokt-contracts-apple/pull/25))

### Changed

- Bump actions/create-github-app-token from 3.1.1 to 3.2.0 ([#24](https://github.com/ROKT/rokt-contracts-apple/pull/24))

## [2.0.1] - 2026-04-27

### Fixed

- Include PayPal Approval Url in PaymentPreparation ([#22](https://github.com/ROKT/rokt-contracts-apple/pull/22))

## [2.0.0] - 2026-04-23

### Added

- Add PayPal as a PaymentMethodType ([#19](https://github.com/ROKT/rokt-contracts-apple/pull/19))
- Add totals to payment preparation ([#20](https://github.com/ROKT/rokt-contracts-apple/pull/20))

## [1.0.0] - 2026-04-17

### Added

- Add payment context for afterpay flows ([#17](https://github.com/ROKT/rokt-contracts-apple/pull/17))

### Changed

- Bump actions/create-github-app-token from 3.0.0 to 3.1.1 ([#15](https://github.com/ROKT/rokt-contracts-apple/pull/15))
- Bump peter-evans/create-pull-request from 8.1.0 to 8.1.1 ([#16](https://github.com/ROKT/rokt-contracts-apple/pull/16))
- Use GitHub App token and shared workflow for trunk upgrade ([#12](https://github.com/ROKT/rokt-contracts-apple/pull/12))

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
