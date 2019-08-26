//
//  DebugThemeManagerSettingsViewController.swift
//  Visuals
//
//  Created by Mateusz Małek on 24.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

public final class DebugThemeManagerSettingsViewController: UIViewController {
   
   let contentView = DebugThemeManagerSettingsView(frame: .zero)
   private let dataSource: DebugThemeManagerSettingsDataSource
   private let delegate: DebugThemeManagerSettingsDelegate
   
   public init() {
      dataSource = DebugThemeManagerSettingsDataSource()
      delegate = DebugThemeManagerSettingsDelegate()
      
      super.init(nibName: nil, bundle: nil)
      commonInit()
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      self.view.addSubview(contentView)
      setUpLayout()
   }
   
   override open func motionEnded(_ motion: UIEventSubtype,
                                  with event: UIEvent?) {
      
      if motion == .motionShake{ //TODO: add some kind of flag to check if this is debug build
            dismiss(animated: true, completion: nil)
      }
   }
}

public protocol EnumCollection: Hashable {
   static func cases() -> AnySequence<Self>
   static var allValues: [Self] { get }
}

public extension EnumCollection {
   
   public static func cases() -> AnySequence<Self> {
      return AnySequence { () -> AnyIterator<Self> in
         var raw = 0
         return AnyIterator {
            let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
            guard current.hashValue == raw else {
               return nil
            }
            raw += 1
            return current
         }
      }
   }
   
   public static var allValues: [Self] {
      return Array(self.cases())
   }
}

private class DebugThemeManagerSettingsDataSource: NSObject, UITableViewDataSource {
   enum Sections: Int, EnumCollection {
      case colors
      case fonts
      
      var name: String {
         switch self {
         case .colors:
            return "Colors"
         case .fonts:
            return "Fonts"
         }
      }
      
      var orderNumber: Int {
         return self.rawValue
      }
      
      var cellIdentifier: String {
         switch self {
         case .colors:
            return DebugColorTableViewCell.identifier
         case .fonts:
            return DebugFontTableViewCell.identifier
         }
      }
      
      func itemsFor(theme: Theme) -> Int {
         switch self {
         case .colors:
            return theme.colors.propertiesCount
         case .fonts:
            return theme.fonts.count
         }
      }
      
      func configureCell(cell: UITableViewCell, forRow row: Int, withTheme theme:Theme) {
         switch self {
         case .colors:
            guard let cell = cell as? DebugColorTableViewCell, let (title, color) = theme.colors.properties[row] as? (String, Theme.ColorSet)  else {
               return
            }
            
            cell.configureWith(title: title, andColor: color.normal)
         case .fonts:
            let keys = Array(theme.fonts.keys)
            let currentKey = keys[row]

            guard let cell = cell as? DebugFontTableViewCell, let fontSet = theme.fonts[currentKey] else {
               return
            }
            
            cell.configureWith(title: currentKey.rawValue, fontName: fontSet.name, andSize: fontSet.size)
         }
      }
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return Sections.allValues.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let theme = ThemeManager.currentTheme, let sectionGenerator = Sections(rawValue: section) else {
         return 0
      }
      return sectionGenerator.itemsFor(theme: theme)
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let theme = ThemeManager.currentTheme, let section = Sections(rawValue: indexPath.section), let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier) else {
         return UITableViewCell()
      }
      
      section.configureCell(cell: cell, forRow: indexPath.row, withTheme: theme)
      return cell
   }
   
   override init() {
      super.init()
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let sectionGenerator = Sections(rawValue: section) else {
         return nil
      }
      return sectionGenerator.name
   }
   
//   override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//      let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
//      header.titleLabel.text = sections[section].name
//      header.arrowLabel.text = ">"
//      header.setCollapsed(sections[section].collapsed)
//      header.section = section
//      header.delegate = self
//      return header
//   }
}

private class DebugThemeManagerSettingsDelegate: NSObject, UITableViewDelegate {
   func tableView(_ tableView: UITableView,
                  viewForHeaderInSection section: Int) -> UIView? {
         return DebugThemeHeaderView()
   }
}

private extension DebugThemeManagerSettingsViewController {
   private func commonInit() {
      contentView.set(dataSource: dataSource, andDelegate: delegate)
      contentView.register(DebugColorTableViewCell.nib, forCellReuseIdentifier: DebugColorTableViewCell.identifier)
      contentView.register(DebugFontTableViewCell.nib, forCellReuseIdentifier: DebugFontTableViewCell.identifier)
      
   }
   
   private func setUpLayout() {
      contentView.translatesAutoresizingMaskIntoConstraints = false
      contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
      contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
      contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
      contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
   }
}

