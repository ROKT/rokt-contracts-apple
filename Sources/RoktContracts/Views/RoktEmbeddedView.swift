#if canImport(UIKit)
import UIKit

/// Container view for embedding Rokt placements inline in the host app's UI.
///
/// Add a `RoktEmbeddedView` to your view hierarchy and pass it in the
/// `embeddedViews` dictionary when calling `selectPlacements`:
///
/// ```swift
/// let embeddedView = RoktEmbeddedView(frame: .zero)
/// stackView.addArrangedSubview(embeddedView)
///
/// rokt.selectPlacements(
///     "ConfirmationPage",
///     attributes: attributes,
///     embeddedViews: ["RoktEmbedded1": embeddedView]
/// )
/// ```
///
/// The view automatically resizes to fit the placement content.
/// Listen for ``RoktEvent/EmbeddedSizeChanged`` events to respond to size changes.
@objc(RoktEmbeddedView)
public class RoktEmbeddedView: UIView {}
#endif
