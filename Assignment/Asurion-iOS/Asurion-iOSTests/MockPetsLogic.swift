//
//  MockPetsLogic.swift
//  Asurion-iOSTests
//
//  Created by Shrey Shrivastava on 21/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
@testable import Asurion_iOS

class MockPetsLogic: PetsLogic{
    func getPetsData(completion: @escaping (Result<Pets, Error>) -> ()) {
        if let data = kPetsMockData.data(using: .utf8){
            do{
                let pets = try JSONDecoder().decode(Pets.self, from: data)
                completion(.success(pets))
            }catch {
                completion(.failure(error))
            }
        }
    }
}
