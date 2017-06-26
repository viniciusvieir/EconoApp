//
//  MinimumWageBrazil.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation

//http://www.dieese.org.br/analisecestabasica/salarioMinimo.html#2016

struct AnnualMinimumWage {
    var month: String?
    var minimumWage: String?
    var minimumWageNeeded: String?
}

struct MinimumWageBrazil {
    
    init() { }
    
    @discardableResult
    init(completion: @escaping ([String: [AnnualMinimumWage]]?) -> ()) {
        
        let urlString = "http://www.dieese.org.br/analisecestabasica/salarioMinimo.html"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let data = data {
                    if let htmlString = String(data: data, encoding: .ascii) {
                        completion(MinimumWageBrazil().manageHTMLString(htmlString: htmlString))
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            
        }.resume()
        
    }
    
    private func manageHTMLString(htmlString: String) -> [String: [AnnualMinimumWage]]? {
        
        guard let inicio = htmlString.components(separatedBy: "<tbody>").last, let fim = inicio.components(separatedBy: "</tbody>").first else {
            return nil
        }
        
        let tableInfoAnos = fim.components(separatedBy: "<tr class=\"subtitulo\">").dropFirst()
        
        var info = [String: [AnnualMinimumWage]]()
        
        for ano in tableInfoAnos {
            let year = ano.components(separatedBy: "NAME=\"").last?.substring(to: 4)
            let tableInfoMeses = ano.components(separatedBy: "<tr class=\"listra\">").dropFirst()
            for mes in tableInfoMeses {
                let month = mes.components(separatedBy: "<td>").dropFirst().first?.replacingOccurrences(of: "</td>", with: "")
                let minimumWage = mes.components(separatedBy: "<td>").dropFirst(2).first?.replacingOccurrences(of: "</td>", with: "")
                let minimumWageNeeded = mes.components(separatedBy: "<td>").dropFirst(3).first?.components(separatedBy: "</td>").first?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "  ", with: " ").replacingOccurrences(of: "\n", with: " ")
                
                if let _ = info[year!] {
                    info[year!]?.append(AnnualMinimumWage(month: month, minimumWage: minimumWage, minimumWageNeeded: minimumWageNeeded))
                } else {
                    info[year!] = [AnnualMinimumWage(month: month, minimumWage: minimumWage, minimumWageNeeded: minimumWageNeeded)]
                }
            }
        }
        return info
    }
    
    
}



















