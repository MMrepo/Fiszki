//
//  Stylable.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

public protocol Stylable:class {
    func setTheme(_ theme: Theme)
    var borderColor: UIColor? { get set }
    var borderWidth: CGFloat { get set }
    var cornerRadius: CGFloat { get set }
}

extension Stylable where Self:UIView {
    
    func makeBorderd(withColor color: UIColor?, width: CGFloat, backgroundColor: UIColor?, reset: Bool = true) {
        if reset { makeNormal(withBackgroundColor: backgroundColor) }
        self.borderWidth = 0.5
        self.borderColor = color
    }
    
    func makeNormal(withBackgroundColor backgroundColor: UIColor?) {
        self.borderColor = nil
        self.borderWidth = 0
        self.cornerRadius = 0
        self.backgroundColor = backgroundColor
    }
    
    func makeRounded(withRadius radius: CGFloat, backgroundColor: UIColor?, reset: Bool = true) {
        if reset { makeNormal(withBackgroundColor: backgroundColor) }
        self.cornerRadius = radius
    }
    
    func makeBorderedAndTransparent(withColor color: UIColor?, width: CGFloat) {
        makeBorderd(withColor: color, width: width, backgroundColor: .clear)
    }
    
    func makeBorderedAndRounded(withColor color: UIColor?, width: CGFloat, radius: CGFloat, backgroundColor: UIColor?) {
        makeRounded(withRadius: radius, backgroundColor: backgroundColor)
        makeBorderd(withColor: color, width: width, backgroundColor: backgroundColor, reset: false)
    }
    
    func makeBorderedRoundedAndTransparent(withColor color: UIColor?, width: CGFloat, radius: CGFloat) {
        makeRounded(withRadius: radius, backgroundColor: .clear)
        makeBorderd(withColor: color, width: width, backgroundColor: .clear, reset: false)
    }
}
