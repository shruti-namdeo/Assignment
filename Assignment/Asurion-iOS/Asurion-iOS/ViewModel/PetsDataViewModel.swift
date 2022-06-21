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

let kPetsURL = "https://jsonkeeper.com/b/EG55"

class PetsDataViewModel {
    
    let networkLayer: APICall
    
    init(networkLayer: APICall) {
        self.networkLayer = networkLayer
    }
    
    /// parses response from API - covert it to Pets object
    /// - Parameter completion: handling failure or success
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
    /// fetch data from API
    /// - Parameter completion: return result
    func getPetsData(completion: @escaping (Result<Pets,Error>) -> ()) {
        self.getPetsDataFromAPI { (result) in
            completion(result)
        }
    }
}


