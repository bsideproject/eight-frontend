// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Images {
  internal static let currentLocation = ImageAsset(name: "current-location")
  internal enum Detail {
    internal static let defaultProfile = ImageAsset(name: "default_profile")
    internal static let more = ImageAsset(name: "more")
  }
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
  internal enum Mypage {
    internal static let crown = ImageAsset(name: "Crown")
    internal static let headphones = ImageAsset(name: "Headphones")
    internal static let info = ImageAsset(name: "Info")
    internal static let settings = ImageAsset(name: "Settings")
  }
  internal enum Navigation {
    internal static let back = ImageAsset(name: "back")
    internal static let post = ImageAsset(name: "post")
  }
  internal enum NavigationIcon {
    internal static let kakaoCircleIcon = ImageAsset(name: "kakao_circle_icon")
    internal static let naverCircleIcon = ImageAsset(name: "naver_circle_icon")
  }
  internal enum Report {
    internal static let checkboxSelectNone = ImageAsset(name: "Checkbox-select-none")
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
  internal enum Test {
    internal static let cinema = ImageAsset(name: "cinema")
    internal static let clown = ImageAsset(name: "clown")
    internal static let hamburger = ImageAsset(name: "hamburger")
    internal static let panda = ImageAsset(name: "panda")
    internal static let poop = ImageAsset(name: "poop")
    internal static let puppy = ImageAsset(name: "puppy")
    internal static let robot = ImageAsset(name: "robot")
    internal static let subway = ImageAsset(name: "subway")
  }
  internal enum Trade {
    internal static let bottomArrow = ImageAsset(name: "bottom-arrow")
    internal static let filterBackground = ImageAsset(name: "filter-background")
    internal static let leftArrow = ImageAsset(name: "left-arrow")
    internal static let rightArrow = ImageAsset(name: "right-arrow")
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

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
