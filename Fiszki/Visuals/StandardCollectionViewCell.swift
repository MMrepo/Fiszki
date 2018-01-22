//
//  StandardCollectionViewCell.swift
//  Visuals
//
//  Created by Mateusz Małek on 19.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import Themes

open class StandardCollectionViewCell: UICollectionViewCell, Stylable {
   @objc dynamic public var backgroundColorNormal: UIColor? {
      didSet {
         backgroundColor = backgroundColorNormal
      }
   }
   
   public init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
      super.init(frame: .zero)
      self.translatesAutoresizingMaskIntoConstraints = false
   }
   
   public override init(frame: CGRect) {
      super.init(frame: .zero)
   }
   
   public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   @objc dynamic public var borderColor: UIColor? {
      get {
         if let cgColor = contentView.layer.borderColor {
            return UIColor(cgColor: cgColor)
         }
         return nil
      }
      set { contentView.layer.borderColor = newValue?.cgColor }
   }
   @objc dynamic public var borderWidth: CGFloat {
      get { return contentView.layer.borderWidth }
      set { contentView.layer.borderWidth = newValue }
   }
   
   @objc dynamic public var cornerRadius: CGFloat {
      get { return contentView.layer.cornerRadius }
      set {
         contentView.layer.cornerRadius = newValue }
   }
}

extension StandardCollectionViewCell {
   open func setTheme(_ theme: Theme) {
      let borderWidth:CGFloat = 0.5
      let cornerRadius:CGFloat = 20
      
      switch theme.viewsStyles.collectionViewCell {
      case .bordered:
         makeBorderd(withColor: theme.colors.primary.contrast, width: borderWidth, backgroundColor: theme.colors.primary.dark)
      case .normal:
         makeNormal(withBackgroundColor: UIColor.clear)
      case .rounded:
         makeRounded(withRadius: cornerRadius, backgroundColor: theme.colors.primary.dark)
      case .borderedAndTransparent:
         makeBorderedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth)
      case .borderedAndRounded:
         makeBorderedAndRounded(withColor: theme.colors.primary.contrast, width: borderWidth, radius: cornerRadius, backgroundColor: theme.colors.primary.dark)
      case .borderedRoundedAndTransparent:
         makeBorderedRoundedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth, radius: cornerRadius)
      }
      self.backgroundColorNormal = .clear
   }
}


