//
//  LoginNavigator.swift
//  LoginModule
//
//  Created by Mateusz Małek on 18.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Module
import Domain
import MainModule

public final class LoginNavigator: Navigator {
   public enum Scene {
      case start
      case flashcards
   }
   
   public typealias SceneType = Scene
   
   private let navigationController: UINavigationController?
   private let services: FlashcardUseCases /* UseCaseProvider IMPORTANT: change later to non-optional */
   
   public init(services: FlashcardUseCases, navigationController: UINavigationController? = nil) {
      self.navigationController = navigationController
      self.services = services
   }
   
   public func to(scene: Scene, withAnimation animation: Bool = true) {
      switch scene {
      case .flashcards:
         let navigator = FlashcardsNavigator(services: services, navigationController: navigationController)
         navigator.to(scene: .start)
      default:
         let viewController = LoginViewController(navigator: self)
         navigationController?.pushViewController(viewController, animated: true)
      }
   }
}
