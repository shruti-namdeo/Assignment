//
//  PetsDataViewModel.swift
//  Asurion-iOS
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

protocol PetsLogic {
    func getPetsData(completion: @escaping (Result<Pets,Error>) -> ())
}

protocol SettingsLogic {
    func getSettingsData(completion: @escaping (Result<Config,Error>) -> ())
}

let kPetsURL = "http://0.0.0.0:8000/pets.json"
let kConfigURL = "http://0.0.0.0:8000/config.json"

class PetsDataViewModel {
    
    let networkLayer: NetworkLayer
    
    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    private func getPetsDataFromAPI(completion: @escaping (Result<Pets,Error>) -> ()){
        self.networkLayer.getAPIResponse(forURL: kPetsURL) { (result) in
            switch result{
            case .failure( let error):
                // pass error to UI
                completion(.failure(error))
            case .success(let data):
                do{
                    completion(.success(try JSONDecoder().decode(Pets.self, from: data)))
                }catch{
                    completion(.failure(error))
                }
            }
        }
    }
}
extension PetsDataViewModel: PetsLogic{
    func getPetsData(completion: @escaping (Result<Pets,Error>) -> ()) {
        self.getPetsDataFromAPI { (result) in
            completion(result)
        }
    }
}

class SettingsViewModel {
    let networkLayer: NetworkLayer
    
    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
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
    func getSettingsData(completion: @escaping (Result<Config,Error>) -> ()) {
        self.getConfigsDataFromAPI { (result) in
            completion(result)
        }
    }
}


