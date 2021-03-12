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
    func fetchDisciplines(completion: @escaping (AllDisciplinesDTO?) -> Void)
    func fetchDocTypes(completion: @escaping (AllDocTypes?) -> Void)
    func fetchUsers(completion: @escaping (AllUsers?) -> Void)
    func fetchThemes(completion: @escaping (AllThemes?) -> Void)
    func fetchHistory(completion: @escaping (AllHistories?) -> Void)
    func fetchUpdates(completion: @escaping (AllUpdates?) -> Void)
    func fetchSubscribedDisciplines(completion: @escaping (SubscribedDisciplinesDTO?) -> Void)
    func fetchDocuments(searchQuery: SearchQuery, batchStart: String, batchSize: String, completion: @escaping (DocumentsResult) -> Void)

    func authorizationAs(completion: @escaping (String) -> Void)
    func fetchInitialForm(searchText: String, completion: @escaping (InitialForms?) -> Void)
}

final class NetworkService: VegaNetworkProtocol {
    
    private let baseURL = "https://vega.fcyb.mirea.ru/intellectphp"
    
    func authorizationAs(completion: @escaping (String) -> Void) {
        let postString = "user=f636ab96960c6dc8561a497fd7096685&pass=698d51a19d8a121ce581499d7b701668"
        
//        let params = ["user" : "f636ab96960c6dc8561a497fd7096685", "pass" : "698d51a19d8a121ce581499d7b701668" ]
//
//        var data = [String]()
//        for(key, value) in params {
//            data.append(key + "=" + value)
//        }
//        let postString = data.map { String($0) }.joined(separator: "&")
        
        let urlString = "\(baseURL)/auth"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(response)
            if let error = error {
                completion("not ok")
                return
            }
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                        print("✅Итог авторизации: \(jsonString)")
                        completion("ok")
            }
            



        }.resume()
        
        
    }

    
    func subscribeTo(disciplines: String, completion: @escaping (String) -> Void) {
        
//        let params = ["subscribed_disciplines" : "711, 710", "delivery" : "1" ]
        
//        var data = [String]()
//        for(key, value) in params {
//            data.append(key + "=" + value)
//        }
//        let postString = data.map { String($0) }.joined(separator: "&")
        
        let postString = "subscribed-disciplines=\(disciplines)&delivery=1"
        
        let urlString = "\(baseURL)/subscribe"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }

            completion("ok")

        }.resume()

    }
    
    func fetchDisciplines(completion: @escaping (AllDisciplinesDTO?) -> Void) {
        let urlString = "\(baseURL)/disciplines"
        genericFetchFunction(url: urlString, completion: completion)
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
    
    func fetchSubscribedDisciplines(completion: @escaping (SubscribedDisciplinesDTO?) -> Void) {
        let urlString = "\(baseURL)/subscribe"
        genericFetchFunction(url: urlString, completion: completion)
    }
    
    func fetchInitialForm(searchText: String, completion: @escaping (InitialForms?) -> Void){
//        print(searchText)
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        print(encodedText)
        let urlString = "\(baseURL)/com?text=\(encodedText)"
        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                        print("✅Итог преобразований: \(jsonString)")
            }
            
            
            do {
                let objects = try JSONDecoder().decode(InitialForms.self, from: data)
                completion(objects)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
                return
            }
            


        }.resume()
        
        
    }
    
    
    
    func fetchDocuments(searchQuery: SearchQuery,
                        batchStart: String,
                        batchSize: String,
                        completion: @escaping (DocumentsResult) -> Void) {
        let urlString = "\(baseURL)/search"
        guard let url = URL(string: urlString) else { return }
        
        let json: [String: Any] = ["keywords" : searchQuery.keywords,
                                   "disciplines" : searchQuery.disciplinesIDs,
                                   "themes" : searchQuery.themesIDs,
                                   "doctypes" : searchQuery.docTypesIDs,
                                   "users" : searchQuery.usersIDs,
                                   "upload-time-cond" : searchQuery.uploadTimeCond,
                                   "upload-time-param" : searchQuery.uploadTimeParam,
                                   "authors" : searchQuery.authors,
                                   "title" : searchQuery.title,
                                   "publication-date-cond" : searchQuery.publicationDateCond,
                                   "publication-date-param" : searchQuery.publicationDateParam,
                                   "comments" : searchQuery.comments,
                                   "rating-cond" : searchQuery.ratingCond,
                                   "rating-param" : searchQuery.ratingParam,
                                   "sort-order" : 1,
                                   "code" : searchQuery.code
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        
        
        // генерация boundary (разграничителя) для multipart/form-data
        let boundary = UUID().uuidString
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        //batch-start
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"batch-start\"\r\n\r\n".data(using: .utf8)!)
        data.append(batchStart.data(using: .utf8)!)
        
        //batch-size
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"batch-size\"\r\n\r\n".data(using: .utf8)!)
        data.append(batchSize.data(using: .utf8)!)
        
        //jsonData
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"data.json\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        data.append(jsonData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        


            // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { data, response, error in
            
            
            
            
            if let error = error {
                completion(.failure(.connectionError))
                return
            }
            
            guard let data = data else { return }
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("✅\(jsonString)")
//            }
            print(batchStart)
            print(batchSize)

            do {
                let objects = try JSONDecoder().decode(AllDocumentsDTO.self, from: data)
                completion(.success(objects))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
                return
            }
        }).resume()
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
//        request.httpMethod = "POST"
////        request.httpMethod = HTTP.Method.POST.rawValue
//        request.httpBody = jsonData
//
//
//
//
//        //request.httpBody = postString.data(using: .utf8)
//
//        print(jsonData)
//
////        if let jsonString = String(data: jsonData!,  encoding: .utf8) {
////                    print("✅\(jsonString)")
//
////        }
//
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let error = error {
//                completion(.failure(.connectionError))
//                return
//            }
//
//            guard let data = data else { return }
//
//            if let jsonString = String(data: data, encoding: .utf8) {
//                        print("✅\(jsonString)")
//            }
//
//            print(response)
//
//            print(data)
//            do {
//                let objects = try JSONDecoder().decode(AllDocumentsDTO.self, from: data)
//                completion(.success(objects))
//            } catch {
//                completion(.failure(.decodeError))
//                return
//            }
//
//        }.resume()
        
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("✅\(jsonString)")
            }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
                return
            }
            
        }.resume()
        
    }
}
