import Foundation

/// Payment method type supported by a payment extension.
public enum PaymentMethodType: String, Sendable {
    /// Apple Pay.
    case applePay = "apple_pay"
    /// Credit/debit card.
    case card
}

/// An item to be purchased through a Shoppable Ads placement.
public struct PaymentItem: Sendable {
    /// Unique identifier for the item.
    public let id: String
    /// Display name of the item.
    public let name: String
    /// Price amount as a decimal value.
    public let amount: Decimal
    /// ISO 4217 currency code (e.g. "USD", "AUD").
    public let currency: String

    public init(id: String, name: String, amount: Decimal, currency: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
    }
}

/// Result of a payment attempt through a payment extension.
public enum PaymentResult: Sendable {
    /// Payment completed successfully.
    /// - Parameter transactionId: The transaction identifier from the payment provider.
    case succeeded(transactionId: String)
    /// Payment failed.
    /// - Parameter error: A description of the failure reason.
    case failed(error: String)
    /// User canceled the payment.
    case canceled
}

/// Backend payment preparation result returned by the `preparePayment` callback.
public struct PaymentPreparation: Sendable {
    /// The client secret for the payment intent.
    public let clientSecret: String
    /// The merchant identifier.
    public let merchantId: String

    public init(clientSecret: String, merchantId: String) {
        self.clientSecret = clientSecret
        self.merchantId = merchantId
    }
}

/// Contact address provided by the user during payment.
public struct ContactAddress: Sendable {
    /// Full name of the contact.
    public let name: String
    /// Email address.
    public let email: String
    /// Street address line 1.
    public let addressLine1: String?
    /// City name.
    public let city: String?
    /// State or region.
    public let state: String?
    /// Postal/ZIP code.
    public let postalCode: String?
    /// ISO country code.
    public let country: String?

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
    }
}
