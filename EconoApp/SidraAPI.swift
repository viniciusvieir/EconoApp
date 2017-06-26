//
//  SidraAPI.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//http://api.sidra.ibge.gov.br/home/ajuda

struct InflationData {
    let date: String
    let monthVariation: Double
    let yearAccumulation: Double
    let last12MonthAccumulation: Double
}

class SidraAPI: AnyObject {
    
    enum InflationTableIndex: String {
        case ipca = "t/1419"
        case inpc = "t/1100"
        case ipca15 = "t/1705"
    }
    
    static let urlString = "http://api.sidra.ibge.gov.br/values"
    
    @discardableResult
    init(tableIndex: InflationTableIndex, dates: [Date], completion: @escaping (JSON?)->()) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        
        let regiao = "n1/all"
        let periodo = dates.map { dateFormatter.string(from: $0) }.joined(separator: ",")
        
        let completeUrlString = "\(SidraAPI.urlString)/\(tableIndex.rawValue)/\(regiao)/p/\(periodo)"
        
        guard let url = URL(string: completeUrlString) else {
            completion(nil)
            return
        }
        Alamofire.request(url).responseJSON { (response) in
            guard let jsonResponse = response.result.value else {
                completion(nil)
                return
            }
            completion(JSON(jsonResponse))
        }
    }
    
    static func arrayFrom(json: JSON) -> [InflationData] {
        var inflationArray = [InflationData]()
        for i in 0 ... (json.count)/4 {
            if let date = json[i*4+1]["D2N"].string, let monthVariation = json[i*4+1]["V"].string, let yearAccumulation = json[i*4+2]["V"].string, let last12monthAccumulation = json[i*4+3]["V"].string {
                let inflationData = InflationData(date: date, monthVariation: Double(monthVariation) ?? 0.0, yearAccumulation: Double(yearAccumulation) ?? 0.0, last12MonthAccumulation: Double(last12monthAccumulation) ?? 0.0)
                inflationArray.append(inflationData)
            }
        }
        return inflationArray
    }
    
}
