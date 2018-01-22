//
//  Bindable.swift
//  UIControlBinder
//
//  Created by Mateusz Małek on 14.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var binder: UInt8 = 0
}

public protocol Bindable: class {
    associatedtype BindingType:Equatable
    
    func valueFrom(sender: BindableControl) -> BindingType?
    func updateValue(value: BindingType) -> Void
}

public extension Bindable where Self: BindableControl {
    private var bindedVariable: Variable<BindingType>? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.binder) as? Variable<BindingType>
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func bind(with variable: Variable<BindingType>, andObserver observer:((BindingType) -> Void)? = nil) {
        self.bindedVariable?.unbind(self.hashValue)
        
        self.bindedVariable = variable
        self.addTarget(variable.listener, action: #selector(variable.listener?.valueNeedsToBeUpdated), for: [.editingChanged, .valueChanged])
        
        variable.addMethodForGettingValueFromControl(with: self.hashValue) {[weak self] (listner, reporter) -> Self.BindingType? in
            if let _self = self {
                guard let value = _self.valueFrom(sender: listner) else {
                    return nil
                }
                observer?(value)
                return value
            }
            variable.unbind(reporter)
            return nil
        }
     
        variable.addMethodForUpdateControl(with: self.hashValue) {[weak self] (value, controlID) in
            if let _self = self {
                DispatchQueue.main.async {
                    _self.updateValue(value: value)
                }
            } else {
                variable.unbind(controlID)
            }
        }
    }
    
    public func unbind() {
        guard let variable = self.bindedVariable else {
            // there is nothing binded to self
            return
        }
        self.removeTarget(variable.listener, action: #selector(variable.listener?.valueNeedsToBeUpdated), for: [.editingChanged, .valueChanged])
        variable.unbind(self.hashValue)
        self.bindedVariable = nil
    }
}

