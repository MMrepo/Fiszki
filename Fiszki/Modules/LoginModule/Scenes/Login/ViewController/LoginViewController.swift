//
//  LoginViewController.swift
//  LoginModule
//
//  Created by Mateusz Małek on 18.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import UIControlBinder
import Arithmos
import AudioToolbox
import Visuals
import FlashcardLogoView


// temporary test login view controller, just to see how couple of concepts work in battle
// TODO: Clean up this mess!

class LoginViewController: UIViewController {
   
   private let themeBasicButton = SmallStandardButton()
   private let themeBasicRoundedButton = SmallStandardButton()
   private let themeHappyButton = SmallStandardButton()
   private let themeCalmButton = SmallStandardButton()
   private let goFurtherButton = SmallStandardButton()

   private let backgroundView = BackgroundView()
   private let logoView = FlashcardLogoView()
   private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
   
   private let navigator: LoginNavigator
   public init(navigator: LoginNavigator) {
      
      self.navigator = navigator
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(true, animated: animated)
      super.viewWillAppear(animated)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(false, animated: animated)
      super.viewWillDisappear(animated)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.view.addSubview(backgroundView)
      self.backgroundView.addSubview(logoView)
      logoView.translatesAutoresizingMaskIntoConstraints = false
      
      configureThemeButton(themeBasicButton, title: "Basic")
      configureThemeButton(themeBasicRoundedButton, title: "BasicRounded")
      configureThemeButton(themeHappyButton, title: "Happy")
      configureThemeButton(themeCalmButton, title: "Calm")
      goFurtherButton.translatesAutoresizingMaskIntoConstraints = false
      goFurtherButton.setTitle("Flashcards", for: .normal)
      goFurtherButton.addTarget(self, action: #selector(goFurtherButtonPressed), for: .touchUpInside)
      backgroundView.addSubview(goFurtherButton)

      NSLayoutConstraint.activate([
         themeBasicButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
         themeBasicButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
         ])
      NSLayoutConstraint.activate([
         themeBasicRoundedButton.leadingAnchor.constraint(equalTo: self.themeBasicButton.trailingAnchor, constant: 10),
         themeBasicRoundedButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
         ])
      NSLayoutConstraint.activate([
         themeHappyButton.leadingAnchor.constraint(equalTo: self.themeBasicRoundedButton.trailingAnchor, constant: 10),
         themeHappyButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
         ])
      NSLayoutConstraint.activate([
         themeCalmButton.leadingAnchor.constraint(equalTo: self.themeHappyButton.trailingAnchor, constant: 10),
         themeCalmButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
         ])
      NSLayoutConstraint.activate([
         goFurtherButton.leadingAnchor.constraint(equalTo: self.themeCalmButton.trailingAnchor, constant: 10),
         goFurtherButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
         ])
      
      ThemeManager.apply(theme: .basic)
      let loginView = buildLoginView()
      loginView.translatesAutoresizingMaskIntoConstraints = false
      backgroundView.addSubview(loginView)
      
      NSLayoutConstraint.activate([
         backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
         backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
         backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:  0)
         ])
      self.keyboardHeightLayoutConstraint = backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:  0)
      self.keyboardHeightLayoutConstraint?.isActive = true
      
      let screenDim = UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
      let loginWidth = screenDim > 375 ? 335 : screenDim - 40
      
      NSLayoutConstraint.activate([
         loginView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
         loginView.widthAnchor.constraint(equalToConstant: loginWidth),
         loginView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0),
         loginView.heightAnchor.constraint(equalToConstant: loginWidth)
         ])
      
      NSLayoutConstraint.activate([
         logoView.widthAnchor.constraint(equalToConstant: loginWidth),
         logoView.heightAnchor.constraint(equalToConstant: loginWidth),
         logoView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
         logoView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0)
         ])
      
      self.view.layoutIfNeeded()
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
      
   }
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
   @objc func keyboardNotification(notification: NSNotification) {
      if let userInfo = notification.userInfo {
         let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
         let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
         let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
         let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
         let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
         if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 0.0
         } else {
            self.keyboardHeightLayoutConstraint?.constant = -1 * (endFrame?.size.height ?? 0.0)
         }
         UIView.animate(withDuration: duration,
                        delay: TimeInterval(0),
                        options: animationCurve,
                        animations: { self.view.layoutIfNeeded() },
                        completion: nil)
      }
   }
   
   func buildLoginView() -> LoginView {
      let login = Variable("")
      let password = Variable("")
      let loginPlaceholder = "Username"
      let passwordPlaceholder = "Password"
      let confirmButtonTitle = "Log in"
      let loginImage = Variable(#imageLiteral(resourceName: "LoginIcon").withRenderingMode(.alwaysTemplate))
      let passwordImage = Variable(#imageLiteral(resourceName: "PasswordIcon").withRenderingMode(.alwaysTemplate))
      
      let viewModel = LoginView.ViewModel(login: login, password: password, loginPlaceholder: loginPlaceholder, passwordPlaceholder: passwordPlaceholder, confirmButtonTitle: confirmButtonTitle, loginImage: loginImage, passwordImage: passwordImage)
      
      return LoginView(viewModel: viewModel, confirmButtonPressedAction:loginConfirmButtonPressed)
   }
   
   func loginConfirmButtonPressed(sender: LoginView) {
      //shake baby
         if sender.viewModel.login.value?.lowercased() == "login" && sender.viewModel.password.value?.lowercased() == "pass" {
            self.view.endEditing(true)
            print("hurray you've just logged in!")
            sender.viewModel.confirmButtonTitle = "Logged in!"
            sender.fadeOut()
            self.logoView.startAnimation(withDelay: 1)
         } else {
            sender.shake(times: 3, orientation: .horizontal)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
            sender.viewModel.confirmButtonTitle = "Log in"
         }
   }
   
   func configureThemeButton(_ button: UIButton, title: String) {
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle(title, for: .normal)
      button.addTarget(self, action: #selector(themeButtonPressed), for: .touchUpInside)
      backgroundView.addSubview(button)
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   @objc func themeButtonPressed(sender: UIButton) {
      if sender == themeBasicButton {
         ThemeManager.apply(theme: .basic)
      } else if sender == themeBasicRoundedButton {
         ThemeManager.apply(theme: .basicRounded)
      } else if sender == themeHappyButton {
         ThemeManager.apply(theme: .happy)
      } else if sender == themeCalmButton {
         ThemeManager.apply(theme: .calm)
      }
   }
   
   @objc func goFurtherButtonPressed(sender: UIButton) {
      navigator.to(scene: .flashcards)
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}


