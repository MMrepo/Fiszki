//
//  Navigator.swift
//  Module
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
//public protocol Placeholder /* temporary protocol, to be fixed with proper one later */ {
//    
//}

// move this to toolbox
extension UIView {
    
    public func addLayoutedSubview(_ view: UIView, withLayoutInsets insets: UIEdgeInsets = .zero) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right)
            ])
    }
    
    public func addCenterLayoutedSubview(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            ])
    }
}

public protocol Navigator {
    associatedtype SceneType
    func to(scene: SceneType, withAnimation animation: Bool)
}
