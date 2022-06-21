//
//  MockSettingLogic.swift
//  Asurion-iOSTests
//
//  Created by Shrey Shrivastava on 21/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import XCTest

@testable import Asurion_iOS

class MockSettingLogic: SettingsLogic {
    func getSettingsData(completion: @escaping (Result<Config, Error>) -> ()) {
        if let data = kSettingsMockData.data(using: .utf8){
            do{
                let config = try JSONDecoder().decode(Config.self, from: data)
                completion(.success(config))
            }catch {
                completion(.failure(error))
            }
        }
    }
}
