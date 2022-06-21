//
//  SettingsViewModel.swift
//  Asurion-iOS
//
//  Created by Shrey Shrivastava on 21/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

protocol SettingsLogic {
    func getSettingsData(completion: @escaping (Result<Config,Error>) -> ())
}

let kConfigURL = "https://jsonkeeper.com/b/HMRY"

class SettingsViewModel {
    let networkLayer: APICall
    
    init(networkLayer: APICall) {
        self.networkLayer = networkLayer
    }
    
    /// parses response from API - covert it to config object
    /// - Parameter completion: handles failure or success
    private func getConfigsDataFromAPI(completion: @escaping (Result<Config,Error>) -> ()){
        self.networkLayer.getAPIResponse(forURL: kConfigURL) { (result) in
            switch result{
            case .failure( let error):
                // pass error to UI
                completion(.failure(error))
            case .success(let data):
                do{
                    completion(.success(try JSONDecoder().decode(Config.self, from: data)))
                }catch{
                    completion(.failure(error))
                }
            }
        }
    }
}
extension SettingsViewModel: SettingsLogic{
    
    /// get data from API
    /// - Parameter completion: return result from api
    func getSettingsData(completion: @escaping (Result<Config,Error>) -> ()) {
        self.getConfigsDataFromAPI { (result) in
            completion(result)
        }
    }
}
