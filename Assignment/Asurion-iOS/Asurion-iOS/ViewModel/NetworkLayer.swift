//
//  NetworkLayer.swift
//  Asurion-iOS
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

enum APIError: Error{
    
    case invalidURL
    case invalidJSON
    case notReachable
    case unknownError
}

protocol APICall{
    func getAPIResponse(forURL: String, completion: @escaping (Result<Data,Error>) ->())
}

/// To handle network calls
struct NetworkLayer: APICall {
    let session = URLSession.init(configuration: .default)
    
    /// getAPIresponse
    /// - Parameter forURL: target url to fetch data
    /// - Parameter completion: handle failure or success
    func getAPIResponse(forURL: String, completion: @escaping (Result<Data,Error>) ->()) {
        guard let url = URL.init(string: forURL) else{
           completion(.failure(APIError.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let apiError = error{
                 completion(.failure(apiError))
            }
            if let apiData = data{
                 completion(.success(apiData))
            }
        }
        task.resume()
    }
}
