//
//  LoginView.swift
//  LoginModule
//
//  Created by Mateusz Małek on 22.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import UIControlBinder
import Arithmos
import AudioToolbox
import Visuals
import FlashcardLogoView


// TODO: Clean up this mess! 
class LoginView: UIView {
   private let login: StandardWithLeftImageTextField
   private let password: StandardWithLeftImageTextField
   private let confirmButton: StandardButton
   private let backgroundImage: UIImageView
   private var passwordCenterYAnchor: NSLayoutConstraint?
   
   init(viewModel: ViewModel, confirmButtonPressedAction: ConfirmButtonPressedAction? = nil) {
      self.viewModel = viewModel
      
      self.login = StandardWithLeftImageTextField()
      self.password = StandardWithLeftImageTextField()
      self.confirmButton = StandardButton()
      self.backgroundImage = UIImageView()
      
      self.confirmButtonPressedAction = confirmButtonPressedAction
      super.init(frame: .zero)
      
      login.bind(with: viewModel.login, andObserver: loginChanged)
      password.bind(with: viewModel.password)
      login.leftImageView.bind(with: viewModel.loginImage)
      password.leftImageView.bind(with: viewModel.passwordImage)
      login.placeholder = viewModel.loginPlaceholder
      password.placeholder = viewModel.passwordPlaceholder
      
      self.buildView()
   }
   
   var viewModel: ViewModel {
      didSet {
         updateViewModel()
      }
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   typealias ConfirmButtonPressedAction = ((LoginView) -> Void)
   private let confirmButtonPressedAction: ConfirmButtonPressedAction?
   
   private enum PasswordFieldAccesibilty {
      case visible
      case hidden
      
      var centerYOffset: CGFloat {
         switch self {
         case .visible:
            return -50
         case .hidden:
            return -100
         }
      }
   }
   
   private var passwordFieldAccesibilty:PasswordFieldAccesibilty = .hidden
   
   public func fadeOut(_ duration:TimeInterval = 0.3) {
      UIView.animate(withDuration: duration) {
         self.layer.opacity = 0
      }
   }
   
   public func fadeIn(_ duration:TimeInterval = 0.3) {
      UIView.animate(withDuration: duration) {
         self.layer.opacity = 1
      }
   }
}

private extension LoginView {
   
   func updateViewModel() {
      confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)
   }
   
   func buildView() {
      self.addSubview(backgroundImage)
      self.addSubview(password)
      self.addSubview(login)
      self.addSubview(confirmButton)
      
      self.backgroundColor = .clear
      
      backgroundImage.translatesAutoresizingMaskIntoConstraints = false
      backgroundImage.contentMode = .scaleAspectFill
      backgroundImage.layer.opacity = 0 // for later animation
      
      password.isSecureTextEntry = true
      password.isUserInteractionEnabled = false
      password.layer.opacity = 0
      password.leftImageSize = CGSize(width:32, height: 24)
      login.leftImageSize = CGSize(width:32, height: 24)
      
      confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
      
      updateViewModel()
      
      NSLayoutConstraint.activate([
         backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
         backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
         backgroundImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
         backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
         ])
      
      NSLayoutConstraint.activate([
         login.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
         login.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
         login.heightAnchor.constraint(equalToConstant: 40),
         login.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100)
         ])
      
      NSLayoutConstraint.activate([
         password.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
         password.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
         password.heightAnchor.constraint(equalToConstant: 40),
         ])
      passwordCenterYAnchor = password.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: passwordFieldAccesibilty.centerYOffset)
      passwordCenterYAnchor?.isActive = true
      
      NSLayoutConstraint.activate([
         confirmButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
         confirmButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
         confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
         confirmButton.heightAnchor.constraint(equalToConstant: 40),
         confirmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 41)
         ])
   }
   
   @objc func confirmButtonPressed(sender: UIButton) {
      confirmButtonPressedAction?(self)
   }
   
   private func loginChanged(value: String) {
      if value != "" {
         showPasswordField()
      } else {
         hidePasswordField()
      }
   }
   
   private func showPasswordField() {
      passwordFieldAccesibilty = .visible
      passwordCenterYAnchor?.constant = passwordFieldAccesibilty.centerYOffset
      UIView.animate(withDuration: 0.5, animations: { [unowned self] in
         self.layoutIfNeeded()
         self.password.layer.opacity = 1
      }) { [unowned self] (finished) in
         if finished {
            self.password.isUserInteractionEnabled = true
         }
      }
   }
   
   private func hidePasswordField() {
      passwordFieldAccesibilty = .hidden
      passwordCenterYAnchor?.constant =  passwordFieldAccesibilty.centerYOffset
      self.password.isUserInteractionEnabled = false
      
      UIView.animate(withDuration: 0.5, animations: { [unowned self] in
         self.layoutIfNeeded()
         self.password.layer.opacity = 0
      }) { [unowned self] (finished) in
         if finished {
            self.password.text = ""
         }
      }
   }
}

extension LoginView {
   // MARK: - ViewModel
   struct ViewModel {
      let login:Variable<String>
      let password:Variable<String>
      let loginPlaceholder:String
      let passwordPlaceholder:String
      var confirmButtonTitle:String
      
      let loginImage:Variable<UIImage>
      let passwordImage:Variable<UIImage>
   }
}

extension Int {
   func times(_ repeatAction: () -> ()) {
      if self > 0 {
         for _ in 0..<self {
            repeatAction()
         }
      }
   }
   
   func times(_ repeatAction: @autoclosure () -> ()) {
      if self > 0 {
         for _ in 0..<self {
            repeatAction()
         }
      }
   }
}


enum ShakeOrientation {
   case horizontal
   case vertical
   
   struct Direction {
      let from: CGPoint
      let to: CGPoint
   }
   
   func directionsFor(deflection: CGFloat) -> [Direction] {
      return directionsInput.map { Direction(from: CGPoint(x: deflection*$0.0, y: deflection*$0.1), to: CGPoint(x: deflection*$0.2, y: deflection*$0.3)) }
   }
   
   private var directionsInput: [(CGFloat, CGFloat, CGFloat, CGFloat)] {
      switch self {
      case .horizontal:
         return [(0,0,-1,0), (-1,0,0,0), (0,0,1,0), (1,0,0,0)]
      case .vertical:
         return [(0,0,0,-1), (0,-1,0,0), (0,0,0,1), (0,1,0,0)]
      }
   }
}

extension UIView {
   func shake(times counter: Int = 3, duration: TimeInterval = 0.33, orientation: ShakeOrientation = .horizontal, deflection: CGFloat = 5) {
      let center = self.center
      var startTime:TimeInterval = 0
      let animationGroup: CAAnimationGroup = CAAnimationGroup()
      animationGroup.animations = []
      let singleStepDuration = duration/Double(counter * 4)
      let directions = orientation.directionsFor(deflection: deflection)
      counter.times {
         directions.forEach({ direction in
            let animation = CABasicAnimation(for: .position, from: center + direction.from, to: center + direction.to, duration: singleStepDuration)
            animation.beginTime = startTime
            startTime += singleStepDuration
            animationGroup.animations?.append(animation)
         })
      }
      animationGroup.duration = startTime
      self.layer.add(animationGroup, forKey: nil)
   }
}
