

import UIKit
import KeychainAccess

class AuthViewController: UIViewController {
    
  let keyChain = Keychain()
    
    var isUserAuthorised: Bool = true {
        willSet {
            if newValue {
                label.text = "Регистрация"
                enterButton.setTitle("Зарегистрироваться", for: .normal)
                passTxtField.placeholder = "Задайте пароль"
                pereatPasswordTxt.isHidden = false
                pereatPasswordTxt.text = "Создайте пароль не менее 5 символов"
                passTxtField.layer.borderColor = UIColor.red.cgColor
                txtOr.isHidden = true
                registerButton.isHidden = true
            }
        }
    }
    
    lazy var label: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .systemGray6
        lbl.text = "Вход"
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var passTxtField: UITextField = {
        let txt = UITextField()
       txt.backgroundColor = .white
        txt.layer.borderWidth = 0.5
       txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.placeholder = "Введите пароль"
        txt.font = UIFont.systemFont(ofSize: 15)
        txt.layer.cornerRadius = 10
        txt.clearButtonMode = UITextField.ViewMode.whileEditing
       txt.isSecureTextEntry = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.keyboardType = UIKeyboardType.default
        return txt
    }()
    
    lazy var enterButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.setTitle("Войти", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var txtOr: UILabel = {
       let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = "Нет аккаунта?"
        txt.font = UIFont.systemFont(ofSize: 12)
        txt.backgroundColor = .systemGray6
        return txt
    }()
    
    
    lazy var registerButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.setTitle("Зарегистрироваться", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(registerButtonPressed), for: .allTouchEvents)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var pereatPasswordTxt: UILabel = {
       let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = "Повторите пароль"
        txt.font = UIFont.systemFont(ofSize: 13)
        txt.backgroundColor = .systemGray6
        
        return txt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.view.addSubview(label)
        self.view.addSubview(passTxtField)
        self.view.addSubview(enterButton)
        self.view.addSubview(registerButton)
       self.view.addSubview(txtOr)
        self.view.addSubview(pereatPasswordTxt)
        setConstraints()
        self.pereatPasswordTxt.isHidden = true
       
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            label.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: passTxtField.topAnchor, constant: -40),
            label.widthAnchor.constraint(equalToConstant: 150),
            label.heightAnchor.constraint(equalToConstant: 40),
        
            passTxtField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passTxtField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -40),
            passTxtField.widthAnchor.constraint(equalToConstant: 250),
            passTxtField.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: passTxtField.bottomAnchor, constant: 20),
            enterButton.widthAnchor.constraint(equalToConstant: 250),
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            
            txtOr.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            txtOr.topAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 10),
            txtOr.widthAnchor.constraint(equalToConstant: 100),
            txtOr.heightAnchor.constraint(equalToConstant: 10),
            
            registerButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: txtOr.bottomAnchor, constant: 10),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            pereatPasswordTxt.leadingAnchor.constraint(equalTo: passTxtField.leadingAnchor),
            pereatPasswordTxt.bottomAnchor.constraint(equalTo: passTxtField.topAnchor, constant: -9),
            pereatPasswordTxt.heightAnchor.constraint(equalToConstant: 15),
            pereatPasswordTxt.widthAnchor.constraint(equalToConstant: 350)
       
        ])
    }
    
    @objc func enterButtonPressed() {
        if isUserAuthorised{                    //зарег
            registerButton.isHidden = true
            txtOr.isHidden = true
            checkUserAuthorisation()
        } else {                                // незарег
            registerUser()
            }
        }

  @objc  func registerButtonPressed() {
      isUserAuthorised = !isUserAuthorised
      isUserAuthorised = false
      print(isUserAuthorised)
      //registerUser()
      
        }

    func registerUser() {
        let pass = passTxtField.text!
        if !pass.isEmpty && pass.count >= 5 {
            let keychain: Keychain
            if let service = passTxtField.text, !service.isEmpty {
                keychain = Keychain(service: service)
            } else {
                keychain = Keychain()
            }
            keychain[passTxtField.text!] = passTxtField.text
            print("Keychain =\(keychain)")
            self.pereatPasswordTxt.text = "Необходимо повторить пароль"
            repeatPassEnter()
        } else {
            showAlertEmptyTxtField()
        }
    }
    
    func checkUserAuthorisation() {
        
        let pass = passTxtField.text!
        if !pass.isEmpty {
            let keychain: Keychain
            if let service = passTxtField.text, !service.isEmpty {
                keychain = Keychain(service: service)
            } else {
                keychain = Keychain()
            }
            if keychain.allKeys().contains(pass) {
                self.dismiss(animated: true)
                let vc = TabBar()
                present(vc, animated: true, completion: nil)
                    print("USER AUTHORISED")
                
            } else {
                showAlert()
                passTxtField.text = ""
                registerButtonPressed()
            }
        } else {
            self.showAlertEmptyTxtField()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Такой пользователь не зарегистрирован ", message: "Необходимо зарегистрироваться", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: { [self] in
                                            registerButtonPressed()
                })
    }
    
    
    func showAlertEmptyTxtField() {
        let alert = UIAlertController(title: "Пароль должен быть не менее 5 символов ", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertNotMatchedPasswords() {
        let alert = UIAlertController(title: "Пароли не совпадают. Попробуйте еще раз ", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccessReg() {
        let alert = UIAlertController(title: "Вы успешно зарегистрированы", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            print("CLOSURE")
            let vc = TabBar()
            self.present(vc, animated: true) }
            )
        )
        
        present(alert, animated: true)
    }
    
    func repeatPassEnter() {
        let alert = UIAlertController(title: "Повторите пароль", message: nil , preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Пароль не менее 5 символов"
            textField.isSecureTextEntry = true
        })
        alert.addAction (UIAlertAction(title: "OK", style: .default) { _ in
            let textField = alert.textFields![0]
            let pass = textField.text!
            if !pass.isEmpty {
                let keychain: Keychain
                if let service = textField.text, !service.isEmpty {
                    keychain = Keychain(service: service)
                } else {
                    keychain = Keychain()
                }
                if keychain.allKeys().contains(pass) {
                   let vc = TabBar()
                    self.present(vc, animated: true)
                } else {
                    self.showAlertNotMatchedPasswords()
                }
            } else {
                self.showAlertEmptyTxtField()
            }
         
            
        })
        present(alert, animated: true, completion: nil)
        }
    }

