//
//  Pets.swift
//  Asurion-iOS
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
struct Pets : Codable {
    let pets: [Pet]
}
struct Pet : Codable {
    let image_url: String
    let title: String
    let content_url: String
    let date_added: String
}

