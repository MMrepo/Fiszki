//
//  CreateFlashcardViewController.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Domain

// temporary view controller for creating cards, just to see how couple of concepts work in battle
// TODO: Clean up this mess!

public final class CreateFlashcardViewController: UIViewController {
    
    private let createCardView: CreateFlashcardView
    private let services: FlashcardUseCases
    private let flashcardSet: FlashcardSet
    private let navigator: CreateFlashcardNavigator
    
    public init(services: FlashcardUseCases, navigator: CreateFlashcardNavigator, flashcardSet: FlashcardSet) {
        self.createCardView = CreateFlashcardView()
        self.services = services
        self.flashcardSet = flashcardSet
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        
        let config = createFlashcardConfig()
        let viewModel = CreateFlashcardView.ViewModel(titlePlaceholder: "Title here...", definitionPlaceholder: "Example definition", translationPlaceholder: "Tłumaczenie tutaj...", title: "", definition: "", translation: "", configurator: config)
        createCardView.viewModel = viewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addLayoutedSubview(createCardView)
    }
    
    override public func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func cancelButtonTapped() {
        navigator.to(scene: .previous)
    }
    
    @objc func doneButtonTapped() {
        let id = NSUUID().uuidString
        let viewModel = createCardView.viewModel
        let card = Flashcard(uid: id, title: viewModel.title, description: viewModel.definition, translation: viewModel.translation, createdAt: "\(Date().timeIntervalSince1970)", isLearned: false)
        add(card: card, to: flashcardSet)
        navigator.to(scene: .previous)
    }

    func add(card: Flashcard, to set:FlashcardSet){
        do {
            return try services.add(flashcard: card, to: set)
        } catch FlashcardError.noSets {
            fatalError("There are no flashcards sets!") // TODO: later might be better to show some notification instead of crashing ;)
        } catch FlashcardError.wrongCardId(let id) {
            fatalError("There is no flashcard with id: \(id)!")
        } catch FlashcardError.wrongSetId(let id) {
            fatalError("There is no flashcards set with id: \(id)!")
        } catch {
            fatalError("Undefined error just happend!")
        }
    }
    
    private func createFlashcardConfig() -> CreateFlashcardView.ViewConfigurator {
        var config = CreateFlashcardView.ViewConfigurator()
        config.titleBorderColor = .black
        config.definitionBorderColor = .darkGray
        config.translationBorderColor = .black
        config.titleBorderWidth = 1
        config.definitionBorderWidth = 1
        config.translationBorderWidth = 1
        
        config.cardViewBackgroundColor = .white
        config.cellShadowColor = .black
        config.cellShadowOffset = CGSize(width: 0, height: -1)
        config.cellShadowOpacity = 1
        config.cellShadowRadius = 2.0
        config.cellCornerRadius = 4.0
        config.titleFont = config.titleFont?.withSize(20)
        return config
    }
}
