//
//  UIViewController+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_button").changeColor(to: UIColor.white), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    func addRefreshButton(style: UIActivityIndicatorViewStyle) -> UIActivityIndicatorView {
        var ai = UIActivityIndicatorView()
        ai = UIActivityIndicatorView(activityIndicatorStyle: style)
        ai.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ai)
        return ai
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
