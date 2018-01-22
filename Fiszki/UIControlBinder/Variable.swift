//
//  Observable.swift
//  UIControlBinder
//
//  Created by Mateusz Małek on 14.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

@objc public protocol BindableControl {
    @objc(addTarget:action:forControlEvents:) func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents)
    @objc(removeTarget:action:forControlEvents:) func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents)
    @objc var hashValue: Int { get }
}

public class Variable<ObservedType:Equatable> {
    class Listener: NSObject {
        weak var owner: Variable<ObservedType>?
        @objc func valueNeedsToBeUpdated(sender: BindableControl) {
            if let control = (sender as? Notification)?.object as? BindableControl {
                owner?.updateValueFrom(control)
            } else {
                owner?.updateValueFrom(sender)
            }
        }
        
         init(owner: Variable<ObservedType>) {
            self.owner = owner
        }
    }
    
    typealias MethodForUpdatingValueInControl = (_ value: ObservedType, Int) -> Void
    typealias ObservableValueProvider = (_ control: BindableControl, Int) -> ObservedType?
    
    var listener: Listener? = nil
    private var getValueFromMethods: [Int:ObservableValueProvider]
    private var updateControlMethods: [Int:MethodForUpdatingValueInControl] {
        didSet {
            guard let newValue = _value, let (controlID, updateValueInControl) = updateControlMethods.filter({ (keyVal) -> Bool in
                oldValue[keyVal.key] == nil
            }).first else {
                return
            }
            updateValueInControl(newValue, controlID)
        }
    }
    
    private var _value: ObservedType?
    public var value: ObservedType? {
        set(newValue) {
            if let newValue = newValue {
                _value = newValue
                informAllControlsAbout(newValue)
            }
        }
        get {
            return _value
        }
    }
    
    public init(_ value: ObservedType? = nil) {
        _value = value
        updateControlMethods = [:]
        getValueFromMethods = [:]
        listener = Listener(owner: self)
    }
    
    
    //MARK: - methods for steering Variable
    func unbind(_ controlID: Int) {
        self.updateControlMethods[controlID] = nil
        self.getValueFromMethods[controlID] = nil
    }
    
    func addMethodForUpdateControl(with controlID: Int, _ valueChangeNotifier: @escaping MethodForUpdatingValueInControl) {
        self.updateControlMethods[controlID] = (valueChangeNotifier)
    }
    
    func addMethodForGettingValueFromControl(with controlID: Int, _ listener: @escaping ObservableValueProvider) {
        self.getValueFromMethods[controlID] = (listener)
    }
}

private extension Variable {
    func informAllControlsAbout(_ value: ObservedType, without originalReporterControlID: Int? = nil) {
        self.updateControlMethods.forEach {(controlReporterHash, updateValueInControl) in
            if originalReporterControlID != controlReporterHash {
                updateValueInControl(value, controlReporterHash)
            }
        }
    }
    
    func updateValueFrom(_ control: BindableControl) {
        guard let getValueFrom = self.getValueFromMethods[control.hashValue] else {
            return
        }
        _value = getValueFrom(control, control.hashValue)
        if let updatedValue = _value {
            informAllControlsAbout(updatedValue, without: control.hashValue)
        }
    }
}
