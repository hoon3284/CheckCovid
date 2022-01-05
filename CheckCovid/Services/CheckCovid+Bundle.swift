//
//  CovidWidget+Bundle.swift
//  CovidWidget
//
//  Created by wickedRun on 2021/12/17.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "CovidInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String
        else {
            fatalError("CovidInfo.plist에 API_KEY 값을 넣어주세요.")
        }
        
        return key
    }
}
