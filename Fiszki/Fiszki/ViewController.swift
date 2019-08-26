//
//  ViewController.swift
//  Fiszki
//
//  Created by Mateusz Małek on 10.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import UIControlBinder
import Arithmos
import AudioToolbox
import Visuals
import FlashcardLogoView

func prettyPrint(with json: [String:Any]) -> String{
    let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    return string! as String
}

class ViewController: UIViewController {
    
    private let themeBasicButton = SmallStandardButton()
    private let themeBasicRoundedButton = SmallStandardButton()
    private let themeHappyButton = SmallStandardButton()
    private let themeCalmButton = SmallStandardButton()
    private let backgroundView = BackgroundView()
    private let logoView = FlashcardLogoView()
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    func configureThemeButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(themeButtonPressed), for: .touchUpInside)
        backgroundView.addSubview(button)
    }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false

        ThemeManager.loadAll()
        
        configureThemeButton(themeBasicButton, title: "Basic")
        configureThemeButton(themeBasicRoundedButton, title: "BasicRounded")
        configureThemeButton(themeHappyButton, title: "Happy")
        configureThemeButton(themeCalmButton, title: "Calm")

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
         self.view.endEditing(true)
        //shake baby
        if sender.viewModel.login.value?.lowercased() == "login" && sender.viewModel.password.value?.lowercased() == "pass" {
            print("hurray you've just logged in!")
            sender.viewModel.confirmButtonTitle = "Logged in!"
            sender.fadeOut()
            logoView.startAnimation()

        } else {
            sender.shake(times: 3, orientation: .horizontal)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
            sender.viewModel.confirmButtonTitle = "Log in"
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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

