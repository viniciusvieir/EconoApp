//
//  WorldBankAPI.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//https://datahelpdesk.worldbank.org/knowledgebase/articles/898581-api-basic-call-structure

struct WorldBankAPI {
    
    let baseURL = "http://api.worldbank.org/countries/#COUNTRY#/indicators/#INDICATOR#?MRV=#NUMBEROFITEMS#&format=json"
    
    enum WorldBankIndicator: String {
        case gdp = "NY.GDP.MKTP.CD"
        case gdpGrowth = "NY.GDP.MKTP.KD.ZG"
        case gdpPerCapita = "NY.GDP.PCAP.CD"
        case unemployment = "SL.UEM.TOTL.ZS"
        case internationalReserves = "FI.RES.TOTL.CD"
        case expenses = "GC.XPN.TOTL.GD.ZS"
        case inflationGDPDeflator = "NY.GDP.DEFL.KD.ZG"
        case inflationConsumerPrice = "FP.CPI.TOTL.ZG"
        case depositInterestRate = "FR.INR.DPST"
    }
    
    @discardableResult
    init(indicator: WorldBankIndicator, numberOfItems: Int = 40, completion: @escaping (JSON?)->()) {
        
        let isoCountry = currentCountryCode ?? "br"
        
        let urlString = baseURL.replacingOccurrences(of: "#COUNTRY#", with: isoCountry).replacingOccurrences(of: "#NUMBEROFITEMS#", with: "\(numberOfItems)").replacingOccurrences(of: "#INDICATOR#", with: indicator.rawValue)
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            guard let jsonResponse = response.result.value else {
                completion(nil)
                return
            }
            let json = JSON(jsonResponse)
            completion(json)
        }
        
    }
    
    static func arrayFrom(json: JSON) -> [GenericInfo] {
        var genericArray = [GenericInfo]()
        for (_, subJson) in json {
            if let info = WorldBankAPI.genericValue(json: subJson) {
                genericArray.append(info)
            }
        }
        return genericArray
    }
    
    static func genericValue(json: JSON) -> GenericInfo? {
        if let date = json["date"].string, let valueString = json["value"].string, let value = Double(valueString) {
            return GenericInfo(date: date, value: value)
        }
        return nil
    }
    
}
