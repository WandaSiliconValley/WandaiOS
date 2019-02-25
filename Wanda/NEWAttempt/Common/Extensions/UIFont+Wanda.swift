//
//  UIFont+Wanda.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/22/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

public enum OpenSansFont: String {
    case regular = "OpenSans-Regular"
    case italic = "OpenSans-Italic"
    case semibold = "OpenSans-SemiBold"
    case bold = "OpenSans-Bold"
}

public extension UIFont {
    public static func wandaFontRegular(size: CGFloat) -> UIFont {
        return unwrapFontOrFallback(name: OpenSansFont.regular.rawValue, size: size)
    }

    public static func wandaFontItalic(size: CGFloat) -> UIFont {
        return unwrapFontOrFallback(name: OpenSansFont.italic.rawValue, size: size)
    }

    public static func wandaFontSemiBold(size: CGFloat) -> UIFont {
        return unwrapFontOrFallback(name: OpenSansFont.semibold.rawValue, size: size)
    }

    public static func wandaFontBold(size: CGFloat) -> UIFont {
        return unwrapFontOrFallback(name: OpenSansFont.bold.rawValue, size: size)
    }

    private static func unwrapFontOrFallback(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
