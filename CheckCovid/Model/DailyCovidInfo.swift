//
//  DailyCovidInfo.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/30.
//

import Foundation

class DailyCovidInfo {
    var weeklyInfoDict: [String: [CovidInfo]]
    var dailyInfos: [CovidInfo]
    
    let dateFormatter = { () -> DateFormatter in
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
    
    init(with dict: [String: [CovidInfo]]) {
        weeklyInfoDict = dict
        dailyInfos = [CovidInfo]()
        
        let today = dateFormatter.string(from: Date()-3900)
        
        for key in CovidInfoCategory.allCases {
            if let infos = weeklyInfoDict[key.rawValue],
               let info = infos.first(where: { dateFormatter.string(from: $0.standardDay) == today }) {
                dailyInfos.append(info)
            }
        }
    }
    
}
