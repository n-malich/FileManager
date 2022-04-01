//
//  LoginViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

enum ModeLoginScreen {
    case signIn
    case signUp
    case changePass
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    private var alert : UIAlertController?
    private let mode: ModeLoginScreen
    
    private var firstPass: String?
    private var secondPass: String?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Password")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.clipsToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(title: nil, titleColor: .white, backgroundColor: .systemBlue, backgroundImage: nil, buttonAction: { [weak self] in

            switch self?.mode {
            case .signUp:
                self?.signUp()
            case .signIn:
                self?.signIn()
            case .changePass:
                self?.signUp()
            case .none:
                break
            }
        })
        button.alpha = 0.7
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    init(mode: ModeLoginScreen) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupHideKeyboardOnTap()
        
        switch self.mode {
        case .signUp:
            self.loginButton.setTitle("Create password", for: .normal)
        case .signIn:
            self.loginButton.setTitle("Enter password", for: .normal)
        case .changePass:
            self.loginButton.setTitle("Save new password", for: .normal)
            self.isModalInPresentation = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        passwordTextField.text = .none
    }
        
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
        
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension LoginViewController {
        private func setupViews() {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            [logoImageView, passwordTextField, loginButton].forEach { contentView.addSubview($0)}
        }
    }

extension LoginViewController {
    private func setupConstraints() {
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}

extension LoginViewController {
    @objc private func signIn() {
        guard let password = self.passwordTextField.text else { return }
        LoginInspector.shared.signIn(password: password) { result in
            if result {
                self.delegate?.navigateToMainVC()
            } else {
                self.showErrorAlert(message: "Wrong password")
            }
        }
    }
    
    @objc private func signUp() {
        guard let password = self.passwordTextField.text else { return }
        if !password.isEmpty, password.count >= 6 {
            let pass = UserDefaults.standard.bool(forKey: "Pass")
            // логика первого ввода пароля
            if pass == false {
                firstPass = passwordTextField.text
                DispatchQueue.main.async {
                    self.loginButton.setTitle("Confirm password", for: .normal)
                    self.passwordTextField.text = ""
                    UserDefaults.standard.set(true, forKey: "Pass")
                }
                print("First password \(String(describing: firstPass))")
                // логика второго ввода пароля
            } else {
                secondPass = passwordTextField.text
                print("Second password \(String(describing: secondPass))")
                if firstPass == secondPass {
                    
                    UserDefaults.standard.removeObject(forKey: "Pass")
                    LoginInspector.shared.signUp(password: password) {
                        self.delegate?.navigateToMainVC()
                        if ((UserDefaults.standard.object(forKey: "ChangePass")) != nil) == true {
                            self.dismiss(animated: true, completion: {
                                UserDefaults.standard.removeObject(forKey: "ChangePass")})
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if ((UserDefaults.standard.object(forKey: "ChangePass")) != nil) == true {
                            self.loginButton.setTitle("Save new password", for: .normal)
                            self.passwordTextField.text = ""
                        } else {
                            self.loginButton.setTitle("Create password", for: .normal)
                            self.passwordTextField.text = ""
                        }
                    }
                    UserDefaults.standard.removeObject(forKey: "Pass")
                    self.showErrorAlert(message: "Passwords don't match")
                }
            }
        } else if !password.isEmpty, password.count < 6 {
            self.showErrorAlert(message: "Password must be at least 6 characters")
        } else if password.isEmpty {
            self.showErrorAlert(message: "Enter password")
        }
    }
}

extension LoginViewController {
    private func showErrorAlert(message: String) {
        alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert?.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert!, animated: true, completion: nil)
    }
}

extension LoginViewController {
    private func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

extension LoginViewController {
    @objc private func passwordTextFieldDidChanged() {
        guard let password = passwordTextField.text else { return }
        loginButton.isEnabled = !password.isEmpty ? true : false
        isModalInPresentation = !password.isEmpty ? true : false
    }
}

extension LoginViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }
}
