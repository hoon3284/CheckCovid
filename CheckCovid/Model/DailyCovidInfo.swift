//
//  DailyCovidInfo.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/30.
//

import Foundation

class DailyCovidInfo {
    var dailyInfos: [String: CovidInfo]
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
    
    static var dailyTotalInfo: CovidInfo? {
        set {
            let data = try? JSONEncoder().encode(newValue)
            
            UserDefaults.shared.setValue(data, forKey: "DailyTotal")
        }
        
        get {
            guard let data = UserDefaults.shared.value(forKey: "DailyTotal") as? Data,
                  let totalInfo = try? JSONDecoder().decode(CovidInfo.self, from: data)
            else {
                return nil
            }
            return totalInfo
        }
    }
    
    init(dailyInfos items: [CovidInfo]) {
        dailyInfos = [:]
        for gubunEn in CovidInfoCategory.allCases {
            for item in items {
                if item.gubunEn == gubunEn.rawValue {
                    dailyInfos[gubunEn.rawValue] = item
                }
            }
        }
    }
    
}
