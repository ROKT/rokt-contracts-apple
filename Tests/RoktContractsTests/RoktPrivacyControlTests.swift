import XCTest
@testable import RoktContracts

final class RoktPrivacyControlTests: XCTestCase {

    func test_init_defaults_leaveEveryFlagUnset() {
        for privacyControl in [
            RoktPrivacyControl(),
            RoktPrivacyControl(noFunctional: nil, noTargeting: nil, doNotShareOrSell: nil)
        ] {
            XCTAssertNil(privacyControl.noFunctional)
            XCTAssertNil(privacyControl.noTargeting)
            XCTAssertNil(privacyControl.doNotShareOrSell)
        }
    }

    func test_init_swiftValues_keepExplicitFalse() {
        let privacyControl = RoktPrivacyControl(noFunctional: false, noTargeting: true)
        XCTAssertEqual(privacyControl.noFunctional, false)
        XCTAssertEqual(privacyControl.noTargeting, true)
        XCTAssertNil(privacyControl.doNotShareOrSell)
    }

    func test_objcInit_nilLeavesFlagUnset() {
        let privacyControl = RoktPrivacyControl(
            noFunctionalNumber: nil,
            noTargetingNumber: true,
            doNotShareOrSellNumber: false
        )
        XCTAssertNil(privacyControl.noFunctional)
        XCTAssertEqual(privacyControl.noTargeting, true)
        XCTAssertEqual(privacyControl.doNotShareOrSell, false)
    }

    func test_objcInit_normalisesNumbersToBooleans() {
        let privacyControl = RoktPrivacyControl(
            noFunctionalNumber: 2,
            noTargetingNumber: 0,
            doNotShareOrSellNumber: nil
        )
        XCTAssertEqual(privacyControl.noFunctional, NSNumber(value: true))
        XCTAssertEqual(privacyControl.noTargeting, NSNumber(value: false))
        XCTAssertNil(privacyControl.doNotShareOrSell)
    }

    func test_objcInit_nonNumberValues_areLeftUnset() {
        // An Objective-C caller can pass any object, for example NSNull from a decoded JSON
        // dictionary, where the header declares a nullable NSNumber.
        let privacyControl = RoktPrivacyControl(
            noFunctionalNumber: unsafeBitCast(NSNull(), to: NSNumber.self),
            noTargetingNumber: unsafeBitCast(NSString(string: "true"), to: NSNumber.self),
            doNotShareOrSellNumber: true
        )
        XCTAssertNil(privacyControl.noFunctional)
        XCTAssertNil(privacyControl.noTargeting)
        XCTAssertEqual(privacyControl.doNotShareOrSell, true)
    }

    func test_objcSurface_exposesSelectorAndProperties() {
        XCTAssertTrue(
            RoktPrivacyControl.instancesRespond(
                to: NSSelectorFromString("initWithNoFunctional:noTargeting:doNotShareOrSell:")
            )
        )
        let privacyControl = RoktPrivacyControl(noTargeting: true)
        XCTAssertEqual(privacyControl.value(forKey: "noTargeting") as? NSNumber, true)
        XCTAssertNil(privacyControl.value(forKey: "noFunctional"))
    }
}
