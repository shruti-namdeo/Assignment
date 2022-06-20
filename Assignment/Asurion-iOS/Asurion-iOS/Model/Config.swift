//
//  Config.swift
//  Asurion-iOS
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

struct Config : Codable {
    let settings: Settings
}
struct Settings : Codable {
    let isChatEnabled : Bool
    let isCallEnabled : Bool
    let workHours : String
}
