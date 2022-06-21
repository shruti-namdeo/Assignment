//
//  AsurionHomeConstants.swift
//  Asurion-iOS
//
//  Created by Shruti Shrivastava on 20/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

enum AsurionHomeConstants: String{
    case screenTitle = "Asurion"
    case reusableCellIdentifier = "pets-reusable-cell"
    case officeHoursLabel = "Office Hours: "
    case webSegueIdentifier = "webviewSegue"
}

enum AlertButtonTitles: String{
    case ok = "OK"
    case dismiss = "Dismiss"
    case close = "Close"
    case title = "Asurion"
}
enum AlertMessage: String {
    case isWithinWorkingHours = "Thank you for getting in touch with us. We’ll get back to you as soon as possible"
    case notWithinWorkingHours = "Work hours has ended. Please contact us again on the next work day"
}
