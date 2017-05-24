//
//  UIImage+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

extension UIImage {
    
    func changeColor(to color: UIColor) -> UIImage {
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let image = self.withRenderingMode(.alwaysTemplate)
        
        let rect = CGRect(origin: CGPoint.zero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        
        image.draw(in: rect)
        context!.setFillColor(red: r, green: g, blue: b, alpha: 1)
        context!.setBlendMode(CGBlendMode.sourceAtop)
        context!.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}
