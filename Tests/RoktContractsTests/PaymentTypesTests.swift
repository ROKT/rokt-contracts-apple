import Foundation
import XCTest
@testable import RoktContracts

final class PaymentTypesTests: XCTestCase {

    func testPaymentMethodTypeRawValues() {
        XCTAssertEqual(PaymentMethodType.applePay.rawValue, 0)
        XCTAssertEqual(PaymentMethodType.card.rawValue, 1)
        XCTAssertEqual(PaymentMethodType.afterpay.rawValue, 2)
        XCTAssertEqual(PaymentMethodType.paypal.rawValue, 3)
    }

    func testPaymentMethodTypeWireValues() {
        XCTAssertEqual(PaymentMethodType.applePay.wireValue, "apple_pay")
        XCTAssertEqual(PaymentMethodType.card.wireValue, "card")
        XCTAssertEqual(PaymentMethodType.afterpay.wireValue, "afterpay_clearpay")
        XCTAssertEqual(PaymentMethodType.paypal.wireValue, "paypal")
        XCTAssertEqual(PaymentMethodType(wireValue: "apple_pay"), .applePay)
        XCTAssertEqual(PaymentMethodType(wireValue: "card"), .card)
        XCTAssertEqual(PaymentMethodType(wireValue: "afterpay_clearpay"), .afterpay)
        XCTAssertEqual(PaymentMethodType(wireValue: "paypal"), .paypal)
        XCTAssertNil(PaymentMethodType(wireValue: "unknown"))
    }

    func testPaymentMethodTypeAllCasesWireValuesAreDistinct() {
        let wires = Set(PaymentMethodType.allCases.map(\.wireValue))
        XCTAssertEqual(wires.count, PaymentMethodType.allCases.count)
    }

    func testPaymentItem() {
        let item = PaymentItem(id: "item-1", name: "Widget", amount: 19.99, currency: "USD")
        XCTAssertEqual(item.id, "item-1")
        XCTAssertEqual(item.name, "Widget")
        XCTAssertEqual(item.amount.decimalValue, Decimal(19.99))
        XCTAssertEqual(item.currency, "USD")
    }

    /// Objective-C entry point (`initWithId:name:amountNumber:currency:`).
    func testPaymentItemNSDecimalNumberInitializer() {
        let number = NSDecimalNumber(string: "12.34")
        let item = PaymentItem(id: "x", name: "Y", amountNumber: number, currency: "AUD")
        XCTAssertEqual(item.amount, number)
        XCTAssertEqual(item.amount.decimalValue, Decimal(string: "12.34"))
    }

    func testPaymentItemDecimalInitializerMatchesNSDecimalNumberPath() {
        let decimal = Decimal(string: "99.01")!
        let viaDecimal = PaymentItem(id: "1", name: "N", amount: decimal, currency: "USD")
        let viaNumber = PaymentItem(id: "1", name: "N", amountNumber: NSDecimalNumber(decimal: decimal), currency: "USD")
        XCTAssertEqual(viaDecimal.amount, viaNumber.amount)
    }

    /// Raw values must stay stable for Objective-C `NS_ENUM` consumers.
    func testPaymentSheetOutcomeRawValues() {
        XCTAssertEqual(PaymentSheetOutcome.succeeded.rawValue, 0)
        XCTAssertEqual(PaymentSheetOutcome.failed.rawValue, 1)
        XCTAssertEqual(PaymentSheetOutcome.canceled.rawValue, 2)
    }

    func testPaymentSheetResultSucceeded() {
        let result = PaymentSheetResult.succeeded(transactionId: "txn-123")
        XCTAssertEqual(result.outcome, .succeeded)
        XCTAssertEqual(result.transactionId, "txn-123")
        XCTAssertNil(result.errorMessage)
    }

