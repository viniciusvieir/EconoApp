//
//  ActivityProgressLabel.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 25/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

class ActivityProgressLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, color: UIColor = UIColor.white) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = color
        
        font = UIFont.init(name: "HoeflerText-BlackItalic", size: 44)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func startAnimating() {
        UIView.animate(withDuration: 0.8, animations: {
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }) { (success) in
            UIView.animate(withDuration: 0.8, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (success) in
                self.startAnimating()
            })
        }
    }
    
    public func stopAnimating(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: { 
            self.alpha = 0
        }) { (success) in
            self.layer.removeAllAnimations()
            completion()
        }
    }
    
    public func restartAnimating(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: { 
            self.alpha = 1
        }) { (success) in
            completion()
        }
    }
    
}
