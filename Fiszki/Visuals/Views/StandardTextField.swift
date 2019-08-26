//
//  StandardTextField.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit

open class StandardTextField: UITextField, Stylable{
    @objc dynamic open var placeholderColor: UIColor? {
        didSet {
            updatePlaceholderColor(placeholderColor)
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholderColor(placeholderColor)
        }
    }
    
    init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.translatesAutoresizingMaskIntoConstraints = false
   }
    
    @objc dynamic open var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    @objc dynamic open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @objc dynamic open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

private extension StandardTextField {
    func updatePlaceholderColor(_ color:UIColor?) {
        guard let placeholderText = self.placeholder else {
            return
        }
        self.placeholder = nil
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedStringKey.foregroundColor: color?.withAlphaComponent(0.2) as Any])
    }
}

extension StandardTextField {
    public func setTheme(_ theme: Theme) {
        let borderWidth:CGFloat = 0.5
        let cornerRadius:CGFloat = 8
        self.font = theme.font(forTextStyle: .body)
        
        switch theme.viewsStyles.textField {
        case .bordered:
            makeBorderd(withColor: theme.colors.primary.contrast, width: borderWidth, backgroundColor: theme.colors.primary.dark)
            self.textColor = theme.colors.primary.contrast
            self.placeholderColor = theme.colors.primary.contrast
        case .normal:
            makeNormal(withBackgroundColor: theme.colors.primary.dark)
            self.textColor = theme.colors.primary.contrast
            self.placeholderColor = theme.colors.primary.contrast
        case .rounded:
            makeRounded(withRadius: cornerRadius, backgroundColor: theme.colors.primary.dark)
            self.textColor = theme.colors.primary.contrast
            self.placeholderColor = theme.colors.primary.contrast
        case .borderedAndTransparent:
            makeBorderedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth)
            self.textColor = theme.colors.primary.dark
            self.placeholderColor = theme.colors.primary.dark
        case .borderedAndRounded:
            makeBorderedAndRounded(withColor: theme.colors.primary.contrast, width: borderWidth, radius: cornerRadius, backgroundColor: theme.colors.primary.dark)
            self.textColor = theme.colors.primary.contrast
            self.placeholderColor = theme.colors.primary.contrast
        case .borderedRoundedAndTransparent:
            makeBorderedRoundedAndTransparent(withColor: theme.colors.primary.dark, width: borderWidth, radius: cornerRadius)
            self.textColor = theme.colors.primary.dark
            self.placeholderColor = theme.colors.primary.dark
        }
    }
}