    func testPaymentSheetResultFactoriesMatchDesignatedInitializer() {
        let succeeded = PaymentSheetResult.succeeded(transactionId: "t")
        let succeededEq = PaymentSheetResult(outcome: .succeeded, transactionId: "t", errorMessage: nil)
        XCTAssertEqual(succeeded.outcome, succeededEq.outcome)
        XCTAssertEqual(succeeded.transactionId, succeededEq.transactionId)
        XCTAssertEqual(succeeded.errorMessage, succeededEq.errorMessage)

        let failed = PaymentSheetResult.failed(error: "e")
        let failedEq = PaymentSheetResult(outcome: .failed, transactionId: nil, errorMessage: "e")
        XCTAssertEqual(failed.outcome, failedEq.outcome)
        XCTAssertEqual(failed.transactionId, failedEq.transactionId)
        XCTAssertEqual(failed.errorMessage, failedEq.errorMessage)

        let canceled = PaymentSheetResult.canceled
        let canceledEq = PaymentSheetResult(outcome: .canceled, transactionId: nil, errorMessage: nil)
        XCTAssertEqual(canceled.outcome, canceledEq.outcome)
        XCTAssertEqual(canceled.transactionId, canceledEq.transactionId)
        XCTAssertEqual(canceled.errorMessage, canceledEq.errorMessage)
    }

    func testPaymentSheetResultFailed() {
        let result = PaymentSheetResult.failed(error: "Insufficient funds")
        XCTAssertEqual(result.outcome, .failed)
        XCTAssertNil(result.transactionId)
        XCTAssertEqual(result.errorMessage, "Insufficient funds")
    }

    func testPaymentSheetResultCanceled() {
        let result = PaymentSheetResult.canceled
        XCTAssertEqual(result.outcome, .canceled)
        XCTAssertNil(result.transactionId)
        XCTAssertNil(result.errorMessage)
    }

    func testPaymentSheetResultFailedIsNotRetryableByDefault() {
        let result = PaymentSheetResult.failed(error: "Card declined")
        XCTAssertEqual(result.outcome, .failed)
        XCTAssertFalse(result.isRetryable)
    }

    func testPaymentSheetResultFailedRetryable() {
        let result = PaymentSheetResult.failed(error: "Service unavailable", isRetryable: true)
        XCTAssertEqual(result.outcome, .failed)
        XCTAssertEqual(result.errorMessage, "Service unavailable")
        XCTAssertTrue(result.isRetryable)
    }

    func testPaymentSheetResultSucceededAndCanceledAreNotRetryable() {
        XCTAssertFalse(PaymentSheetResult.succeeded(transactionId: "t").isRetryable)
        XCTAssertFalse(PaymentSheetResult.canceled.isRetryable)
    }

    func testPaymentSheetResultBackwardCompatibleInitializerDefaultsRetryableFalse() {
        let result = PaymentSheetResult(outcome: .failed, transactionId: nil, errorMessage: "e")
        XCTAssertFalse(result.isRetryable)
    }

    func testPaymentSheetResultDesignatedInitializerCarriesRetryable() {
        let result = PaymentSheetResult(
            outcome: .failed,
            transactionId: nil,
            errorMessage: "e",
            isRetryable: true
        )
        XCTAssertTrue(result.isRetryable)
    }

    func testPaymentPreparation() {
        let prep = PaymentPreparation(
            clientSecret: "cs_123",
            merchantId: "merchant.com.test",
            totalAmount: Decimal(string: "83.53")!,
            shippingCost: Decimal(string: "0")!,
            tax: Decimal(string: "3.53")!
        )
        XCTAssertEqual(prep.clientSecret, "cs_123")
        XCTAssertEqual(prep.merchantId, "merchant.com.test")
        XCTAssertEqual(prep.totalAmount, NSDecimalNumber(string: "83.53"))
        XCTAssertEqual(prep.shippingCost, NSDecimalNumber.zero)
        XCTAssertEqual(prep.tax, NSDecimalNumber(string: "3.53"))
        XCTAssertNil(prep.approvalUrl)
    }

