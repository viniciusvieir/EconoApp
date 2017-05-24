//
//  HTMLReaper.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation

class HTMLReaper: AnyObject {
    
    class func getSELIC( completion: ([SELIC]?) -> () ) {
        
        let urlString = "https://www.bcb.gov.br/Pec/Copom/Port/taxaSelic.asp"
        guard let url = URL(string: urlString) else { return completion(nil) }
        
        do {
            let htmlString = try String(contentsOf: url, encoding: .ascii)
            
            guard let inicio = htmlString.components(separatedBy: "<!--/Cabe&ccedil;alho Fim -->").last, let fim = inicio.components(separatedBy: "</table><br>").first else { return }
            
            let tableData = fim.components(separatedBy: "<tr class=").dropFirst()
            
            var selic = [SELIC]()
            for item in tableData {
                let selicPeriodo = SELIC(htmlString: item)
                selic.append(selicPeriodo)
            }
            completion(selic)
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
        
    }
    
}
