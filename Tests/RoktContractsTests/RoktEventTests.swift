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
        let event = RoktEvent.PlacementReady(placementId: "placement-123")
        XCTAssertEqual(event.placementId, "placement-123")
    }

    func testPlacementReadyWithNilId() {
        let event = RoktEvent.PlacementReady(placementId: nil)
        XCTAssertNil(event.placementId)
    }

    func testPlacementInteractive() {
        let event = RoktEvent.PlacementInteractive(placementId: "p1")
        XCTAssertEqual(event.placementId, "p1")
        XCTAssertTrue(event is RoktEvent)
    }

    func testPlacementClosed() {
        let event = RoktEvent.PlacementClosed(placementId: "p1")
        XCTAssertEqual(event.placementId, "p1")
    }

    func testPlacementCompleted() {
        let event = RoktEvent.PlacementCompleted(placementId: "p1")
        XCTAssertEqual(event.placementId, "p1")
    }

    func testPlacementFailure() {
        let event = RoktEvent.PlacementFailure(placementId: nil)
        XCTAssertNil(event.placementId)
    }

    func testOfferEngagement() {
        let event = RoktEvent.OfferEngagement(placementId: "p1")
        XCTAssertEqual(event.placementId, "p1")
    }

    func testPositiveEngagement() {
        let event = RoktEvent.PositiveEngagement(placementId: "p1")
        XCTAssertEqual(event.placementId, "p1")
    }

    func testFirstPositiveEngagement() {
        var receivedAttributes: [String: String]?
        let event = RoktEvent.FirstPositiveEngagement(
            placementId: "p1",
            setFulfillmentAttributes: { attrs in
                receivedAttributes = attrs
            }
        )
        XCTAssertEqual(event.placementId, "p1")
        event.setFulfillmentAttributes?(["key": "value"])
        XCTAssertEqual(receivedAttributes, ["key": "value"])
    }

    func testOpenUrl() {
        let event = RoktEvent.OpenUrl(placementId: "p1", url: "https://example.com")
        XCTAssertEqual(event.placementId, "p1")
        XCTAssertEqual(event.url, "https://example.com")
    }

    func testCartItemInstantPurchase() {
        let event = RoktEvent.CartItemInstantPurchase(
            placementId: "p1",
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
        XCTAssertEqual(event.placementId, "p1")
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
        let event = RoktEvent.EmbeddedSizeChanged(placementId: "embed-1", updatedHeight: 250.5)
        XCTAssertEqual(event.placementId, "embed-1")
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
            RoktEvent.PlacementReady(placementId: "p"),
            RoktEvent.PlacementInteractive(placementId: "p"),
            RoktEvent.PlacementClosed(placementId: "p"),
            RoktEvent.PlacementCompleted(placementId: "p"),
            RoktEvent.PlacementFailure(placementId: nil),
            RoktEvent.OfferEngagement(placementId: "p"),
            RoktEvent.PositiveEngagement(placementId: "p"),
            RoktEvent.FirstPositiveEngagement(placementId: "p"),
            RoktEvent.OpenUrl(placementId: "p", url: "https://rokt.com"),
            RoktEvent.CartItemInstantPurchase(
                placementId: "p", name: nil, cartItemId: "c", catalogItemId: "cat",
                currency: "USD", description: "", linkedProductId: nil,
                providerData: "", quantity: nil, totalPrice: nil, unitPrice: nil
            ),
            RoktEvent.EmbeddedSizeChanged(placementId: "p", updatedHeight: 100),
        ]
        XCTAssertEqual(events.count, 14)
    }
}
