import Foundation

/// Privacy flags for Rokt SDK placement requests.
///
/// Each flag is an opt-out: `true` opts the user out of that category. A `nil` flag is not set, so
/// the Rokt SDK keeps the value from an earlier call for it. An explicit `false` clears an earlier
/// `true` set the same way, but never a `true` passed in the attributes of a placement call: if
/// either source opts out, the request opts out.
///
/// ## Example
///
/// ```swift
/// // Change only the targeting flag; the other flags keep their values.
/// let privacyControl = RoktPrivacyControl(noTargeting: true)
/// ```
///
/// ```objc
/// RoktPrivacyControl *privacyControl =
///     [[RoktPrivacyControl alloc] initWithNoFunctional:nil noTargeting:@YES doNotShareOrSell:nil];
/// ```
@objc(RoktPrivacyControl)
public class RoktPrivacyControl: NSObject {
    /// Opts out of functional data collection and processing when `true`. `nil` leaves it as is.
    @objc public let noFunctional: NSNumber?

    /// Opts out of targeting and personalization when `true`. `nil` leaves it as is.
    @objc public let noTargeting: NSNumber?

    /// Opts out of sharing or selling personal data when `true`. `nil` leaves it as is.
    @objc public let doNotShareOrSell: NSNumber?

    /// Creates privacy flags from Swift. Pass only the flags you want to change.
    ///
    /// - Parameters:
    ///   - noFunctional: `true` opts out of functional data usage, `nil` leaves it as is.
    ///   - noTargeting: `true` opts out of targeting, `nil` leaves it as is.
    ///   - doNotShareOrSell: `true` opts out of data sharing or sale, `nil` leaves it as is.
    public convenience init(
        noFunctional: Bool? = nil,
        noTargeting: Bool? = nil,
        doNotShareOrSell: Bool? = nil
    ) {
        self.init(
            noFunctionalNumber: noFunctional.map { NSNumber(value: $0) },
            noTargetingNumber: noTargeting.map { NSNumber(value: $0) },
            doNotShareOrSellNumber: doNotShareOrSell.map { NSNumber(value: $0) }
        )
    }

    /// Creates privacy flags. In Objective-C this is
    /// `initWithNoFunctional:noTargeting:doNotShareOrSell:`; pass `nil` to leave a flag as is.
    /// Any non-zero number counts as `true`. A value that is not a number, such as `NSNull` from a
    /// decoded JSON dictionary, is treated as `nil`.
    ///
    /// - Parameters:
    ///   - noFunctionalNumber: `@YES` opts out of functional data usage, `nil` leaves it as is.
    ///   - noTargetingNumber: `@YES` opts out of targeting, `nil` leaves it as is.
    ///   - doNotShareOrSellNumber: `@YES` opts out of data sharing or sale, `nil` leaves it as is.
    @objc(initWithNoFunctional:noTargeting:doNotShareOrSell:)
    public init(
        noFunctionalNumber: NSNumber?,
        noTargetingNumber: NSNumber?,
        doNotShareOrSellNumber: NSNumber?
    ) {
        noFunctional = Self.flag(noFunctionalNumber)
        noTargeting = Self.flag(noTargetingNumber)
        doNotShareOrSell = Self.flag(doNotShareOrSellNumber)
        super.init()
    }

    // Objective-C callers can pass any object where an NSNumber is declared, so check the class at
    // run time before reading boolValue.
    private static func flag(_ value: NSNumber?) -> NSNumber? {
        guard let value, value.isKind(of: NSNumber.self) else { return nil }
        return NSNumber(value: value.boolValue)
    }
}
