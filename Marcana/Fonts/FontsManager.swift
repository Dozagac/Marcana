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
    static let customFontlargeTitle = Font.custom("Avenir", size: Font.TextStyle.largeTitle.size, relativeTo: .body)
    static let customFontTitle = Font.custom("Avenir", size: Font.TextStyle.title.size, relativeTo: .body)
    static let customFontTitle2 = Font.custom("Avenir", size: Font.TextStyle.title2.size, relativeTo: .body)
    static let customFontTitle3 = Font.custom("Avenir", size: Font.TextStyle.title3.size, relativeTo: .body)
    static let customFontHeadline = Font.custom("Avenir", size: Font.TextStyle.headline.size, relativeTo: .headline)
    static let customFontBody = Font.custom("Avenir", size: Font.TextStyle.body.size, relativeTo: .body)
    static let customFontCallout = Font.custom("Avenir", size: Font.TextStyle.callout.size, relativeTo: .body)
    
    static let customFontSubheadline = Font.custom("Avenir", size: Font.TextStyle.subheadline.size, relativeTo: .body)
    static let customFontFootnote = Font.custom("Avenir", size: Font.TextStyle.footnote.size, relativeTo: .body)
    static let customFontCaption = Font.custom("Avenir", size: Font.TextStyle.caption.size, relativeTo: .body)
    static let customFontCaption2 = Font.custom("Avenir", size: Font.TextStyle.caption2.size, relativeTo: .body)
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
