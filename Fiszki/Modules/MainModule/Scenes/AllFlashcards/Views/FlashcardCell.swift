//
//  FlashcardCell.swift
//  MainModule
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation
import UIKit
import Module
import Arithmos
import Visuals
import UIControlBinder

final class FlashcardCell: StandardCollectionViewCell {
   private let title: StandardLabel
   private let definition: StandardLabel
   private let translation: StandardLabel
   private let stackView: UIStackView
   private let cardView: BackgroundView
   private let backView: BackgroundView
   
   override init(frame: CGRect) {
      self.title = StandardLabel()
      self.definition = StandardLabel()
      self.translation = StandardLabel()
      self.backView = BackgroundView()
      self.stackView = UIStackView()
      self.cardView = BackgroundView()
      
      super.init(frame: frame)
      self.prepareSubviews()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   var viewModel: ViewModel = ViewModel() {
      didSet {
         self.title.text = viewModel.title
         self.definition.text = viewModel.definition
         self.translation.text = viewModel.translation
         self.backView.style = viewModel.style.backgroundViewStyle
         self.cardView.style = viewModel.style.backgroundViewStyle
      }
   }
   
   private(set) var isFlipped: Bool = false
}

extension FlashcardCell: FlipableCell {
   func flip(withAnimation: Bool, to: Bool?)
   {
      if let to = to {
         isFlipped = to
      } else {
         isFlipped = !isFlipped
      }
      updateSide(flipped: isFlipped, withAnimation: withAnimation)
   }
   
   private func updateSide(flipped:Bool, withAnimation: Bool) {
      if flipped {
         backView.isHidden = false
         cardView.isHidden = true
         if withAnimation {
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
         }
      } else {
         backView.isHidden = true
         cardView.isHidden = false
         if withAnimation {
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
         }
      }
   }
}


extension FlashcardCell {
   // MARK: - Overriden cell behaviour
   override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
      let center = layoutAttributes.center
      let animation = CABasicAnimation(keyPath: "position.y")
      animation.toValue = center.y
      animation.duration = 0.3
      animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 2.0, 1.0, 1.0)
      layer.add(animation, forKey: "position.y")
      
      super.apply(layoutAttributes)
   }
}

private extension FlashcardCell {
   // MARK: - private helpers
   func addMainSubview(_ view: UIView) {
      self.contentView.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
      
      let nonRequiredPriority: UILayoutPriority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1.0)
      view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
      view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
      let bottomConstraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
      let trailingConstraint = view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
      bottomConstraint.isActive = true
      trailingConstraint.isActive = true
      bottomConstraint.priority = nonRequiredPriority
      trailingConstraint.priority = nonRequiredPriority
   }
   
   func prepareSubviews() {
      self.layer.masksToBounds = false
      self.contentView.clipsToBounds = true
      
      self.layer.shadowOffset = CGSize(width: 4, height: 5)
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowRadius = 2
      self.layer.shadowOpacity = 0.8
      
      addMainSubview(cardView)
      addMainSubview(backView)
      
      flip(withAnimation: false, to: false)
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.alignment = .center
      stackView.axis = .vertical
      let stackViewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      backView.addLayoutedSubview(stackView, withLayoutInsets: stackViewInsets)
      
      cardView.addCenterLayoutedSubview(title)
      definition.translatesAutoresizingMaskIntoConstraints = false
      translation.translatesAutoresizingMaskIntoConstraints = false
      definition.numberOfLines = 0
      translation.numberOfLines = 0
      
      title.fontStyle = .largeTitle
      definition.fontStyle = .body
      translation.fontStyle = .title1
      
      stackView.addArrangedSubview(definition)
      stackView.addArrangedSubview(translation)
   }
}

