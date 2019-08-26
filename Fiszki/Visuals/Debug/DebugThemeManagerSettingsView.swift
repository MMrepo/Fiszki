//
//  DebugThemeManagerSettingsView.swift
//  Visuals
//
//  Created by Mateusz Małek on 24.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

class DebugThemeManagerSettingsView: UIView {

   private let tableView: UITableView

   override init(frame: CGRect) {
      tableView = UITableView()
      super.init(frame: frame)
      commonInit()
   }
   
   required init?(coder aDecoder: NSCoder) {
      tableView = UITableView()
      super.init(coder: aDecoder)
      commonInit()
   }
   
   func set(dataSource: UITableViewDataSource, andDelegate delegate: UITableViewDelegate) {
      self.tableView.dataSource = dataSource
      self.tableView.delegate = delegate
   }
   
   func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
      self.tableView.register(nib, forCellReuseIdentifier: identifier)
   }
   /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

private extension DebugThemeManagerSettingsView {
   private func commonInit() {
      tableView.allowsSelection = false
      tableView.separatorStyle = .none
      self.addSubview(tableView)
      setUpLayout()
   }
   
   private func setUpLayout() {
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
      tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
      tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
      tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
   }
}


