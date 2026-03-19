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
///     var supportedMethods: [PaymentMethodType] { [.applePay, .card] }
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
public protocol PaymentExtension: AnyObject {
    /// Unique identifier for this payment extension.
    var id: String { get }

    /// Human-readable description of the payment extension.
    var extensionDescription: String { get }

    /// Payment methods supported by this extension (e.g. Apple Pay, card).
    var supportedMethods: [PaymentMethodType] { get }

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
    ///   - preparePayment: Async callback to prepare the payment on the backend.
    ///   - completion: Called with the payment result.
    func presentPaymentSheet(
        item: PaymentItem,
        method: PaymentMethodType,
        from viewController: UIViewController,
        preparePayment: @escaping (@Sendable (ContactAddress) async throws -> PaymentPreparation),
        completion: @escaping (PaymentResult) -> Void
    )
    #endif
}
