//
//  DailyCovidInfo.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/30.
//

import Foundation

class DailyCovidInfo {
    var dailyInfos: [CovidInfo]
    var dailyInfoDict = [String: CovidInfo]()
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
    
    static var dailyTotalInfo: CovidInfo? {
        set {
            guard newValue != nil else { return }
            
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
        dailyInfos = items
        
        for item in items {
            if let category = CovidInfoCategory(rawValue: item.gubunEn) {
                dailyInfoDict[category.rawValue] = item
            }
        }
    }
    
}
