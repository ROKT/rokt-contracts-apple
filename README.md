# RoktContracts

Shared protocols and value types for the Rokt Apple SDK ecosystem.

RoktContracts is a lightweight, standalone Swift package that defines the shared API surface across the Rokt SDK, mParticle Apple SDK, mParticle-Rokt Kit, and payment extensions. It contains **only protocols and value types** — no implementations, no external dependencies.

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ROKT/rokt-contracts-apple.git", from: "1.0.0"),
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

`RoktEvent` is the base class for all events emitted during the Rokt placement lifecycle. All 14 event subclasses use `@objc` annotations for Objective-C interoperability.

| Event                               | Description                                               |
| ----------------------------------- | --------------------------------------------------------- |
| `RoktEvent.InitComplete`            | SDK initialization result (`success: Bool`)               |
| `RoktEvent.ShowLoadingIndicator`    | SDK is calling the Rokt backend                           |
| `RoktEvent.HideLoadingIndicator`    | SDK received response from backend                        |
| `RoktEvent.PlacementReady`          | Placement ready but not yet rendered                      |
| `RoktEvent.PlacementInteractive`    | Placement rendered and interactable                       |
| `RoktEvent.PlacementClosed`         | User dismissed the placement                              |
| `RoktEvent.PlacementCompleted`      | No more offers to display                                 |
| `RoktEvent.PlacementFailure`        | Placement could not be displayed                          |
| `RoktEvent.OfferEngagement`         | User engaged with an offer                                |
| `RoktEvent.PositiveEngagement`      | User positively engaged                                   |
| `RoktEvent.FirstPositiveEngagement` | First positive engagement (includes fulfillment callback) |
| `RoktEvent.OpenUrl`                 | User pressed a URL for partner app handling               |
| `RoktEvent.CartItemInstantPurchase` | Purchase made through Shoppable Ads                       |
| `RoktEvent.EmbeddedSizeChanged`     | Embedded placement height changed                         |

#### Usage

```swift
import RoktContracts

onEvent: { event in
    switch event {
    case let e as RoktEvent.InitComplete:
        print("Init: \(e.success)")
    case let e as RoktEvent.PlacementReady:
        print("Ready: \(e.placementId ?? "")")
    case let e as RoktEvent.EmbeddedSizeChanged:
        print("Height: \(e.updatedHeight)")
    case let e as RoktEvent.CartItemInstantPurchase:
        print("Purchase: \(e.name ?? "") \(e.totalPrice ?? 0) \(e.currency)")
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

`PaymentExtension` defines the contract for Shoppable Ads payment integrations. Payment extensions depend only on RoktContracts, not the full Rokt SDK:

```swift
class StripePaymentExtension: PaymentExtension {
    var id: String { "stripe" }
    var extensionDescription: String { "Stripe Payments" }
    var supportedMethods: [PaymentMethodType] { [.applePay, .card] }

    func onRegister(parameters: [String: String]) -> Bool { /* ... */ }
    func onUnregister() { /* ... */ }
    func presentPaymentSheet(/* ... */) { /* ... */ }
}
```

Supporting value types: `PaymentMethodType`, `PaymentItem`, `PaymentResult`, `PaymentPreparation`, `ContactAddress`.

## Package Structure

```text
Sources/RoktContracts/
├── Events/
│   └── RoktEvent.swift             14 event subclasses
├── Config/
│   └── RoktConfig.swift            RoktConfig + RoktColorMode
├── Views/
│   └── RoktEmbeddedView.swift      UIView for embedded placements
├── Internal/
│   └── RoktPlacementOptions.swift  SDK-Kit performance tracking
└── Payment/
    ├── PaymentExtension.swift      Protocol for payment integrations
    └── PaymentTypes.swift          Value types (Sendable)
```

## Requirements

- iOS 15.0+ / tvOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## Objective-C Compatibility

All shared types use `@objc` annotations and are fully accessible from Objective-C:

```objc
RoktConfig *config = [[RoktConfig alloc] init];
config.colorMode = RoktColorModeLight;
```

Event classes use flattened ObjC names (e.g. `RoktPlacementReady`, `RoktCartItemInstantPurchase`).

## License

See [LICENSE.md](LICENSE.md) for details.

## Security

See [SECURITY.md](SECURITY.md) for reporting vulnerabilities.
