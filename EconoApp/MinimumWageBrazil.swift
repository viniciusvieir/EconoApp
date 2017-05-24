//
//  MinimumWageBrazil.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation

//http://www.dieese.org.br/analisecestabasica/salarioMinimo.html#2016

struct MinimumWageBrazil {
    
    struct AnnualMinimumWage {
        var month: String?
        var minimumWage: String?
        var minimumWageNeeded: String?
    }
    
    init(completion: ([String: [AnnualMinimumWage]]?) -> ()) {
        
        let urlString = "http://www.dieese.org.br/analisecestabasica/salarioMinimo.html"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        do {
            let htmlString = try String(contentsOf: url, encoding: .ascii)
            completion(manageHTMLString(htmlString: htmlString))
        } catch let error {
            completion(nil)
            print(error.localizedDescription)
        }
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



















