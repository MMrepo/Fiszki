//
//  FlashcardCell+ViewModel.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Visuals

extension FlashcardCell {
    // MARK: - ViewModel
    struct ViewModel {
        let title: String
        let definition: String
        let translation: String
        let style: Style
      
      enum Style:Int {
         case light
         case dark
         case normal
         
         init(withIndex index: Int) {
            self.init(rawValue: index % 3)!
         }
         
         var backgroundViewStyle: BackgroundView.Style {
            switch self {
            case .normal:
               return .secondary
            case .light:
               return .secondaryLight
            case .dark:
               return .secondaryDark
            }
         }
         
      }
    }
}

extension FlashcardCell.ViewModel {
    // MARK: - Helpers
    init() {
        self.title = ""
        self.definition = ""
        self.translation = ""
        self.style = .normal
    }
}
