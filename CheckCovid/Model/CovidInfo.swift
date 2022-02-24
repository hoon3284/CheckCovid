//
//  CovidInfo.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/17.
//

import Foundation

struct CovidInfo: CustomStringConvertible, Codable, Equatable {
    var seq: Int            // 게시글 번호
    var createDt: Date      // 등록일시분초
    var deathCnt: Int       // 사망자 수
    var gubun: String       // 구분 한글
    var gubunEn: String       // 구분 영어
    var incDec: Int         // 전일대비 증감 수
//    var isolClearCnt: Int   // 격리 해제 수
    var qurRate: Int?       // 10만명당 발생률
    var standardDay: Date   // 기준일시
    var defCnt: Int         // 확진자 수
    var overFlowCnt: Int    // 해외유입 수
    var localOccCnt: Int    // 지역발생 수
    
    var description: String {
        return "(\(gubun),\(gubunEn)) - 총 확진자: \(defCnt), 해외 유입 수: \(overFlowCnt), 지역 발생 수: \(localOccCnt), 사망자 수: \(deathCnt), 증감 수: \(incDec))"
    }
    
    static func == (_ lhs: CovidInfo, _ rhs: CovidInfo) -> Bool {
        return lhs.seq == rhs.seq
    }
}

enum CovidInfoCategory: String, CaseIterable {
    case lazaretto = "Lazaretto"
    case jeju = "Jeju"
    case gyeongsangnamdo = "Gyeongsangnam-do"
    case gyeongsangbukdo = "Gyeongsangbuk-do"
    case jeollanamdo = "Jeollanam-do"
    case jeollabukdo = "Jeollabuk-do"
    case chungcheoungnamdo = "Chungcheongnam-do"
    case chungcheoungbukdo = "Chungcheongbuk-do"
    case gangwondo = "Gangwon-do"
    case gyeonggido = "Gyeonggi-do"
    case sejong = "Sejong"
    case ulsan = "Ulsan"
    case daejeon = "Daejeon"
    case gwangju = "Gwangju"
    case incheon = "Incheon"
    case daegu = "Daegu"
    case busan = "Busan"
    case seoul = "Seoul"
    case total = "Total"
}
