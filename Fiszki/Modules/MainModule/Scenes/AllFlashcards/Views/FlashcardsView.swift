//
//  FlashcardsListView.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import Module

public final class FlashcardsView: UIView {
    private let collectionView: UICollectionView
    init(withViewModel viewModel: ViewModel = ViewModel()) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: CardsCollectionViewLayout())
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.addLayoutedSubview(collectionView)
    }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   internal var viewModel: ViewModel
}

extension FlashcardsView {
    // MARK: - exposed configuration helpers
    var dataSource: UICollectionViewDataSource? {
        get {
            return collectionView.dataSource
        }
        set(newDataSource) {
            collectionView.dataSource = newDataSource
            let layout = collectionView.collectionViewLayout as! CardsCollectionViewLayout
            layout.setup()
        }
    }
    
    var delegate: UICollectionViewDelegate? {
        get {
            return collectionView.delegate
        }
        set(newDelegate)  {
            collectionView.delegate = newDelegate
        }
    }
    
    var allowsMultipleSelection: Bool {
        get {
            return collectionView.allowsMultipleSelection
        }
        set(shouldAllow) {
            collectionView.allowsMultipleSelection = shouldAllow
        }
    }
    
    func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
         collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
   
    func refresh() {
        collectionView.reloadData()
    }
}

 
