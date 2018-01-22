//
//  CreateFlashcardView+ViewModel.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

extension CreateFlashcardView {
    // MARK: - ViewModel
    struct ViewModel {
        var titlePlaceholder: String
        var definitionPlaceholder: String
        var translationPlaceholder: String
        var title: String
        var definition: String
        var translation: String
        var configurator: ViewConfigurator
    }
    
    // MARK: - ViewConfigurator
    struct ViewConfigurator {
        var titleBorderColor: UIColor?
        var titleBorderWidth: CGFloat?
        var titleFont: UIFont?
        
        var definitionBorderColor: UIColor?
        var definitionBorderWidth: CGFloat?
        var definitionFont: UIFont?
        
        var translationBorderColor: UIColor?
        var translationBorderWidth: CGFloat?
        var translationFont: UIFont?
        
        var headerBackgroundColor: UIColor?
        var cardViewBackgroundColor: UIColor?
        var cellShadowColor: UIColor?
        var cellShadowRadius: CGFloat?
        var cellShadowOpacity: Float?
        var cellShadowOffset: CGSize?
        var cellCornerRadius: CGFloat?
    }
}

extension CreateFlashcardView.ViewModel {
    // MARK: - Helpers
    init() {
        self.titlePlaceholder = ""
        self.definitionPlaceholder = ""
        self.translationPlaceholder = ""
        self.title = ""
        self.definition = ""
        self.translation = ""
        self.configurator = CreateFlashcardView.ViewConfigurator()
    }
}

