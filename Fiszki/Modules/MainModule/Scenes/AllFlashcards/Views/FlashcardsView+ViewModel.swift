//
//  FlashcardsView+ViewModel.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

extension FlashcardsView {
    // MARK: - ViewModel
    struct ViewModel {
        let title: String
    }
}

extension FlashcardsView.ViewModel {
    // MARK: - Helpers
    init() {
        self.title = ""
    }
}
