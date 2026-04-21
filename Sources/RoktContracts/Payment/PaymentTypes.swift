import Foundation

/// Payment method type supported by a payment extension.
///
/// Uses an integer raw value so the enum can be used from Objective-C (`NS_ENUM`).
/// Use ``wireValue`` for the stable string identifiers used in configuration and APIs.
@objc(RoktPaymentMethodType)
public enum PaymentMethodType: Int, Sendable, CaseIterable {
    /// Apple Pay.
    case applePay = 0
    /// Credit/debit card.
    case card = 1
    /// Afterpay / Clearpay.
    case afterpay = 2
    /// PayPal.
    case paypal = 3
}

public extension PaymentMethodType {
    /// Stable string identifier (e.g. for configuration or logging).
    var wireValue: String {
        switch self {
        case .applePay: return "apple_pay"
        case .card: return "card"
        case .afterpay: return "afterpay_clearpay"
        case .paypal: return "paypal"
        }
    }

    /// Creates a payment method from a wire string, if recognized.
    init?(wireValue: String) {
        switch wireValue {
        case "apple_pay": self = .applePay
        case "card": self = .card
        case "afterpay_clearpay": self = .afterpay
        case "paypal": self = .paypal
        default: return nil
        }
    }
}

/// An item to be purchased through a Shoppable Ads placement.
///
/// Exposed to Objective-C as ``RoktPaymentItem``.
@objc(RoktPaymentItem)
public class PaymentItem: NSObject, @unchecked Sendable {
    /// Unique identifier for the item.
    @objc public let id: String
    /// Display name of the item.
    @objc public let name: String
    /// Price amount.
    @objc public let amount: NSDecimalNumber
    /// ISO 4217 currency code (e.g. "USD", "AUD").
    @objc public let currency: String

    /// Creates a payment item using a Swift `Decimal` amount.
    public init(id: String, name: String, amount: Decimal, currency: String) {
        self.id = id
        self.name = name
        self.amount = NSDecimalNumber(decimal: amount)
        self.currency = currency
        super.init()
    }

    /// Objective-C initializer (`initWithId:name:amountNumber:currency:`).
    @objc
    public init(id: String, name: String, amountNumber: NSDecimalNumber, currency: String) {
        self.id = id
        self.name = name
        amount = amountNumber
        self.currency = currency
        super.init()
    }
}

/// Outcome of presenting the payment sheet, for Objective-C interop (`NS_ENUM`).
@objc(RoktPaymentSheetOutcome)
public enum PaymentSheetOutcome: Int, Sendable {
    /// Payment completed successfully.
    case succeeded = 0
    /// Payment failed.
    case failed = 1
    /// User canceled the payment.
    case canceled = 2
}

/// Result of a payment attempt through a payment extension.
///
/// Exposed to Objective-C as ``RoktPaymentSheetResult``. Use ``outcome`` and the optional
/// ``transactionId`` / ``errorMessage`` fields instead of a Swift-only enum with associated values.
@objc(RoktPaymentSheetResult)
public final class PaymentSheetResult: NSObject, @unchecked Sendable {
    @objc public let outcome: PaymentSheetOutcome
    /// Set when ``outcome`` is ``PaymentSheetOutcome/succeeded``.
    @objc public let transactionId: String?
    /// Set when ``outcome`` is ``PaymentSheetOutcome/failed``.
    @objc public let errorMessage: String?

    @objc
    public init(outcome: PaymentSheetOutcome, transactionId: String?, errorMessage: String?) {
        self.outcome = outcome
        self.transactionId = transactionId
        self.errorMessage = errorMessage
        super.init()
    }

    /// Successful payment with a provider transaction identifier.
    public static func succeeded(transactionId: String) -> PaymentSheetResult {
        PaymentSheetResult(outcome: .succeeded, transactionId: transactionId, errorMessage: nil)
    }

    /// Failed payment with a reason.
    public static func failed(error: String) -> PaymentSheetResult {
        PaymentSheetResult(outcome: .failed, transactionId: nil, errorMessage: error)
    }

    /// User canceled the flow.
    public static var canceled: PaymentSheetResult {
        PaymentSheetResult(outcome: .canceled, transactionId: nil, errorMessage: nil)
    }
}

/// Backend payment preparation result returned by the `preparePayment` callback.
///
/// Exposed to Objective-C as ``RoktPaymentPreparation``.
@objc(RoktPaymentPreparation)
public class PaymentPreparation: NSObject, @unchecked Sendable {
    /// The client secret for the payment intent.
    @objc public let clientSecret: String
    /// The merchant identifier.
    @objc public let merchantId: String

    @objc
    public init(clientSecret: String, merchantId: String) {
        self.clientSecret = clientSecret
        self.merchantId = merchantId
        super.init()
    }
}

/// Contact address provided by the user during payment.
///
/// Exposed to Objective-C as ``RoktContactAddress``.
@objc(RoktContactAddress)
public class ContactAddress: NSObject, @unchecked Sendable {
    /// Full name of the contact.
    @objc public let name: String
    /// Email address.
    @objc public let email: String
    /// Street address line 1.
    @objc public let addressLine1: String?
    /// City name.
    @objc public let city: String?
    /// State or region.
    @objc public let state: String?
    /// Postal/ZIP code.
    @objc public let postalCode: String?
    /// ISO country code.
    @objc public let country: String?

    @objc
    public init(
        name: String,
        email: String,
        addressLine1: String? = nil,
        city: String? = nil,
        state: String? = nil,
        postalCode: String? = nil,
        country: String? = nil
    ) {
        self.name = name
        self.email = email
        self.addressLine1 = addressLine1
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        super.init()
    }
}

/// Contextual information for a payment attempt, carrying pre-collected addresses
/// and method-specific metadata needed before the payment UI is presented.
///
/// For payment methods like Afterpay that require billing/shipping address before
/// the payment flow begins, populate the address fields. For methods like Apple Pay
/// that collect addresses in their own UI, these may be left `nil`.
///
/// Exposed to Objective-C as ``RoktPaymentContext``.
@objcMembers
@objc(RoktPaymentContext)
public class PaymentContext: NSObject, @unchecked Sendable {
    /// Pre-collected billing address, if available.
    public let billingAddress: ContactAddress?
    /// Pre-collected shipping address, if available.
    public let shippingAddress: ContactAddress?
    /// Custom URL scheme for redirect-based payment methods (e.g. `"myapp://stripe-redirect"`).
    public let returnURL: String?

    public init(
        billingAddress: ContactAddress? = nil,
        shippingAddress: ContactAddress? = nil,
        returnURL: String? = nil
    ) {
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.returnURL = returnURL
        super.init()
    }
}
