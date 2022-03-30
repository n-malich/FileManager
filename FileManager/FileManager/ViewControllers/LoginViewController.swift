//
//  LoginViewController.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    private var alert : UIAlertController?
    
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
            self?.login()
        })
        button.alpha = 0.7
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupHideKeyboardOnTap()
        
        if (UserDefaults.standard.object(forKey: "Password") != nil) == true {
            self.loginButton.setTitle("Enter password", for: .normal)
        } else {
            self.loginButton.setTitle("Create a password", for: .normal)
        }
        
        if ((UserDefaults.standard.object(forKey: "ChangePass")) != nil) == true {
            self.isModalInPresentation = true
            self.loginButton.setTitle("Save new password", for: .normal)
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
    private func login() {
        guard let password = self.passwordTextField.text else { return }
        
        if (UserDefaults.standard.object(forKey: "Password") != nil) == true {
                LoginInspector.shared.signIn(password: password) { result in
                    if result {
                        self.delegate?.navigateToMainVC()
                    } else {
                        self.showErrorAlert(message: "Wrong password")
                    }
                }
        } else {
            if !password.isEmpty, password.count >= 6 {
                LoginInspector.shared.signUp(password: password) {
                    self.delegate?.navigateToMainVC()
                }
            } else if !password.isEmpty, password.count < 6 {
                self.showErrorAlert(message: "Password must be at least 6 characters")
            } else if password.isEmpty {
                self.showErrorAlert(message: "Enter password")
            }
        }
                                         
        if ((UserDefaults.standard.object(forKey: "ChangePass")) != nil) == true {
            self.dismiss(animated: true, completion: {
                UserDefaults.standard.removeObject(forKey: "ChangePass")
            })
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
    @objc private func firstNameTextFieldDidChanged() {
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
