//
//  ViewController+Utils.swift
//  Module
//
//  Created by Mateusz Małek on 25.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import Visuals

extension UIViewController {
   override open func motionEnded(_ motion: UIEventSubtype,
                             with event: UIEvent?) {
      
      if motion == .motionShake{ //TODO: add some kind of flag to check if this is debug build
         
         let debugViewController = DebugThemeManagerSettingsViewController()
         
         present(debugViewController, animated: true, completion: nil)
      }
   }
}
