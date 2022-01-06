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
        // 9:43분 경 아직 6일 데이터가 갱신되지 않았음.
        // 그렇지만 에러가 나지 않고 빈 데이터를 보냄 resultCode 00 resultMsg NORMAL SERVICE
        // 그래서 빈 [CovidInfo] 배열을 받기때문에
        // DailyCovidInfo 생성자에서는 괜찮지만 total 값을 가져올때 nil이기 때문에 문제가 생김.
        // 그래서 앱이 튕김
        // 10:05분경 데이터 들어옴.
        return [
            "serviceKey": Bundle.main.apiKey,
            "pageNo": "1",
            "numOfRows": "10",
            "startCreateDt": today,
            "endCreateDt": today
        ].map { URLQueryItem(name: $0, value: $1)}
    }
}
