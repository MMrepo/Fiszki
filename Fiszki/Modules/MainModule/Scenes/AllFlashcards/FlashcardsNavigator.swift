//
//  FlashcardsNavigator.swift
//  MainModule
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Module
import Domain

public final class FlashcardsNavigator: Navigator {
    public enum Scene {
        case start
        case flashcardsSet(FlashcardSet)
        case flashcardDetail(Flashcard)
        case createFlashcard(FlashcardSet)
        case editFlashcard(Flashcard)
        case previous
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
        case .createFlashcard(let flashcardSet):
            let navigator = CreateFlashcardNavigator(services: services, navigationController: navigationController)
            let viewController = CreateFlashcardViewController(services: services, navigator: navigator, flashcardSet: flashcardSet)
            navigationController?.pushViewController(viewController, animated: true)
        case .editFlashcard(let flashcard):
            break
        case .flashcardDetail(let flashcard):
            break
        case .previous:
            navigationController?.popViewController(animated: true)
        case .flashcardsSet(let set):
            fallthrough
        default:
            /* start flashcardsSet scene */
            let viewController = FlashcardsViewController(services: services, navigator: self, flashcardSetId: "1")
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
