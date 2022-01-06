//
//  APIError.swift
//  CheckCovid
//
//  Created by wickedRun on 2022/01/05.
//

import Foundation

enum APIError: String, Error {
    case normalServiceButNoData = "00"                // 정상 서비스이지만 데이타가 없을때.
    case application = "01"                           // 어플리케이션
    case db = "02"                                    // 데이터베이스
    case noData = "03"                                // 데이터 없음
    case http = "04"                                  // HTTP
    case serviceTimeout = "05"                        // 서비스 연결실패
    case invalidRequestParameter = "10"               // 잘못된 요청 파라메터
    case noMandatoryRequestParameters = "11"          // 필수요청 파라메터가 없음
    case noOpenAPIService = "12"                      // 해당 오픈 API서비스가 없거나 폐기됨
    case serviceAccessDenied = "20"                   // 서비스 접근 거부
    case temporarilyDisableTheServiceKey = "21"       // 일시적으로 사용할 수 없는 서비스 키
    case limitedNumberOfServiceRequestsExceeds = "22" // 서비스 요청제한횟수 초과
    case serviceKeyIsNotRegistered = "30"             // 등록되지 않은 서비스키
    case deadlineHasExpired = "31"                    // 기한만료된 서비스키
    case unregisteredIP = "32"                        // 등록되지 않은 IP
    case unsignedCall = "33"                          // 서명되지 않은 호출
    case unknown = "99"                               // 기타
    
    var name: String {
        return String(describing: self)
    }
}
