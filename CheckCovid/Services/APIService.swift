//
//  APIService.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/23.
//

import Foundation

struct DailyInfoRequest: APIRequest {
    typealias Response = [CovidInfo]
    
    var queryItems: [URLQueryItem] {
        let today = CovidInfoParser.shared.queryDateFormatter.string(from: Date()-1800)
        return [
            "serviceKey": Bundle.main.apiKey,
            "pageNo": "1",
            "numOfRows": "10",
            "startCreateDt": today,
            "endCreateDt": today
        ].map { URLQueryItem(name: $0, value: $1)}
    }
}
