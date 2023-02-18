//
//  ChangePasswordViewController.swift
//  Image picker and saving
//
//  Created by Mac on 11.02.2023.
//

import UIKit
import KeychainAccess

class ChangePasswordViewController: UIViewController {
    
    lazy var labelTxt: UILabel = {
       let txt = UILabel()
        txt.backgroundColor = .white
        txt.text = "Задайте новый пароль"
        txt.font = UIFont.systemFont(ofSize: 15)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    lazy var passTextfield: UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.layer.borderWidth = 0.5
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.placeholder = "Введите пароль"
        txtField.font = UIFont.systemFont(ofSize: 14)
        txtField.layer.cornerRadius = 10
        txtField.clearButtonMode = UITextField.ViewMode.whileEditing
        txtField.isSecureTextEntry = true
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.keyboardType = UIKeyboardType.default
        return txtField
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.setTitle("Сохранить", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(changePassButtonPressed), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(labelTxt)
        view.addSubview(passTextfield)
        view.addSubview(button)
        setConstraints()
    }
    
    func setConstraints() {
        let safearea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            labelTxt.centerXAnchor.constraint(equalTo: safearea.centerXAnchor),
            labelTxt.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 200),
            labelTxt.heightAnchor.constraint(equalToConstant: 40),
            labelTxt.widthAnchor.constraint(equalToConstant: 200),
            
            passTextfield.centerXAnchor.constraint(equalTo: safearea.centerXAnchor),
            passTextfield.topAnchor.constraint(equalTo: labelTxt.bottomAnchor, constant: 20),
            passTextfield.widthAnchor.constraint(equalToConstant: 300),
            passTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: safearea.centerXAnchor),
            button.topAnchor.constraint(equalTo: passTextfield.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    @objc func changePassButtonPressed() {
        let newPass = passTextfield.text!
        if !newPass.isEmpty && newPass.count >= 5 {
            let keychain = Keychain(service: newPass)
            keychain["password"] = newPass
        } else {
            showAlertEmptyTxtField()
        }
    }
    
    func showAlertEmptyTxtField() {
        let alert = UIAlertController(title: "Пароль должен быть не менее 5 символов", message: nil, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
