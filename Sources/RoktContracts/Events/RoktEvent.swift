import CoreGraphics
import Foundation

/// Base class for all Rokt SDK events shared across the ecosystem.
///
/// `RoktEvent` defines the event hierarchy emitted by the Rokt SDK during
/// placement lifecycle and user interactions. All subclasses use `@objc`
/// annotations for Objective-C interoperability.
///
/// Previously defined as `MPRoktEvent` in mParticle Core — now shared via
/// RoktContracts so the same types flow from SDK → Kit → mParticle → Partner
/// without translation.
///
/// ## Event Types
///
/// - ``InitComplete``: SDK initialization result
/// - ``ShowLoadingIndicator``: SDK is calling the Rokt backend
/// - ``HideLoadingIndicator``: SDK received response from backend
/// - ``PlacementReady``: Placement is ready but not yet rendered
/// - ``PlacementInteractive``: Placement is rendered and interactable
/// - ``PlacementClosed``: User dismissed the placement
/// - ``PlacementCompleted``: No more offers to display
/// - ``PlacementFailure``: Placement could not be displayed
/// - ``OfferEngagement``: User engaged with an offer
/// - ``PositiveEngagement``: User positively engaged with an offer
/// - ``FirstPositiveEngagement``: First positive engagement (includes fulfillment callback)
/// - ``OpenUrl``: User pressed a URL configured for partner app handling
/// - ``CartItemInstantPurchase``: Purchase made through a Shoppable Ads placement
///
/// ## Usage
///
/// ```swift
/// onEvent: { event in
///     switch event {
///     case let e as RoktEvent.PlacementReady:
///         print("Ready: \(e.placementId ?? "")")
///     case let e as RoktEvent.CartItemInstantPurchase:
///         print("Purchase: \(e.name ?? "") \(e.totalPrice ?? 0) \(e.currency)")
///     default:
///         break
///     }
/// }
/// ```
@objc(RoktEvent)
public class RoktEvent: NSObject {
    // MARK: - Initialization Events

    /// Emitted when the Rokt SDK completes initialization.
    @objc(RoktInitComplete)
    public class InitComplete: RoktEvent {
        /// Whether initialization was successful.
        @objc public let success: Bool

        @objc public init(success: Bool) {
            self.success = success
            super.init()
        }
    }

    // MARK: - Loading Indicator Events

    /// Emitted before the SDK calls the Rokt backend.
    /// The host app should show a loading indicator.
    @objc(RoktShowLoadingIndicator)
    public class ShowLoadingIndicator: RoktEvent {
        @objc override public init() { super.init() }
    }

    /// Emitted when the SDK receives a success or failure response from the backend.
    /// The host app should hide the loading indicator.
    @objc(RoktHideLoadingIndicator)
    public class HideLoadingIndicator: RoktEvent {
        @objc override public init() { super.init() }
    }

    // MARK: - Placement Lifecycle Events

    /// Emitted when a placement is ready but not yet rendered on screen.
    @objc(RoktPlacementReady)
    public class PlacementReady: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted when a placement has been rendered and is interactable by the user.
    @objc(RoktPlacementInteractive)
    public class PlacementInteractive: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted when a user closes/dismisses a placement.
    @objc(RoktPlacementClosed)
    public class PlacementClosed: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted when there are no more offers to display in the placement,
    /// or a cached placement was previously dismissed.
    @objc(RoktPlacementCompleted)
    public class PlacementCompleted: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted when a placement could not be displayed or no placements are available.
    @objc(RoktPlacementFailure)
    public class PlacementFailure: RoktEvent {
        /// The identifier of the placement, if available.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    // MARK: - Engagement Events

    /// Emitted when a user engages with an offer in the placement.
    @objc(RoktOfferEngagement)
    public class OfferEngagement: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted when a user positively engages with an offer.
    @objc(RoktPositiveEngagement)
    public class PositiveEngagement: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        @objc public init(placementId: String?) {
            self.placementId = placementId
            super.init()
        }
    }

    /// Emitted on the first positive engagement with an offer.
    /// Includes a fulfillment callback for setting post-engagement attributes.
    @objc(RoktFirstPositiveEngagement)
    public class FirstPositiveEngagement: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?

        /// Callback to set fulfillment attributes after the engagement.
        @objc public var setFulfillmentAttributes: (([String: String]) -> Void)?

        @objc public init(
            placementId: String?,
            setFulfillmentAttributes: (([String: String]) -> Void)? = nil
        ) {
            self.placementId = placementId
            self.setFulfillmentAttributes = setFulfillmentAttributes
            super.init()
        }
    }

    /// Emitted when a user presses a URL that is configured for partner app handling.
    @objc(RoktOpenUrl)
    public class OpenUrl: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String?
        /// The URL the user pressed.
        @objc public let url: String

        @objc public init(placementId: String?, url: String) {
            self.placementId = placementId
            self.url = url
            super.init()
        }
    }

    // MARK: - Embedded View Events

    /// Emitted when the height of an embedded placement changes.
    /// Use this to dynamically adjust the container view's height.
    ///
    /// - Note: This event is only emitted for embedded placements.
    @objc(RoktEmbeddedSizeChanged)
    public class EmbeddedSizeChanged: RoktEvent {
        /// The identifier of the placement whose height changed.
        @objc public let placementId: String
        /// The new height of the placement in points.
        @objc public let updatedHeight: CGFloat

        @objc public init(placementId: String, updatedHeight: CGFloat) {
            self.placementId = placementId
            self.updatedHeight = updatedHeight
            super.init()
        }
    }

    // MARK: - Shoppable Ads Events

    /// Emitted when a purchase is made through a Shoppable Ads placement.
    ///
    /// Contains the full details of the purchased cart item including
    /// pricing, product identifiers, and provider data.
    @objc(RoktCartItemInstantPurchase)
    public class CartItemInstantPurchase: RoktEvent {
        /// The identifier of the placement.
        @objc public let placementId: String
        /// The display name of the purchased item.
        @objc public let name: String?
        /// The cart-level item identifier.
        @objc public let cartItemId: String
        /// The catalog-level item identifier.
        @objc public let catalogItemId: String
        /// ISO 4217 currency code (e.g. "USD", "AUD").
        @objc public let currency: String
        /// Description of the purchased item.
        private let _description: String
        @objc override public var description: String { _description }
        /// The linked product identifier, if applicable.
        @objc public let linkedProductId: String?
        /// Payment provider data string.
        @objc public let providerData: String
        /// Quantity purchased.
        @objc public let quantity: NSDecimalNumber?
        /// Total price of the purchase.
        @objc public let totalPrice: NSDecimalNumber?
        /// Unit price of the item.
        @objc public let unitPrice: NSDecimalNumber?

        @objc public init(
            placementId: String,
            name: String?,
            cartItemId: String,
            catalogItemId: String,
            currency: String,
            description: String,
            linkedProductId: String?,
            providerData: String,
            quantity: NSDecimalNumber?,
            totalPrice: NSDecimalNumber?,
            unitPrice: NSDecimalNumber?
        ) {
            self.placementId = placementId
            self.name = name
            self.cartItemId = cartItemId
            self.catalogItemId = catalogItemId
            self.currency = currency
            _description = description
            self.linkedProductId = linkedProductId
            self.providerData = providerData
            self.quantity = quantity
            self.totalPrice = totalPrice
            self.unitPrice = unitPrice
            super.init()
        }
    }
}
