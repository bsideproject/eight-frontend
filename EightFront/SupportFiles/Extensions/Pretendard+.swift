//
//  Pretendard+.swift
//  EightFront
//
//  Created by wargi on 2022/10/16.
//

import UIKit

extension Fonts {
    enum Templates {
        case headline
        case title
        case subheader
        case subheader2
        case subheader3
        case menu
        case body1
        case body2
        case caption1
        case caption2

        var font: UIFont {
            switch self {
            case .headline:
                return Fonts.Pretendard.regular.font(size: 24)
            case .title:
                return Fonts.Pretendard.medium.font(size: 20)
            case .subheader:
                return Fonts.Pretendard.regular.font(size: 16)
            case .subheader2:
                return Fonts.Pretendard.medium.font(size: 16)
            case .subheader3:
                return Fonts.Pretendard.semiBold.font(size: 16)
            case .menu:
                return Fonts.Pretendard.medium.font(size: 14)
            case .body1:
                return Fonts.Pretendard.regular.font(size: 14)
            case .body2:
                return Fonts.Pretendard.medium.font(size: 14)
            case .caption1:
                return Fonts.Pretendard.regular.font(size: 12)
            case .caption2:
                return Fonts.Pretendard.regular.font(size: 10)
            }
        }
    }
}
