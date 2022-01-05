//
//  CovidInfoParser.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/17.
//

import Foundation

class CovidInfoParser: NSObject, XMLParserDelegate {
    static let shared = CovidInfoParser()

    var resultCode = ""
    var resultMsg = ""
    var items: [CovidInfo] = []
    var xmlDictionary: [String: String]?
    var crtElementType: XMLKey?
    var createDateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    var standardDateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    var queryDateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            xmlDictionary = [:]
        case XMLKey.seq.rawValue:
            crtElementType = .seq
        case XMLKey.createDt.rawValue:
            crtElementType = .createDt
        case XMLKey.deathCnt.rawValue:
            crtElementType = .deathCnt
        case XMLKey.gubun.rawValue:
            crtElementType = .gubun
        case XMLKey.gubunEn.rawValue:
            crtElementType = .gubunEn
        case XMLKey.incDec.rawValue:
            crtElementType = .incDec
        case XMLKey.isolClearCnt.rawValue:
            crtElementType = .isolClearCnt
        case XMLKey.qurRate.rawValue:
            crtElementType = .qurRate
        case XMLKey.standardDay.rawValue:
            crtElementType = .standardDay
        case XMLKey.defCnt.rawValue:
            crtElementType = .defCnt
        case XMLKey.overFlowCnt.rawValue:
            crtElementType = .overFlowCnt
        case XMLKey.localOccCnt.rawValue:
            crtElementType = .localOccCnt
        case XMLKey.resultCode.rawValue:
            crtElementType = .resultCode
        case XMLKey.resultMsg.rawValue:
            crtElementType = .resultMsg
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let crtElementType = self.crtElementType else { return }
        
        if crtElementType == XMLKey.resultCode {
            resultCode = string
        } else if crtElementType == XMLKey.resultMsg {
            resultMsg = string
        }
        
        guard xmlDictionary != nil else { return }
        
        if crtElementType.rawValue == XMLKey.standardDay.rawValue {
            xmlDictionary?[crtElementType.rawValue, default: ""] += string
        } else {
            xmlDictionary?.updateValue(string, forKey: crtElementType.rawValue)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let xmlDictionary = self.xmlDictionary else { return }
        
        if elementName == "item" {
            guard let seq = xmlDictionary[XMLKey.seq.rawValue],
                  let createDt = xmlDictionary[XMLKey.createDt.rawValue],
                  let deathCnt = xmlDictionary[XMLKey.deathCnt.rawValue],
                  let gubun = xmlDictionary[XMLKey.gubun.rawValue],
                  let gubunEn = xmlDictionary[XMLKey.gubunEn.rawValue],
                  let incDec = xmlDictionary[XMLKey.incDec.rawValue],
                  let isolClearCnt = xmlDictionary[XMLKey.isolClearCnt.rawValue],
                  let qurRate = xmlDictionary[XMLKey.qurRate.rawValue],
                  let defCnt = xmlDictionary[XMLKey.defCnt.rawValue],
                  let standardDay = xmlDictionary[XMLKey.standardDay.rawValue],
                  let overFlowCnt = xmlDictionary[XMLKey.overFlowCnt.rawValue],
                  let localOccCnt = xmlDictionary[XMLKey.localOccCnt.rawValue]
            else {
                print("Dict nil")
                return
            }
            guard let createDate = createDateFormatter.date(from: createDt), let standardDate = standardDateFormatter.date(from: standardDay) else {
                print("failed to formatting date")
                return
            }
            let item = CovidInfo(seq: Int(seq)!, createDt: createDate, deathCnt: Int(deathCnt)!, gubun: gubun, gubunEn: gubunEn, incDec: Int(incDec)!, isolClearCnt: Int(isolClearCnt)!, qurRate: Int(qurRate), standardDay: standardDate, defCnt: Int(defCnt)!, overFlowCnt: Int(overFlowCnt)!, localOccCnt: Int(localOccCnt)!)
            items.append(item)
            self.xmlDictionary = nil
        }
        crtElementType = nil
    }
    
    enum XMLKey: String {
        case resultCode             // 결과 코드
        case resultMsg              // 결과 메세지
        case seq                    // 게시글 번호
        case createDt               // 등록일시분초
        case deathCnt               // 사망자 수
        case gubun                  // 구분 한글
        case gubunEn                // 구분 영어
        case incDec                 // 전일대비 증감 수
        case isolClearCnt           // 격리 해제 수
        case qurRate                // 10만명당 발생률
        case standardDay = "stdDay" // 기준일시
        case defCnt                 // 확진자 수
        case overFlowCnt            // 해외유입 수
        case localOccCnt            // 지역발생 수
    }
}
