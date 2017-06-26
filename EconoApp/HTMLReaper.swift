//
//  HTMLReaper.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation
import Alamofire

class HTMLReaper: AnyObject {
    
    class func getSELIC(completion: @escaping ([SELIC]?) -> () ) {
        
        let urlString = "https://www.bcb.gov.br/Pec/Copom/Port/taxaSelic.asp"
        guard let url = URL(string: urlString) else { return completion(nil) }
        
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let data = data {
                    let htmlString = String(data: data, encoding: .ascii)
                    guard let inicio = htmlString?.components(separatedBy: "<!--/Cabe&ccedil;alho Fim -->").last, let fim = inicio.components(separatedBy: "</table><br>").first else { return }
                    
                    let tableData = fim.components(separatedBy: "<tr class=").dropFirst()
                    
                    var selic = [SELIC]()
                    for item in tableData {
                        let selicPeriodo = SELIC(htmlString: item)
                        selic.append(selicPeriodo)
                    }
                    completion(selic)
                } else {
                    completion(nil)
                }
            }
            
        }.resume()
        
    }
    
}
