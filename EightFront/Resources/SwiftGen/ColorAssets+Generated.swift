// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Colors {
  internal enum Report {
    internal static let reportCompletedBackgroudColor = ColorAsset(name: "reportCompletedBackgroudColor")
    internal static let reportCompletedFontColor = ColorAsset(name: "reportCompletedFontColor")
    internal static let reportIngBackgroundColor = ColorAsset(name: "reportIngBackgroundColor")
    internal static let reportIngFontColor = ColorAsset(name: "reportIngFontColor")
    internal static let reportRejectBackgroundColor = ColorAsset(name: "reportRejectBackgroundColor")
    internal static let reportRejectFontColor = ColorAsset(name: "reportRejectFontColor")
  }
  internal static let gray001 = ColorAsset(name: "gray001")
  internal static let gray002 = ColorAsset(name: "gray002")
  internal static let gray003 = ColorAsset(name: "gray003")
  internal static let gray004 = ColorAsset(name: "gray004")
  internal static let gray005 = ColorAsset(name: "gray005")
  internal static let gray006 = ColorAsset(name: "gray006")
  internal static let gray007 = ColorAsset(name: "gray007")
  internal static let gray008 = ColorAsset(name: "gray008")
  internal static let point = ColorAsset(name: "point")
  internal static let shadow001 = ColorAsset(name: "shadow001")
  internal static let shadow003 = ColorAsset(name: "shadow003")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
