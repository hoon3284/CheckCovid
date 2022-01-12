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
        let today = CovidInfoParser.queryDateFormatter.string(from: Date()-3900)

        return [
            "serviceKey": Bundle.main.apiKey,
            "pageNo": "1",
            "numOfRows": "10",
            "startCreateDt": today,
            "endCreateDt": today
        ].map { URLQueryItem(name: $0, value: $1)}
    }
}

struct WeeklyTotalInfoRequest: APIRequest {
    typealias Response = [String: [CovidInfo]]

    var queryItems: [URLQueryItem] {
        let today = Date()-3900
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!

        return [
            "serviceKey": Bundle.main.apiKey,
            "pageNo": "1",
            "numOfRows": "10",
            "startCreateDt": CovidInfoParser.queryDateFormatter.string(from: aWeekAgo),
            "endCreateDt": CovidInfoParser.queryDateFormatter.string(from: today)
        ].map { URLQueryItem(name: $0, value: $1) }
    }
}
