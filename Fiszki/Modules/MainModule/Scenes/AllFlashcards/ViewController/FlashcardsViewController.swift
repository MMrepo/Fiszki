//
//  FlashcardsViewController.swift
//  MainModule
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import Domain

public final class FlashcardsViewController: UIViewController {
    
    private let flashcardsListView: FlashcardsView
    private let services: FlashcardUseCases
    private var flashcardsDelegate: FlashcardsDelegate!
    private var flashcardsDataSource: FlashcardsDataSource!
    private let flashcardSetId: String
    private let navigator: FlashcardsNavigator

    public init(services: FlashcardUseCases, navigator: FlashcardsNavigator, flashcardSetId: String) {
        self.flashcardsListView = FlashcardsView()
        self.services = services
        self.flashcardSetId = flashcardSetId
        self.navigator = navigator
        flashcardsDataSource = FlashcardsDataSource(cellID: "FlashcardCell", services: services, flashcardSetId: flashcardSetId)
        flashcardsDelegate = FlashcardsDelegate()
        super.init(nibName: nil, bundle: nil)
        
        let flashcardSet = flashcardsDataSource.flashcardsSet(with: flashcardSetId)
        let viewModel = FlashcardsView.ViewModel(title: flashcardSet.title)
        flashcardsListView.viewModel = viewModel
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.flashcardsListView.delegate = flashcardsDelegate
        self.flashcardsListView.dataSource = flashcardsDataSource
        self.flashcardsListView.register(FlashcardCell.self, forCellReuseIdentifier: "FlashcardCell")
        self.flashcardsListView.allowsMultipleSelection = true
        self.view.addLayoutedSubview(flashcardsListView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flashcardsListView.refresh()
    }
    
    override public func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let flashcardSet = flashcardsDataSource.flashcardsSet(with: flashcardSetId)
        navigator.to(scene: .createFlashcard(flashcardSet))
    }
}

