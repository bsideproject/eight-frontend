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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Images {
  internal static let currentLocation = ImageAsset(name: "current-location")
  internal enum Home {
    internal static let add = ImageAsset(name: "add")
    internal static let alarm = ImageAsset(name: "alarm")
    internal static let detail = ImageAsset(name: "detail")
    internal static let list = ImageAsset(name: "list")
    internal static let search = ImageAsset(name: "search")
  }
  internal enum KakaoLoginButton {
    internal static let bottomSheetView = ImageAsset(name: "bottomSheetView")
    internal static let largeNarrow = ImageAsset(name: "large_narrow")
    internal static let largeWide = ImageAsset(name: "large_wide")
    internal static let mediumNarrow = ImageAsset(name: "medium_narrow")
    internal static let mediumWide = ImageAsset(name: "medium_wide")
  }
  internal enum Map {
    internal static let boxEdit = ImageAsset(name: "box-edit")
    internal static let boxThumnail = ImageAsset(name: "box-thumnail")
    internal static let markerNone = ImageAsset(name: "marker-none")
    internal static let markerSelect = ImageAsset(name: "marker-select")
  }
  internal enum Navigation {
    internal static let back = ImageAsset(name: "back")
  }
  internal enum Report {
    internal static let addPhoto = ImageAsset(name: "add-photo")
    internal static let checkComplete = ImageAsset(name: "check-complete")
    internal static let checkboxNone = ImageAsset(name: "checkbox-none")
    internal static let checkboxSelect = ImageAsset(name: "checkbox-select")
    internal static let search = ImageAsset(name: "search")
  }
  internal enum Tabbar {
    internal static let alarmNone = ImageAsset(name: "alarm-none")
    internal static let alarmSelect = ImageAsset(name: "alarm-select")
    internal static let feedNone = ImageAsset(name: "feed-none")
    internal static let feedSelect = ImageAsset(name: "feed-select")
    internal static let homeNone = ImageAsset(name: "home-none")
    internal static let homeSelect = ImageAsset(name: "home-select")
    internal static let myPageNone = ImageAsset(name: "my-page-none")
    internal static let myPageSelect = ImageAsset(name: "my-page-select")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
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
