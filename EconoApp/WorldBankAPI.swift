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
    
    enum SearchIndex: String {
        case gdp = "http://api.worldbank.org/countries/br/indicators/NY.GDP.MKTP.CD?MRV=50&format=json"
        case gdpPerCapita = "http://api.worldbank.org/countries/br/indicators/NY.GDP.PCAP.CD?MRV=50&format=json"
        case unemployment = "http://api.worldbank.org/countries/br/indicators/SL.UEM.TOTL.ZS?MRV=50&format=json"
        case internationalReserves = "http://api.worldbank.org/countries/br/indicators/FI.RES.TOTL.CD?MRV=50&format=json"
        case expenses = "http://api.worldbank.org/countries/br/indicators/GC.XPN.TOTL.GD.ZS?MRV=50&format=json"
    }
    
    init(searchType: SearchIndex) {
        
        guard let url = URL(string: searchType.rawValue) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            guard let jsonResponse = response.result.value else {
                print("Response is nil")
                return
            }
            let json = JSON(jsonResponse)
//            print(JSON(jsonResponse))
            //completion(JSON(jsonResponse))
//            print(json)
            print(json)
            
        }
        
    }
    
}
