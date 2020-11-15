//
//  NetworkManager.swift
//  Vega
//
//  Created by Alexander on 30.10.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

typealias DocumentsResult = Result<AllDocumentsDTO, HTTP.fetchDocumentsError>

protocol VegaNetworkProtocol {
    func subscribeTo(disciplines: String, completion: @escaping (String) -> Void)
    func genericFetchFunction<T: Decodable>(url: String, completion: @escaping (T?) -> Void)
    func fetchDisciplines(completion: @escaping (AllDisciplines?) -> Void)
    func fetchDocTypes(completion: @escaping (AllDocTypes?) -> Void)
    func fetchUsers(completion: @escaping (AllUsers?) -> Void)
    func fetchThemes(completion: @escaping (AllThemes?) -> Void)
    func fetchHistory(completion: @escaping (AllHistories?) -> Void)
    func fetchUpdates(completion: @escaping (AllUpdates?) -> Void)
    func fetchSubscribedDisciplines(completion: @escaping (SubscribedDisciplines?) -> Void)
    func fetchDocuments(keywords: String, completion: @escaping (DocumentsResult) -> Void)
    func fetchDocuments(keywords: String, users: [Int], completion: @escaping (DocumentsResult) -> Void)
}

final class NetworkService: VegaNetworkProtocol {
    
    private let baseURL = "http://vega.fcyb.mirea.ru/intellectapi"
    
    func subscribeTo(disciplines: String, completion: @escaping (String) -> Void) {
        let urlString = "\(baseURL)/subscribe"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        request.httpMethod = HTTP.Method.POST.rawValue
        
        let json: [String: Any] = ["subscribed_disciplines" : disciplines,
                                   "delievery" : 1,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            completion("ok")
            
        }.resume()
    }
    
    func fetchDisciplines(completion: @escaping (AllDisciplines?) -> Void) {
//        let urlString = "\(baseURL)/disciplines"
//        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchDocTypes(completion: @escaping (AllDocTypes?) -> Void) {
        let urlString = "\(baseURL)/doctypes"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchUsers(completion: @escaping (AllUsers?) -> Void) {
        let urlString = "\(baseURL)/users"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchThemes(completion: @escaping (AllThemes?) -> Void) {
        let urlString = "\(baseURL)/themes"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchHistory(completion: @escaping (AllHistories?) -> Void) {
        let urlString = "\(baseURL)/search-history"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchUpdates(completion: @escaping (AllUpdates?) -> Void) {
        let urlString = "\(baseURL)/updates"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchSubscribedDisciplines(completion: @escaping (SubscribedDisciplines?) -> Void) {
//        let urlString = "http://vega.fcyb.mirea.ru/intellectapi/subscribe"
//        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchDocuments(keywords: String, completion: @escaping (DocumentsResult) -> Void) {
        return fetchDocuments(keywords: keywords, authors: [], users: [], themes: [], completion: completion)
    }
    
    func fetchDocuments(keywords: String, users: [Int], completion: @escaping (DocumentsResult) -> Void) {
        return fetchDocuments(keywords: keywords, authors: [], users: users, themes: [], completion: completion)
    }
    
    
    
    func fetchDocuments(keywords: String,
                        authors: [String] = [],
                        users: [Int] = [],
                        themes: [String] = [],
                        completion: @escaping (DocumentsResult) -> Void) {
        let urlString = "\(baseURL)/search"
        guard let url = URL(string: urlString) else { return }
        
        let json: [String: Any] = ["keywords" : ["\(keywords)"],
                                   "disciplines" : [],
                                   "themes" : themes,
                                   "doctypes" : [],
                                   "users" : users,
                                   "upload-time-cond" : 0,
                                   "upload-time-param" : "",
                                   "authors" : [],
                                   "title" : "",
                                   "publication-date-cond" : 0,
                                   "publication-date-param" : "",
                                   "comments" : "",
                                   "rating-cond" : 0,
                                   "rating-param" : 0,
                                   "sort-order" : 1,
                                   "code" : ""
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        request.httpMethod = HTTP.Method.POST.rawValue
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.connectionError))
                return
            }
            
            guard let data = data else { return }
            print(data)
            do {
                let objects = try JSONDecoder().decode(AllDocumentsDTO.self, from: data)
                completion(.success(objects))
            } catch {
                completion(.failure(.decodeError))
                return
            }
            
        }.resume()
        
    }
    
    
}


extension NetworkService {
    func genericFetchFunction<T: Decodable>(url: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects)
            } catch {
                print(error)
                return
            }
            
        }.resume()
        
    }
}
