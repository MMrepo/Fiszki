//
//  UIControls+Bindable.swift
//  UIControlBinder
//
//  Created by Mateusz Małek on 14.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

extension UITextField: Bindable, BindableControl {
    public func valueFrom(sender: BindableControl) -> String? {
        if let sender = sender as? SenderType {
            return sender.text
        }
        return nil
    }
    
    public func updateValue(value: String) {
        self.text = value
    }
    
    public typealias BindingType = String
    public typealias SenderType = UITextField
}

extension UIImageView: Bindable {
    public func valueFrom(sender: BindableControl) -> UIImage? {
        if let sender = sender as? SenderType {
            return sender.image
        }
        return nil
    }
    
    public func updateValue(value: UIImage) {
        self.image = value
    }

    public typealias BindingType = UIImage
    public typealias SenderType = UIImageView
}

extension UIImageView: BindableControl {
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        if let target = target, controlEvents.contains(.valueChanged) {
            NotificationCenter.default.addObserver(target, selector: action, name: NSNotification.Name(rawValue: "UIImageViewImageChanged"), object: self)
        }
    }
    
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        if let target = target, controlEvents.contains(.valueChanged) {
            NotificationCenter.default.removeObserver(target, name: NSNotification.Name(rawValue: "UIImageViewImageChanged"), object: self)
        }
    }
}
extension UISwitch: Bindable, BindableControl {
    public func updateValue(value: String) {
        if value == "On" {
            self.isOn = true
        } else {
            self.isOn = false
        }
    }
    
    public func valueFrom(sender: BindableControl) -> String? {
        if let sender = sender as? SenderType {
            if sender.isOn {
                return "On"
            } else {
                return "Off"
            }
        }
        return nil
    }
    
    public typealias BindingType = String
    public typealias SenderType = UISwitch
}

extension UITextView: Bindable{
    public func updateValue(value: String) {
        self.text = value
    }
    
    public func valueFrom(sender: BindableControl) -> String? {
        return self.text
    }
    
    public typealias BindingType = String
    public typealias SenderType = UITextView
}

extension UITextView: BindableControl {
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        if let target = target, controlEvents.contains(.valueChanged) {
            NotificationCenter.default.addObserver(target, selector: action, name: Notification.Name.UITextViewTextDidChange, object: self)
        }
    }
    
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        if let target = target, controlEvents.contains(.valueChanged) {
            NotificationCenter.default.removeObserver(target, name: Notification.Name.UITextViewTextDidChange, object: self)
        }
    }
}
