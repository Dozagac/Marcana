//
//  FontsManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/01/2023.
//

import Foundation
import SwiftUI

struct FontsManager{
    struct NanumMyeongjo{
        static let regular = "NanumMyeongjo"
        static let bold = "NanumMyeongjoBold"
        static let extraBold = "NanumMyeongjoExtraBold"
    }
}

extension Font {
    static let veryLargeFont = Font.custom("Avenir", size: Font.TextStyle.largeTitle.size, relativeTo: .caption)
    static let largeFont = Font.custom("Avenir", size: Font.TextStyle.title.size, relativeTo: .caption)
    static let largeFont2 = Font.custom("Avenir", size: Font.TextStyle.title2.size, relativeTo: .caption)
    static let largeFont3 = Font.custom("Avenir", size: Font.TextStyle.title3.size, relativeTo: .caption)
    static let mediumLargeFont = Font.custom("Avenir", size: Font.TextStyle.headline.size, relativeTo: .caption)
    
    static let mediumFont = Font.custom("Avenir", size: Font.TextStyle.subheadline.size, relativeTo: .caption)
    static let mediumSmallFont = Font.custom("Avenir", size: Font.TextStyle.footnote.size, relativeTo: .caption)
    static let smallFont = Font.custom("Avenir", size: Font.TextStyle.caption.size, relativeTo: .caption)
    static let verySmallFont = Font.custom("Avenir", size: Font.TextStyle.caption2.size, relativeTo: .caption)
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption: return 12
        case .caption2: return 10
        @unknown default:
            return 8
        }
    }
}
