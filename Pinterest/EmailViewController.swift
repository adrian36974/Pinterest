//
//  EmailViewController.swift
//  Pinterest
//
//  Created by Adrian Alejandro Sandoval Perez on /7/19.
//  Copyright © 2019 Adrian Alejandro Sandoval Perez. All rights reserved.
//

import UIKit
import Firebase
import SwiftyGif

class EmailViewController: UIViewController {
    
    enum Register {
        case email
        case password
        case age
    }
    
    var register : Register?
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titulo del UIView
        self.navigationItem.title = "Regístrate"
        
        //Titulo para el boton de retroceder
        let backButton = UIBarButtonItem()
        backButton.title = "Atras"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        view.backgroundColor = .white
        
        //add subview
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(label)
        inputContainerView.addSubview(emailTextField)
        view.addSubview(nextButton)
        
        
        //constraints
        // constraints for input
        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        
        label.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        //label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        //emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        nextButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/14).isActive = true
        
    }
    
    lazy var label : UILabel = {
        let lb = UILabel()
        if let registerVal = register {
            switch registerVal {
            case .email:
                lb.text = "¿Cual es tu correo electrónico?"
            case .password:
                lb.text = "Crea tu contraseña"
            case .age:
                lb.text = "¿Cual es tu edad?"
            }}
        //lb.font =  UIFont(name: "GillSans-SemiBold", size: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    lazy var emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        if let registerVal = register {
            switch registerVal {
            case .email:
                tf.placeholder = "Correo"
            case .password:
                tf.placeholder = "Contraseña"
                tf.isSecureTextEntry = true
            case .age:
                tf.placeholder = "Edad"
            }}
        tf.font =  UIFont(name: "GillSans-SemiBold", size: 35)
        tf.backgroundColor = .white
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    let inputContainerView : UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var nextButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(r: 201, g: 34, b: 40)
        if let registerVal = register {
            switch registerVal {
            case .email:
                ub.setTitle("Siguiente", for: .normal)
            case .password:
                ub.setTitle("Siguiente", for: .normal)
            case .age:
                ub.setTitle("Registrarse", for: .normal)
            }}
        ub.titleLabel?.font =  UIFont(name: "GillSans-SemiBold", size: 18)
        ub.layer.cornerRadius = 20
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    @objc func handleButton(){
        print("Hola mundo")

        if let registerVal = register {
            switch registerVal {
            case .email:
                let user = User()
                user.email = emailTextField.text
                let email = EmailViewController()
                email.register = .password
                email.user = user
                self.navigationController?.pushViewController(email, animated: true)
            case .password:
                let email = EmailViewController()
                if let userInstance = user {
                    userInstance.password = emailTextField.text
                    email.user = userInstance
                }
                email.register = .age
                self.navigationController?.pushViewController(email, animated: true)
            case .age:
                if let userInstance = user {
                    userInstance.age = emailTextField.text
                    if let email = userInstance.email, let pass = userInstance.password, let age = userInstance.age{
                        print(email)
                        print(pass)
                        Auth.auth().createUser(withEmail: email, password: pass) { (data:AuthDataResult?, error) in
                            let user = data?.user
                            if error != nil {
                                print(error.debugDescription)
                            }
                            
                            //succesful
                            let ref = Database.database().reference(fromURL: "https://pinterest-tecmi.firebaseio.com/")
                            
                            if let uid = user?.uid{
                                
                                let usersRef = ref.child("users").child(uid)
                                usersRef.updateChildValues(["email" : email, "password": pass, "age" : age])
                                
                                //Aqui se crea
                                let msgsRef = ref.child("message").child(uid)
                                msgsRef.updateChildValues(["message" : "Prueba"])
                                
                                //Aqui se borra el child uid de message, el de "Prueba"
                                ref.child("message").child(uid).removeValue()
                                
                            }
                        }
                    }
                }
            }}
    }
}
