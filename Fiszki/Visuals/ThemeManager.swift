//
//  ThemeManager.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Themes
import FlashcardLogoView
//import Iris

extension UIColor { // TODO: move this to IRIS!!!
   
   var isDark: Bool {
      get {
         let components = self.cgColor.components!
         let colorBrightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
         return colorBrightness < 0.8 ? true : false
      }
   }
}

public class ThemeManager {
   public private(set) static var currentTheme: Theme?
   private static var themesSet: [Themes:Theme] = [:]
   public enum Themes: String {
      case basic = "Basic"
      case basicRounded = "BasicRounded"
      case happy = "Happy"
      case calm = "Calm"
   }
   
   /* TODO: add some error handling here */
   private static func getJSONFromURL(_ resource:String) -> Data? {
      guard let filePath = Bundle.main.path(forResource: resource, ofType: "theme") else {
         return nil
      }
      let url = URL(fileURLWithPath: filePath)
      return try? Data(contentsOf: url, options: .mappedIfSafe)
   }
   
   public static func apply(theme: Themes) {
      if let theme = themesSet[theme] {
         apply(theme: theme)
      }
   }
   
   public static func load(theme: Themes) -> Theme? {
      let jsonDecoder = JSONDecoder()
      
      guard let data = ThemeManager.getJSONFromURL(theme.rawValue), let decodedTheme = try? jsonDecoder.decode(Theme.self, from: data) else {
         return nil
      }
      return decodedTheme
   }
   
   public static func loadAll() {
      themesSet[.basic] = load(theme: .basic)
      themesSet[.basicRounded] = load(theme: .basicRounded)
      themesSet[.happy] = load(theme: .happy)
      themesSet[.calm] = load(theme: .calm)
   }
   
   public static func apply(theme: Theme) {
      currentTheme = theme
      
      let standardButton = StandardButton.appearance()
      standardButton.setTheme(theme)
      
      let smallStandardButton = SmallStandardButton.appearance()
      smallStandardButton.titleLabelFont = theme.font(forTextStyle: .body)
      
      let standardTextField = StandardTextField.appearance()
      standardTextField.setTheme(theme)
      
      let standardWithLeftImageTextField = StandardWithLeftImageTextField.appearance()
      standardWithLeftImageTextField.leftImageTintColor = theme.colors.icon.normal
      
      let standardLabel = StandardLabel.appearance()
      standardLabel.setTheme(theme)
      
      let standardCollectionViewCell = StandardCollectionViewCell.appearance()
      standardCollectionViewCell.setTheme(theme)
      
      let collectionView = UICollectionView.appearance()
      collectionView.backgroundColor = theme.colors.primary.normal
      let backgroundView = BackgroundView.appearance()
      backgroundView.backgroundColors = [BackgroundView.Style.primary.rawValue: theme.colors.primary.normal, BackgroundView.Style.primaryLight.rawValue: theme.colors.primary.light, BackgroundView.Style.primaryDark.rawValue: theme.colors.primary.dark, BackgroundView.Style.secondary.rawValue: theme.colors.secondary.normal, BackgroundView.Style.secondaryLight.rawValue: theme.colors.secondary.light, BackgroundView.Style.secondaryDark.rawValue: theme.colors.secondary.dark]
      
      let navigationBar = UINavigationBar.appearance()
      navigationBar.barStyle = theme.colors.primary.normal.isDark ? .blackTranslucent : .default
      navigationBar.tintColor = theme.colors.primary.contrast
      
      let logoView = FlashcardLogoView.appearance()
      logoView.firstCardColor = theme.colors.secondary.normal
      logoView.secondCardColor = theme.colors.secondary.light ?? logoView.secondCardColor
      logoView.thirdCardColor = theme.colors.secondary.dark ?? logoView.thirdCardColor
      logoView.fontColor = theme.colors.secondary.contrast ?? logoView.fontColor
      
      for window in UIApplication.shared.windows {
         for view in window.subviews {
            view.removeFromSuperview()
            window.addSubview(view)
         }
         window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
      }
   }
}
