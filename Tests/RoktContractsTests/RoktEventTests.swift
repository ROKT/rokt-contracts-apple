import XCTest
@testable import RoktContracts

final class RoktEventTests: XCTestCase {

    func testInitCompleteSuccess() {
        let event = RoktEvent.InitComplete(success: true)
        XCTAssertTrue(event.success)
        XCTAssertTrue(event is RoktEvent)
    }

    func testInitCompleteFailure() {
        let event = RoktEvent.InitComplete(success: false)
        XCTAssertFalse(event.success)
    }

    func testPlacementReadyWithId() {
        let event = RoktEvent.PlacementReady(identifier: "placement-123")
        XCTAssertEqual(event.identifier, "placement-123")
    }

    func testPlacementReadyWithNilId() {
        let event = RoktEvent.PlacementReady(identifier: nil)
        XCTAssertNil(event.identifier)
    }

    func testPlacementInteractive() {
        let event = RoktEvent.PlacementInteractive(identifier: "p1")
        XCTAssertEqual(event.identifier, "p1")
        XCTAssertTrue(event is RoktEvent)
    }

    func testPlacementClosed() {
        let event = RoktEvent.PlacementClosed(identifier: "p1")
        XCTAssertEqual(event.identifier, "p1")
    }

    func testPlacementCompleted() {
        let event = RoktEvent.PlacementCompleted(identifier: "p1")
        XCTAssertEqual(event.identifier, "p1")
    }

    func testPlacementFailure() {
        let event = RoktEvent.PlacementFailure(identifier: nil)
        XCTAssertNil(event.identifier)
    }

    func testOfferEngagement() {
        let event = RoktEvent.OfferEngagement(identifier: "p1")
        XCTAssertEqual(event.identifier, "p1")
    }

    func testPositiveEngagement() {
        let event = RoktEvent.PositiveEngagement(identifier: "p1")
        XCTAssertEqual(event.identifier, "p1")
    }

    func testFirstPositiveEngagement() {
        var receivedAttributes: [String: String]?
        let event = RoktEvent.FirstPositiveEngagement(
            identifier: "p1",
            setFulfillmentAttributes: { attrs in
                receivedAttributes = attrs
            }
        )
        XCTAssertEqual(event.identifier, "p1")
        event.setFulfillmentAttributes?(["key": "value"])
        XCTAssertEqual(receivedAttributes, ["key": "value"])
    }

    func testOpenUrl() {
        let event = RoktEvent.OpenUrl(identifier: "p1", url: "https://example.com")
        XCTAssertEqual(event.identifier, "p1")
        XCTAssertEqual(event.url, "https://example.com")
    }

    func testCartItemInstantPurchase() {
        let event = RoktEvent.CartItemInstantPurchase(
            identifier: "p1",
            name: "Widget",
            cartItemId: "cart-001",
            catalogItemId: "cat-001",
            currency: "USD",
            description: "A premium widget",
            linkedProductId: nil,
            providerData: "stripe",
            quantity: NSDecimalNumber(value: 2),
            totalPrice: NSDecimalNumber(string: "39.98"),
            unitPrice: NSDecimalNumber(string: "19.99")
        )
        XCTAssertEqual(event.identifier, "p1")
        XCTAssertEqual(event.name, "Widget")
        XCTAssertEqual(event.cartItemId, "cart-001")
        XCTAssertEqual(event.catalogItemId, "cat-001")
        XCTAssertEqual(event.currency, "USD")
        XCTAssertEqual(event.description, "A premium widget")
        XCTAssertNil(event.linkedProductId)
        XCTAssertEqual(event.providerData, "stripe")
        XCTAssertEqual(event.quantity, NSDecimalNumber(value: 2))
        XCTAssertEqual(event.totalPrice, NSDecimalNumber(string: "39.98"))
        XCTAssertEqual(event.unitPrice, NSDecimalNumber(string: "19.99"))
    }

    func testEmbeddedSizeChanged() {
        let event = RoktEvent.EmbeddedSizeChanged(identifier: "embed-1", updatedHeight: 250.5)
        XCTAssertEqual(event.identifier, "embed-1")
        XCTAssertEqual(event.updatedHeight, 250.5)
        XCTAssertTrue(event is RoktEvent)
    }

    func testShowHideLoadingIndicators() {
        let show = RoktEvent.ShowLoadingIndicator()
        let hide = RoktEvent.HideLoadingIndicator()
        XCTAssertTrue(show is RoktEvent)
        XCTAssertTrue(hide is RoktEvent)
    }

    func testEventInheritanceHierarchy() {
        let events: [RoktEvent] = [
            RoktEvent.InitComplete(success: true),
            RoktEvent.ShowLoadingIndicator(),
            RoktEvent.HideLoadingIndicator(),
            RoktEvent.PlacementReady(identifier: "p"),
            RoktEvent.PlacementInteractive(identifier: "p"),
            RoktEvent.PlacementClosed(identifier: "p"),
            RoktEvent.PlacementCompleted(identifier: "p"),
            RoktEvent.PlacementFailure(identifier: nil),
            RoktEvent.OfferEngagement(identifier: "p"),
            RoktEvent.PositiveEngagement(identifier: "p"),
            RoktEvent.FirstPositiveEngagement(identifier: "p"),
            RoktEvent.OpenUrl(identifier: "p", url: "https://rokt.com"),
            RoktEvent.CartItemInstantPurchase(
                identifier: "p", name: nil, cartItemId: "c", catalogItemId: "cat",
                currency: "USD", description: "", linkedProductId: nil,
                providerData: "", quantity: nil, totalPrice: nil, unitPrice: nil
            ),
            RoktEvent.EmbeddedSizeChanged(identifier: "p", updatedHeight: 100),
        ]
        XCTAssertEqual(events.count, 14)
    }
}
