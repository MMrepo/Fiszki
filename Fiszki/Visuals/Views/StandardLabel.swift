//
//  StandardLabel.swift
//  Visuals
//
//  Created by Mateusz Małek on 18.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

open class StandardLabel: UILabel, Stylable {
   public var fontStyle: UIFontTextStyle = .body {
      didSet {
         self.font = self.stylableFont
      }
   }
   
   @objc dynamic open var backgroundColorNormal: UIColor? {
      didSet {
         backgroundColor = backgroundColorNormal
      }
   }

   public init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
      super.init(frame: .zero)
      self.translatesAutoresizingMaskIntoConstraints = false
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      // This is workaround for iOS bug with UILabel and UIAppearance
      self.textColor = self.stylableTextColor
      self.font = self.stylableFont
   }
   
   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.translatesAutoresizingMaskIntoConstraints = false
   }
   
   @objc dynamic open var borderColor: UIColor? {
      get {
         if let cgColor = layer.borderColor {
            return UIColor(cgColor: cgColor)
         }
         return nil
      }
      set { layer.borderColor = newValue?.cgColor }
   }
   @objc dynamic open var borderWidth: CGFloat {
      get { return layer.borderWidth }
      set { layer.borderWidth = newValue }
   }
   @objc dynamic open var cornerRadius: CGFloat {
      get { return layer.cornerRadius }
      set { layer.cornerRadius = newValue }
   }
   
   // This is workaround for iOS bug with UILabel and UIAppearance
   @objc dynamic var stylableFont: UIFont? {
      get {
         return ThemeManager.currentTheme?.font(forTextStyle: fontStyle)
      }
   }
   // This is workaround for iOS bug with UILabel and UIAppearance
   @objc dynamic var stylableTextColor: UIColor? {
      didSet {
         self.textColor = stylableTextColor
      }
   }
}

extension StandardLabel {
   public func setTheme(_ theme: Theme) {
      let borderWidth:CGFloat = 0.5
      let cornerRadius:CGFloat = 8
      
      switch theme.viewsStyles.label {
      case .bordered:
         makeBorderd(withColor: theme.colors.primary.contrast, width: borderWidth, backgroundColor: theme.colors.primary.dark)
         self.stylableTextColor = theme.colors.secondary.contrast
      case .normal:
         makeNormal(withBackgroundColor: UIColor.clear)
         self.stylableTextColor = theme.colors.secondary.contrast
      case .rounded:
         makeRounded(withRadius: cornerRadius, backgroundColor: theme.colors.primary.dark)
         self.stylableTextColor = theme.colors.secondary.contrast
      case .borderedAndTransparent:
         makeBorderedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth)
         self.stylableTextColor = theme.colors.secondary.light
      case .borderedAndRounded:
         makeBorderedAndRounded(withColor: theme.colors.primary.contrast, width: borderWidth, radius: cornerRadius, backgroundColor: theme.colors.primary.dark)
         self.stylableTextColor = theme.colors.secondary.light
      case .borderedRoundedAndTransparent:
         makeBorderedRoundedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth, radius: cornerRadius)
         self.stylableTextColor = theme.colors.secondary.light
      }
   }
}

