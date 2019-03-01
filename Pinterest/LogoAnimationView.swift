//
//  LogoAnimationView.swift
//  Pinterest
//
//  Created by Adrian Alejandro Sandoval Perez on 3/1/19.
//  Copyright © 2019 Adrian Alejandro Sandoval Perez. All rights reserved.
//
import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    let logoGifImageView = UIImageView(gifImage: UIImage(gifName: "pin"), loopCount: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 9).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
    }
}