    func testPaymentPreparationIncludesApprovalUrlWhenProvided() {
        let url = "https://www.paypal.com/checkoutnow?token=abc"
        let prep = PaymentPreparation(
            clientSecret: "cs_123",
            merchantId: "merchant.com.test",
            totalAmount: 10,
            approvalUrl: url
        )
        XCTAssertEqual(prep.approvalUrl, url)
    }

    func testPaymentPreparationDefaultsShippingAndTaxToZero() {
        let prep = PaymentPreparation(
            clientSecret: "cs_123",
            merchantId: "merchant.com.test",
            totalAmount: Decimal(string: "9.99")!
        )
        XCTAssertEqual(prep.totalAmount, NSDecimalNumber(string: "9.99"))
        XCTAssertEqual(prep.shippingCost, NSDecimalNumber.zero)
        XCTAssertEqual(prep.tax, NSDecimalNumber.zero)
        XCTAssertNil(prep.approvalUrl)
    }

    func testPaymentPreparationLegacyInitializerDefaultsAmountsToZero() {
        let prep = PaymentPreparation(clientSecret: "cs_123", merchantId: "merchant.com.test")
        XCTAssertEqual(prep.clientSecret, "cs_123")
        XCTAssertEqual(prep.merchantId, "merchant.com.test")
        XCTAssertEqual(prep.totalAmount, NSDecimalNumber.zero)
        XCTAssertEqual(prep.shippingCost, NSDecimalNumber.zero)
        XCTAssertEqual(prep.tax, NSDecimalNumber.zero)
        XCTAssertNil(prep.approvalUrl)
    }

    func testContactAddressFull() {
        let addr = ContactAddress(
            name: "John Doe", email: "john@example.com",
            addressLine1: "123 Main St", addressLine2: "Unit 4",
            city: "Sydney",
            state: "NSW", postalCode: "2000", country: "AU"
        )
        XCTAssertEqual(addr.name, "John Doe")
        XCTAssertEqual(addr.email, "john@example.com")
        XCTAssertEqual(addr.addressLine1, "123 Main St")
        XCTAssertEqual(addr.addressLine2, "Unit 4")
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
        XCTAssertNil(addr.addressLine2)
        XCTAssertNil(addr.city)
    }

    func testPaymentContextFull() {
        let billing = ContactAddress(
            name: "John Doe", email: "john@example.com",
            addressLine1: "123 Main St", city: "Sydney",
            state: "NSW", postalCode: "2000", country: "AU"
        )
        let shipping = ContactAddress(name: "John Doe", email: "john@example.com")
        let context = PaymentContext(
            billingAddress: billing,
            shippingAddress: shipping,
            returnURL: "myapp://stripe-redirect",
            cancelURL: "myapp://stripe-cancel"
        )
        XCTAssertEqual(context.billingAddress?.name, "John Doe")
        XCTAssertEqual(context.billingAddress?.addressLine1, "123 Main St")
        XCTAssertEqual(context.shippingAddress?.email, "john@example.com")
        XCTAssertEqual(context.returnURL, "myapp://stripe-redirect")
        XCTAssertEqual(context.cancelURL, "myapp://stripe-cancel")
    }

    func testPaymentContextDefaults() {
        let context = PaymentContext()
        XCTAssertNil(context.billingAddress)
        XCTAssertNil(context.shippingAddress)
        XCTAssertNil(context.returnURL)
        XCTAssertNil(context.cancelURL)
    }

    func testPaymentContextPayPalRedirectURLsOnly() {
        let context = PaymentContext(
            billingAddress: nil,
            shippingAddress: nil,
            returnURL: "myapp://paypal/success",
            cancelURL: "myapp://paypal/cancel"
        )
        XCTAssertNil(context.billingAddress)
        XCTAssertNil(context.shippingAddress)
        XCTAssertEqual(context.returnURL, "myapp://paypal/success")
        XCTAssertEqual(context.cancelURL, "myapp://paypal/cancel")
    }
}
