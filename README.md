# RoktContracts

Shared protocols and value types for the Rokt Apple SDK ecosystem.

RoktContracts is a lightweight, standalone Swift package that defines the shared API surface across the Rokt SDK, mParticle Apple SDK, mParticle-Rokt Kit, and payment extensions. It contains **only protocols and value types** — no implementations, no external dependencies.

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ROKT/rokt-contracts-apple.git", from: "0.1.0"),
]
```

Then add `"RoktContracts"` to the target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["RoktContracts"]
),
```

### CocoaPods

Add the pod to your `Podfile`:

```ruby
pod 'RoktContracts', '~> 1.0'
```

Then run:

```bash
pod install
```

## What's Inside

### Events

`RoktEvent` is the base class for all events emitted during the Rokt placement lifecycle. All 18 event subclasses use `@objc` annotations for Objective-C interoperability.

| Event                                        | Description                                               |
| -------------------------------------------- | --------------------------------------------------------- |
| `RoktEvent.InitComplete`                     | SDK initialization result (`success: Bool`)               |
| `RoktEvent.ShowLoadingIndicator`             | SDK is calling the Rokt backend                           |
| `RoktEvent.HideLoadingIndicator`             | SDK received response from backend                        |
| `RoktEvent.PlacementReady`                   | Placement ready but not yet rendered                      |
| `RoktEvent.PlacementInteractive`             | Placement rendered and interactable                       |
| `RoktEvent.PlacementClosed`                  | User dismissed the placement                              |
| `RoktEvent.PlacementCompleted`               | No more offers to display                                 |
| `RoktEvent.PlacementFailure`                 | Placement could not be displayed                          |
| `RoktEvent.OfferEngagement`                  | User engaged with an offer                                |
| `RoktEvent.PositiveEngagement`               | User positively engaged                                   |
| `RoktEvent.FirstPositiveEngagement`          | First positive engagement (includes fulfillment callback) |
| `RoktEvent.OpenUrl`                          | User pressed a URL for partner app handling               |
| `RoktEvent.CartItemInstantPurchaseInitiated` | Purchase initiated for a catalog item                     |
| `RoktEvent.CartItemInstantPurchase`          | Purchase completed through Shoppable Ads                  |
| `RoktEvent.CartItemInstantPurchaseFailure`   | Purchase failed for a catalog item                        |
| `RoktEvent.InstantPurchaseDismissal`         | User dismissed the instant purchase overlay               |
| `RoktEvent.CartItemDevicePay`                | Device payment (Apple Pay) triggered                      |
| `RoktEvent.EmbeddedSizeChanged`              | Embedded placement height changed                         |

#### Usage

```swift
import RoktContracts

onEvent: { event in
    switch event {
    case let e as RoktEvent.InitComplete:
        print("Init: \(e.success)")
    case let e as RoktEvent.PlacementReady:
        print("Ready: \(e.identifier ?? "")")
    case let e as RoktEvent.EmbeddedSizeChanged:
        print("Height: \(e.updatedHeight)")
    case let e as RoktEvent.CartItemInstantPurchaseInitiated:
        print("Purchase initiated: \(e.catalogItemId)")
    case let e as RoktEvent.CartItemInstantPurchase:
        print("Purchase: \(e.name ?? "") \(e.totalPrice ?? 0) \(e.currency)")
    case let e as RoktEvent.CartItemInstantPurchaseFailure:
        print("Purchase failed: \(e.error ?? "unknown")")
    case let e as RoktEvent.InstantPurchaseDismissal:
        print("Dismissed: \(e.identifier)")
    case let e as RoktEvent.CartItemDevicePay:
        print("Device pay: \(e.paymentProvider) for \(e.catalogItemId)")
    default:
        break
    }
}
```

### Configuration

`RoktConfig` controls placement behavior:

```swift
let config = RoktConfig(
    cacheDuration: NSNumber(value: 3600),   // seconds, max 5400
    cacheAttributes: ["region": "US"],      // cache key subset
    colorMode: .dark                        // .light | .dark | .system
)
```

### Embedded Views

`RoktEmbeddedView` is a `UIView` subclass for inline embedded placements:

```swift
let embeddedView = RoktEmbeddedView(frame: .zero)
stackView.addArrangedSubview(embeddedView)

rokt.selectPlacements(
    "ConfirmationPage",
    attributes: attributes,
    embeddedViews: ["RoktEmbedded1": embeddedView]
)
```

### Payment Extension Protocol

`PaymentExtension` defines the contract for Shoppable Ads payment integrations. Payment extensions depend only on RoktContracts, not the full Rokt SDK. In Objective-C the protocol is exposed as **`RoktPaymentExtension`**.

```swift
class StripePaymentExtension: PaymentExtension {
    var id: String { "stripe" }
    var extensionDescription: String { "Stripe Payments" }
    var supportedMethods: [String] {
        [PaymentMethodType.applePay.wireValue, PaymentMethodType.card.wireValue]
    }

    func onRegister(parameters: [String: String]) -> Bool { /* ... */ }
    func onUnregister() { /* ... */ }

    #if canImport(UIKit)
    func presentPaymentSheet(
        item: PaymentItem,
        method: PaymentMethodType,
        from viewController: UIViewController,
        preparePayment: @escaping (
            _ address: ContactAddress,
            _ completion: @escaping (PaymentPreparation?, Error?) -> Void
        ) -> Void,
        completion: @escaping (PaymentSheetResult) -> Void
    ) { /* ... */ }
    #endif
}
```

`supportedMethods` returns stable wire strings (`apple_pay`, `card`; see `PaymentMethodType.wireValue`). `PaymentMethodType` uses integer raw values for Objective-C (`RoktPaymentMethodType` / `NS_ENUM`).

Payment sheet types are `NSObject` subclasses (or `NS_ENUM`) so they work with **`@objc(RoktPaymentExtension)`**, including `presentPaymentSheet`: `preparePayment` uses a completion handler (not `async`/`throws`), and the final `completion` receives **`PaymentSheetResult`** (`RoktPaymentSheetResult` / `RoktPaymentSheetOutcome`) instead of a Swift enum with associated values.

## Package Structure

```text
Sources/RoktContracts/
├── Events/
│   └── RoktEvent.swift             18 event subclasses
├── Config/
│   └── RoktConfig.swift            RoktConfig + RoktColorMode
├── Views/
│   └── RoktEmbeddedView.swift      UIView for embedded placements
├── Internal/
│   └── RoktPlacementOptions.swift  SDK-Kit performance tracking
└── Payment/
    ├── PaymentExtension.swift      Protocol for payment integrations
    └── PaymentTypes.swift          Payment models (`NSObject` / enums for ObjC)
```

## Requirements

- iOS 13.0+ / tvOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## Objective-C Compatibility

Core types use `@objc` annotations so they are usable from Objective-C where supported:

```objc
RoktConfig *config = [[RoktConfig alloc] init];
config.colorMode = RoktColorModeLight;
```

Event classes use flattened Objective-C names (for example `RoktPlacementReady`, `RoktCartItemInstantPurchase`, `RoktCartItemDevicePay`).

Payment integration exposes **`RoktPaymentExtension`**, **`RoktPaymentMethodType`**, and sheet model types (for example **`RoktPaymentItem`**, **`RoktContactAddress`**, **`RoktPaymentPreparation`**, **`RoktPaymentSheetResult`**).

Pure Swift-only types elsewhere in the package (if any) are not visible to Objective-C unless noted above.

## License

See [LICENSE.md](LICENSE.md) for details.

## Security

See [SECURITY.md](SECURITY.md) for reporting vulnerabilities.
