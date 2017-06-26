//
//  UIColor+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    convenience init(netHex:Int) {
        let components = (
            R: CGFloat((netHex >> 16) & 0xff) / 255,
            G: CGFloat((netHex >> 08) & 0xff) / 255,
            B: CGFloat((netHex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black
    }
    
    var brickRed: UIColor {                         // RED
        return UIColor(r: 195, g: 60, b: 84)
    }
    
    var sunsetOrange: UIColor {                     // ORANGE
        return UIColor(r: 251, g: 101, b: 66)
    }
    
    var stilDeGrainYellow: UIColor {                // YELLOW
        return UIColor(r: 49, g: 63, b: 98)
    }
    
    var darkSlateGray: UIColor {                    // BLUE
        return UIColor(r: 37, g: 78, b: 112)
    }
    
    var darkCerulean: UIColor {                     // BLUE
        return UIColor(r: 18, g: 78, b: 120)
    }
    
    var darkSkyBlue: UIColor {                      // BLUE
        return UIColor(r: 149, g: 184, b: 209)
    }
    
    var verdeAzulado: UIColor {
        return UIColor(r: 38, g: 197, b: 193)
    }
    
    var laurelGreen: UIColor {                      // GREEN
        return UIColor(r: 168, g: 198, b: 134)
    }
    
    var shinnyShamrock: UIColor {                      // GREEN
        return UIColor(r: 98, g: 168, b: 124)
    }
    
    var ivoryWhite: UIColor {                       // WHITE
        return UIColor(r: 255, g: 255, b: 242)
    }
    
    var roseTaupe: UIColor {                        // BROWN
        return UIColor(r: 136, g: 90, b: 90)
    }
    
    
}
