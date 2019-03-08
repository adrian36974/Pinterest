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
        
        
        //constraints
        // constraints for input
        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        
        label.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        
        emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
    }
    
    let label : UILabel = {
        let lb = UILabel()
        lb.text = "¿Cual es tu correo electrónico?"
        //lb.font =  UIFont(name: "GillSans-SemiBold", size: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Correo"
        tf.font =  UIFont(name: "GillSans-SemiBold", size: 28)
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
    
    let firstButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor =  UIColor(r: 235, g: 101, b: 90)
        ub.setTitle("Registrarse", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        //ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
}
