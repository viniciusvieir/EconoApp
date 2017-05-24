//
//  TesteViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

class TesteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let closeButton = self.addCloseButton()
        _ = closeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    
    
    
    
    
}
