//
//  StandardWithLeftImageTextField.swift
//  Visuals
//
//  Created by Mateusz Małek on 17.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit


open class StandardWithLeftImageTextField: StandardTextField {
    public private(set) var leftImageView: UIImageView = UIImageView()
    private var leftImageContainerView: UIView = UIView()
    
    public override init(translatesAutoresizingMaskIntoConstraints: Bool = false) {
        super.init(translatesAutoresizingMaskIntoConstraints: translatesAutoresizingMaskIntoConstraints)
        
        setLeftImageViewSize(StandardWithLeftImageTextField.defaultLeftImageSize)
        leftImageView.contentMode = .scaleAspectFit
        leftImageContainerView.addSubview(leftImageView)
        
        self.leftView = leftImageContainerView
        self.leftViewMode = .always
    }
    
   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.translatesAutoresizingMaskIntoConstraints = false
   }
    
    open var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
        }
    }
    
     @objc dynamic open var leftImageTintColor: UIColor? {
        didSet {
            leftImageView.tintColor = leftImageTintColor?.withAlphaComponent(0.2)
        }
    }
    
    open var leftImageSize: CGSize? {
        didSet {
            guard let size = leftImageSize else {
                return
            }
            setLeftImageViewSize(size)
        }
    }
    
    private static let defaultLeftImageSize = CGSize(width: 24, height: 24)
}

private extension StandardWithLeftImageTextField {
    func setLeftImageViewSize(_ size:CGSize) {
        leftImageContainerView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        leftImageView.frame = CGRect(x: 0, y: 0, width: size.width , height: size.height)
        leftImageView.center = leftImageContainerView.center
    }
}


