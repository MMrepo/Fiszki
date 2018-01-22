//
//  CreateFlashcardNavigator.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Module
import Domain

public final class CreateFlashcardNavigator: Navigator {
    public enum Scene {
        case previous
    }
    
    public typealias SceneType = Scene
    public typealias Completion = (() -> Void)
    private let navigationController: UINavigationController?
    private let services: FlashcardUseCases /* UseCaseProvider IMPORTANT: change later to non-optional */
    
    public init(services: FlashcardUseCases, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.services = services
    }
    
    public func to(scene: Scene, withAnimation animation: Bool = true) {
        switch scene {
        case .previous:
            navigationController?.popViewController(animated: true)
        }
    }
}

/* example how to handle modalViewControllers */
//public final class CreateFlashcardNavigator: Navigator {
//    public enum Scene {
//        case previous()
//    }
//
//    public typealias SceneType = Scene
//    public typealias Completion = (() -> Void)
//    private let navigationController: UINavigationController?
//    private let services: FlashcardUseCases /* UseCaseProvider IMPORTANT: change later to non-optional */
//    private let onReturnAction: Completion?
//
//    public init(services: FlashcardUseCases, navigationController: UINavigationController? = nil,  onReturnAction: Completion? = nil) {
//        self.navigationController = navigationController
//        self.services = services
//        self.onReturnAction = onReturnAction
//    }
//
//    public func to(scene: Scene, withAnimation animation: Bool = true) {
//        switch scene {
//        case .previous():
//            navigationController?.presentedViewController?.dismiss(animated: animation, completion: onReturnAction)
//        }
//    }
//}

