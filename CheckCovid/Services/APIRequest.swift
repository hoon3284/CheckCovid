//
//  APIRequest.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/23.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var request: URLRequest { get }
}

extension APIRequest {
    var host: String {
        return "openapi.data.go.kr"
    }
    var path: String {
        return "/openapi/service/rest/Covid19/getCovid19SidoInfStateJson"
    }
}

extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "http"
        components.host = host
        components.path = path
        components.percentEncodedQueryItems = queryItems
        
        let request = URLRequest(url: components.url!)
        
        return request
    }
}

extension APIRequest where Response == [CovidInfo] {
    func send(completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            let nomalServiceCode = "00"
            
            if let data = data {
                let parser = XMLParser(data: data)
                let covidInfoParser = CovidInfoParser()
                parser.delegate = covidInfoParser
                parser.parse()
                
                if covidInfoParser.resultCode == nomalServiceCode {
                    let items = covidInfoParser.items
                    if items.isEmpty, let apiError = APIError(rawValue: covidInfoParser.resultCode) {
                        completion(.failure(apiError))
                    } else {
                        completion(.success(items))
                    }
                } else {
                    let apiError = APIError(rawValue: covidInfoParser.resultCode)
                    completion(.failure(apiError!))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
