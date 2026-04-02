import XCTest
@testable import RoktContracts

#if canImport(UIKit)
import UIKit

/// Exercises the `presentPaymentSheet` callback contract when UIKit is available (iOS / tvOS targets).
final class PaymentExtensionTests: XCTestCase {

    private final class ForwardingPaymentExtension: PaymentExtension {
        var id: String { "forwarding-test" }
        var extensionDescription: String { "Forwards preparePayment to completion" }
        var supportedMethods: [String] { [PaymentMethodType.applePay.wireValue] }

        func onRegister(parameters: [String: String]) -> Bool { true }
        func onUnregister() {}

        func presentPaymentSheet(
            item: PaymentItem,
            method: PaymentMethodType,
            from viewController: UIViewController,
            preparePayment: @escaping (
                _ address: ContactAddress,
                _ completion: @escaping (PaymentPreparation?, Error?) -> Void
            ) -> Void,
            completion: @escaping (PaymentSheetResult) -> Void
        ) {
            let address = ContactAddress(name: "Test User", email: "user@example.com")
            preparePayment(address) { preparation, error in
                if let error {
                    completion(PaymentSheetResult.failed(error: error.localizedDescription))
                    return
                }
                guard let preparation else {
                    completion(PaymentSheetResult.canceled)
                    return
                }
                completion(PaymentSheetResult.succeeded(transactionId: preparation.clientSecret))
            }
        }
    }

    func testPresentPaymentSheetForwardsPrepareSuccessToCompletion() {
        let ext = ForwardingPaymentExtension()
        let item = PaymentItem(id: "i1", name: "Item", amount: 1, currency: "USD")
        let vc = UIViewController()
        let expect = expectation(description: "completion")

        ext.presentPaymentSheet(
            item: item,
            method: .applePay,
            from: vc,
            preparePayment: { address, done in
                XCTAssertEqual(address.email, "user@example.com")
                done(PaymentPreparation(clientSecret: "cs_live_abc", merchantId: "merchant.test"), nil)
            },
            completion: { result in
                XCTAssertEqual(result.outcome, .succeeded)
                XCTAssertEqual(result.transactionId, "cs_live_abc")
                XCTAssertNil(result.errorMessage)
                expect.fulfill()
            }
        )

        waitForExpectations(timeout: 1)
    }

    func testPresentPaymentSheetForwardsPrepareErrorToCompletion() {
        let ext = ForwardingPaymentExtension()
        let item = PaymentItem(id: "i1", name: "Item", amount: 1, currency: "USD")
        let vc = UIViewController()
        let expect = expectation(description: "completion")
        struct TestErr: Error {}

        ext.presentPaymentSheet(
            item: item,
            method: .card,
            from: vc,
            preparePayment: { _, done in
                done(nil, TestErr())
            },
            completion: { result in
                XCTAssertEqual(result.outcome, .failed)
                XCTAssertNotNil(result.errorMessage)
                XCTAssertNil(result.transactionId)
                expect.fulfill()
            }
        )

        waitForExpectations(timeout: 1)
    }

    func testPresentPaymentSheetForwardsNilPreparationToCanceled() {
        let ext = ForwardingPaymentExtension()
        let item = PaymentItem(id: "i1", name: "Item", amount: 1, currency: "USD")
        let vc = UIViewController()
        let expect = expectation(description: "completion")

        ext.presentPaymentSheet(
            item: item,
            method: .card,
            from: vc,
            preparePayment: { _, done in
                done(nil, nil)
            },
            completion: { result in
                XCTAssertEqual(result.outcome, .canceled)
                expect.fulfill()
            }
        )

        waitForExpectations(timeout: 1)
    }
}

#endif
