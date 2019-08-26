//
//  Theme.swift
//  Themes
//
//  Created by Mateusz Małek on 16.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Iris
import UIKit

//Raw value has to be Int, so enum can be @objc
public enum ViewStyle: String, Codable {
    case normal
    case rounded
    case bordered
    case borderedAndTransparent
    case borderedAndRounded
    case borderedRoundedAndTransparent
}

public protocol PropertiesManagable {
   var properties: [Mirror.Child] {get}
   var propertiesCount: Int {get}
}

extension PropertiesManagable
{
   public var properties: [Mirror.Child] {
      return Mirror(reflecting: self).children.flatMap { $0 }
   }
   
   public var propertiesCount: Int {
      return properties.count
   }
}

public struct Theme:PropertiesManagable {
   public struct ColorSet:PropertiesManagable {
        public let normal: UIColor
        public let light: UIColor?
        public let dark: UIColor?
        public let contrast: UIColor?
    }
    
   internal struct FontSet: Codable, PropertiesManagable {
        let name: String
        let size: CGFloat
    }
    
    public struct ViewsStyles: Codable, PropertiesManagable {
        public let textField: ViewStyle
        public let textView: ViewStyle
        public let button: ViewStyle
        public let label: ViewStyle
        public let collectionViewCell: ViewStyle
    }
    
    public struct Colors: Codable, PropertiesManagable {
        public let primary: ColorSet
        public let secondary: ColorSet
        public let icon: ColorSet
        public let divider: ColorSet
    }
    
    internal let fonts: [UIFontTextStyle:FontSet]
    public let colors: Colors
    public let viewsStyles: ViewsStyles
    
    public func font(forTextStyle style: UIFontTextStyle) -> UIFont {
        guard let fontSet = fonts[style], let font = UIFont(name: fontSet.name, size: fontSet.size) else {
            return UIFont.preferredFont(forTextStyle: style)
        }
        return font
    }
}

extension Theme: Codable {
    private enum CodingKeys: String, CodingKey {
        case fonts = "fonts"
        case colors = "colors"
        case viewsStyles = "viewsStyles"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let _fonts: Dictionary<String, FontSet> = try container.decode(Dictionary<String, FontSet>.self, forKey: .fonts)
        let colors: Colors = try container.decode(Colors.self, forKey: .colors)
        let viewsStyles: ViewsStyles = try container.decode(ViewsStyles.self, forKey: .viewsStyles)
        let fonts = Dictionary(uniqueKeysWithValues:
            _fonts.map { key, fontSet in (UIFontTextStyle(key), fontSet)
        })
        self.init(fonts: fonts, colors: colors, viewsStyles: viewsStyles)
    }
    
    public func encode(to encoder: Encoder) throws {
        let _fonts = Dictionary(uniqueKeysWithValues:
            self.fonts.map { key, fontSet in (key.rawValue, fontSet)
        })
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colors, forKey: .colors)
        try container.encode(_fonts, forKey: .fonts)
        try container.encode(viewsStyles, forKey: .viewsStyles)
    }
}

extension Theme.ColorSet: Codable {
    private enum CodingKeys: String, CodingKey {
        case normal = "normal"
        case light = "light"
        case dark = "dark"
        case contrast = "contrast"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let normalHexString: String = try container.decode(String.self, forKey: .normal)
        let lightHexString: String?
        let darkHexString: String?
        let contrastHexString: String?
        var light: UIColor?
        var dark: UIColor?
        var contrast: UIColor?

        guard let normal = UIColor(hexString: normalHexString) else {
            throw DecodingError.dataCorruptedError(forKey: .normal, in: container, debugDescription: "Cannot initialize normal color from \(normalHexString)")
        }
        if container.contains(.light) {
            lightHexString = try container.decode(String.self, forKey: .light)
            light = lightHexString != nil ? UIColor(hexString: lightHexString!) : nil
        }
        if container.contains(.dark) {
           darkHexString = try container.decode(String.self, forKey: .dark)
           dark = darkHexString != nil ? UIColor(hexString: darkHexString!) : nil
        }
        if container.contains(.contrast) {
           contrastHexString = try container.decode(String.self, forKey: .contrast)
           contrast = contrastHexString != nil ? UIColor(hexString: contrastHexString!) : nil
        }

        self.init(normal: normal, light: light, dark: dark, contrast: contrast)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.normal.hexString, forKey: .normal)
        if let light = self.light?.hexString {
            try container.encode(light, forKey: .light)
        }
        if let dark = self.dark?.hexString {
            try container.encode(dark, forKey: .dark)
        }
        if let contrast = self.contrast?.hexString {
            try container.encode(contrast, forKey: .contrast)
        }
    }
}

