import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Protocol for payment extension integrations with Shoppable Ads.
///
/// Implement this protocol to provide payment processing capabilities
/// to the Rokt SDK. Payment extensions depend only on RoktContracts,
/// not on the full Rokt SDK, keeping them lightweight and decoupled.
///
/// ## Example Implementation
///
/// ```swift
/// class StripePaymentExtension: PaymentExtension {
///     var id: String { "stripe" }
///     var extensionDescription: String { "Stripe Payment Extension" }
///     var supportedMethods: [String] {
///         [PaymentMethodType.applePay.wireValue, PaymentMethodType.card.wireValue]
///     }
///
///     func onRegister(parameters: [String: String]) -> Bool {
///         // Configure with Stripe publishable key
///         return true
///     }
///
///     func onUnregister() {
///         // Clean up
///     }
/// }
/// ```
@objc(RoktPaymentExtension)
public protocol PaymentExtension: AnyObject {
    /// Unique identifier for this payment extension.
    var id: String { get }

    /// Human-readable description of the payment extension.
    var extensionDescription: String { get }

    /// Payment method wire identifiers this extension supports (see ``PaymentMethodType/wireValue``).
    var supportedMethods: [String] { get }

    /// Called when the extension is registered with the SDK.
    /// - Parameter parameters: Configuration parameters (e.g. API keys).
    /// - Returns: `true` if registration was successful.
    func onRegister(parameters: [String: String]) -> Bool

    /// Called when the extension is unregistered from the SDK.
    func onUnregister()

    #if canImport(UIKit)
    /// Presents the payment sheet to the user.
    /// - Parameters:
    ///   - item: The item being purchased.
    ///   - method: The payment method to use.
    ///   - viewController: The view controller to present the sheet from.
    ///   - preparePayment: Invoked to prepare the payment on the backend. Call `completion` once with
    ///     a ``PaymentPreparation`` on success or `nil` preparation and an `Error` on failure.
    ///   - completion: Called with the payment result when the sheet flow finishes.
    func presentPaymentSheet(
        item: PaymentItem,
        method: PaymentMethodType,
        from viewController: UIViewController,
        preparePayment: @escaping (
            _ address: ContactAddress,
            _ completion: @escaping (PaymentPreparation?, Error?) -> Void
        ) -> Void,
        completion: @escaping (PaymentSheetResult) -> Void
    )
    #endif
}
