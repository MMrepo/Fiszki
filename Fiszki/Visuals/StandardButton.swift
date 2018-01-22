//
//  StandardButton.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import Themes

open class StandardButton: UIButton, Stylable {
    @objc dynamic public var titleLabelFont: UIFont! {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
    
    @objc dynamic public var backgroundColorNormal: UIColor? {
        didSet {
            backgroundColor = backgroundColorNormal
        }
    }
    @objc dynamic public var backgroundColorHighlighted: UIColor?
    var _backgroundColorHighlighted: UIColor? {
        return backgroundColorHighlighted != nil ? backgroundColorHighlighted : backgroundColorNormal
    }
    @objc dynamic public var backgroundColorSelected: UIColor?
    var _backgroundColorSelected: UIColor? {
        return backgroundColorSelected != nil ? backgroundColorSelected : _backgroundColorHighlighted
    }
    @objc dynamic public var backgroundColorHighlightedSelected: UIColor?
    var _backgroundColorHighlightedSelected: UIColor? {
        return backgroundColorHighlightedSelected != nil ? backgroundColorHighlightedSelected : _backgroundColorHighlighted
    }
    
    override open var isHighlighted: Bool {
        didSet {
            switch (isHighlighted, isSelected) {
            case (true, false):
                backgroundColor = _backgroundColorHighlighted
            case (true, true):
                backgroundColor = _backgroundColorHighlightedSelected
            case (false, true):
                backgroundColor = _backgroundColorSelected
            default:
                backgroundColor = backgroundColorNormal
            }
        }
    }
    
   public init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
   public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic public var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
     @objc dynamic public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
     @objc dynamic public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

extension StandardButton {
    public func setTheme(_ theme: Theme) {
        let borderWidth:CGFloat = 0.5
        let cornerRadius:CGFloat = 8
        self.titleLabelFont = theme.font(forTextStyle: .title1)

        switch theme.viewsStyles.button {
        case .bordered:
            makeBorderd(withColor: theme.colors.primary.contrast, width: borderWidth, backgroundColor: theme.colors.primary.dark)
            self.setTitleColor(theme.colors.primary.contrast, for: .normal)
            self.backgroundColorNormal = theme.colors.primary.dark
            self.backgroundColorHighlighted = theme.colors.primary.light
        case .normal:
            makeNormal(withBackgroundColor: theme.colors.primary.dark)
            self.setTitleColor(theme.colors.primary.contrast, for: .normal)
            self.backgroundColorNormal = theme.colors.primary.dark
            self.backgroundColorHighlighted = theme.colors.primary.light
        case .rounded:
            makeRounded(withRadius: cornerRadius, backgroundColor: theme.colors.primary.dark)
            self.setTitleColor(theme.colors.primary.contrast, for: .normal)
            self.backgroundColorNormal = theme.colors.primary.dark
            self.backgroundColorHighlighted = theme.colors.primary.light
        case .borderedAndTransparent:
            makeBorderedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth)
            self.setTitleColor(theme.colors.primary.light, for: .normal)
            self.backgroundColorNormal = .clear
            self.backgroundColorHighlighted = theme.colors.primary.light?.withAlphaComponent(0.5)
        case .borderedAndRounded:
            makeBorderedAndRounded(withColor: theme.colors.primary.contrast, width: borderWidth, radius: cornerRadius, backgroundColor: theme.colors.primary.dark)
            self.setTitleColor(theme.colors.primary.light, for: .normal)
            self.backgroundColorNormal = theme.colors.primary.dark
            self.backgroundColorHighlighted = theme.colors.primary.light
        case .borderedRoundedAndTransparent:
            makeBorderedRoundedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth, radius: cornerRadius)
            self.setTitleColor(theme.colors.primary.light, for: .normal)
            self.backgroundColorNormal = .clear
            self.backgroundColorHighlighted = theme.colors.primary.light?.withAlphaComponent(0.5)
        }
    }
}

