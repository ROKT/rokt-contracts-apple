import XCTest
@testable import RoktContracts

final class PaymentTypesTests: XCTestCase {

    func testPaymentMethodTypeRawValues() {
        XCTAssertEqual(PaymentMethodType.applePay.rawValue, "apple_pay")
        XCTAssertEqual(PaymentMethodType.card.rawValue, "card")
    }

    func testPaymentItem() {
        let item = PaymentItem(id: "item-1", name: "Widget", amount: 19.99, currency: "USD")
        XCTAssertEqual(item.id, "item-1")
        XCTAssertEqual(item.name, "Widget")
        XCTAssertEqual(item.amount, 19.99)
        XCTAssertEqual(item.currency, "USD")
    }

    func testPaymentResultSucceeded() {
        let result = PaymentResult.succeeded(transactionId: "txn-123")
        if case let .succeeded(txnId) = result {
            XCTAssertEqual(txnId, "txn-123")
        } else {
            XCTFail("Expected succeeded")
        }
    }

    func testPaymentResultFailed() {
        let result = PaymentResult.failed(error: "Insufficient funds")
        if case let .failed(error) = result {
            XCTAssertEqual(error, "Insufficient funds")
        } else {
            XCTFail("Expected failed")
        }
    }

    func testPaymentResultCanceled() {
        let result = PaymentResult.canceled
        if case .canceled = result {
            // pass
        } else {
            XCTFail("Expected canceled")
        }
    }

    func testPaymentPreparation() {
        let prep = PaymentPreparation(clientSecret: "cs_123", merchantId: "merchant.com.test")
        XCTAssertEqual(prep.clientSecret, "cs_123")
        XCTAssertEqual(prep.merchantId, "merchant.com.test")
    }

    func testContactAddressFull() {
        let addr = ContactAddress(
            name: "John Doe", email: "john@example.com",
            addressLine1: "123 Main St", city: "Sydney",
            state: "NSW", postalCode: "2000", country: "AU"
        )
        XCTAssertEqual(addr.name, "John Doe")
        XCTAssertEqual(addr.email, "john@example.com")
        XCTAssertEqual(addr.addressLine1, "123 Main St")
        XCTAssertEqual(addr.city, "Sydney")
        XCTAssertEqual(addr.state, "NSW")
        XCTAssertEqual(addr.postalCode, "2000")
        XCTAssertEqual(addr.country, "AU")
    }

    func testContactAddressMinimal() {
        let addr = ContactAddress(name: "Jane", email: "jane@example.com")
        XCTAssertEqual(addr.name, "Jane")
        XCTAssertEqual(addr.email, "jane@example.com")
        XCTAssertNil(addr.addressLine1)
        XCTAssertNil(addr.city)
    }
}
