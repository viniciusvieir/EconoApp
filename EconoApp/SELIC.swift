//
//  SELIC.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation

struct SELIC {
    
    var data: String?
    var vigencia: String?
    var meta: String?
    var taxaMensal: String?
    var taxaAnual: String?
    
    init(htmlString: String) {
        let itemArray = htmlString.components(separatedBy: "<TD")
        data = itemArray[2].components(separatedBy: "<").first?.components(separatedBy: ">").last
        vigencia = itemArray[4].components(separatedBy: "<").first?.components(separatedBy: ">").last
        meta = itemArray[5].components(separatedBy: "<").first?.components(separatedBy: ">").last
        taxaMensal = itemArray[7].components(separatedBy: "\r\n\t  <").first?.components(separatedBy: ">\r\n\t  ").last
        taxaAnual = itemArray[8].components(separatedBy: ">\r\n\t  ").last?.components(separatedBy: "\r\n\r\n\t").first
    }
    
}

