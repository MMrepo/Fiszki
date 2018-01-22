//
//  Application.swift
//  Fiszki
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import MainModule
import LoginModule
import DummyPlatform
import Visuals

final class Application {
    static let shared = Application()
    
 
    private init() {
        
    }
    
    func configureMainInterface(in window: UIWindow) {
        let navigationController = UINavigationController()
//        let services = DummyFlashcardUseCases()
//        let navigator = FlashcardsNavigator(services: services, navigationController: navigationController)
        window.rootViewController = navigationController
        ThemeManager.loadAll()
        let services = DummyFlashcardUseCases()
        let navigator = LoginNavigator(services: services, navigationController: navigationController)
//        window.rootViewController = navigationController

        navigator.to(scene: .start)
    }
    
//    private func configureLoginFlow(in window: UIWindow) {
//
//    }
//
//    private func configureOnboardingFlow(in window: UIWindow) {
//
//    }
}
