//
//  CreateFlashcardView.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import Module
import Arithmos

// TODO: Clean up this mess!
final class CreateFlashcardView: UIView {
    private let title: UITextField
    private let definition: UITextView
    private let translation: UITextField
    private let stackView: UIStackView
    private let shadowView: UIView
    private let cardView: UIView
    
    init() {
        self.title = UITextField()
        self.definition = UITextView()
        self.translation = UITextField()
        self.shadowView = UIView()
        self.stackView = UIStackView()
        self.cardView = UIView()
        super.init(frame: .zero)
        
        self.prepareSubviews()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        self.title = UITextField()
        self.definition = UITextView()
        self.translation = UITextField()
        self.shadowView = UIView()
        self.stackView = UIStackView()
        self.cardView = UIView()
        super.init(coder: aDecoder)
        
        self.prepareSubviews()
    }

    private var _viewModel: ViewModel = ViewModel()
}

extension CreateFlashcardView: ViewWithViewModel {
    // MARK: - WithViewModel implementation
    
    var viewModel: ViewModel {
        set(newViewModel) {
            _viewModel = newViewModel
            bindWithViewModel()
        }
        get {
            updateViewModel()
            return _viewModel
        }
    }
    
    internal func bindWithViewModel() {
        self.title.placeholder = _viewModel.titlePlaceholder
        self.definition.text = _viewModel.definitionPlaceholder
        self.translation.placeholder = _viewModel.translationPlaceholder
        
        /* setting nil to those label properties causes it to be reset to the default value. */
        self.title.layer.borderColor = _viewModel.configurator.titleBorderColor?.cgColor
        self.definition.layer.borderColor = _viewModel.configurator.definitionBorderColor?.cgColor
        self.translation.layer.borderColor = _viewModel.configurator.translationBorderColor?.cgColor
        self.title.layer.borderWidth = _viewModel.configurator.titleBorderWidth ?? 0
        self.definition.layer.borderWidth = _viewModel.configurator.definitionBorderWidth ?? 0
        self.translation.layer.borderWidth = _viewModel.configurator.translationBorderWidth ?? 0

        self.title.font = _viewModel.configurator.titleFont
        self.definition.font = _viewModel.configurator.definitionFont
        self.translation.font = _viewModel.configurator.translationFont
        
        self.cardView.backgroundColor = _viewModel.configurator.cardViewBackgroundColor
        self.shadowView.backgroundColor = .clear
        
        if let cellShadowColor = _viewModel.configurator.cellShadowColor, let cellShadowRadius = _viewModel.configurator.cellShadowRadius, let cellShadowOpacity = _viewModel.configurator.cellShadowOpacity, let cellShadowOffset = _viewModel.configurator.cellShadowOffset, let cellCornerRadius = _viewModel.configurator.cellCornerRadius {
            self.shadowView.layer.shadowRadius = cellShadowRadius
            self.shadowView.layer.shadowColor = cellShadowColor.cgColor
            self.shadowView.layer.shadowOpacity = cellShadowOpacity
            self.shadowView.layer.shadowOffset = cellShadowOffset
            self.cardView.layer.cornerRadius = cellCornerRadius
        }
    }
    
    internal func updateViewModel() {
        _viewModel.title = self.title.text ?? _viewModel.title
        _viewModel.definition = self.definition.text ?? _viewModel.title
        _viewModel.translation = self.translation.text ?? _viewModel.translation
    }
}

private extension CreateFlashcardView {
    // MARK: - private helpers
    func prepareSubviews() {
        self.addCenterLayoutedSubview(shadowView)
        let width = UIScreen.main.bounds.width // TODO: change this to use superview instead
        let height = UIScreen.main.bounds.height
        let dimmension = width < height ? width : height
        
        let cardViewInsets = UIEdgeInsets(top: 4, left: 6, bottom: -8, right: -6)
        shadowView.addLayoutedSubview(cardView, withLayoutInsets: cardViewInsets)

        let stackViewInsets = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        cardView.addLayoutedSubview(stackView, withLayoutInsets: stackViewInsets)
        
        let textViewContainer = UIView()
        textViewContainer.addLayoutedSubview(definition)
        let separator = UIView()

        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(textViewContainer)
        stackView.addArrangedSubview(translation)
        stackView.addArrangedSubview(separator)
        
        NSLayoutConstraint.activate([
            shadowView.widthAnchor.constraint(equalToConstant: dimmension - 6),
            shadowView.heightAnchor.constraint(equalToConstant: dimmension - 12),
            ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        definition.translatesAutoresizingMaskIntoConstraints = false
        translation.translatesAutoresizingMaskIntoConstraints = false

        separator.backgroundColor = .clear
        separator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        separator.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        definition.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true

        cardView.clipsToBounds = true
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
    }
}
