//
//  BackgroundView.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

open class BackgroundView: UIView {
 
   public enum Style:String {
      case primary
      case primaryLight
      case primaryDark
      case secondary
      case secondaryLight
      case secondaryDark
   }
   
   @objc dynamic open var backgroundColors: NSDictionary = [:] {
      didSet {
         updateBackgroundColor()
      }
   }
   open var style: Style = .primary {
      didSet {
         updateBackgroundColor()
      }
   }
    public init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BackgroundView {
   func updateBackgroundColor() {
      self.backgroundColor = backgroundColors.value(forKey: style.rawValue) as? UIColor
   }
}
