//
//  WorkingHourViewModel.swift
//  Asurion-iOS
//
//  Created by Shrey Shrivastava on 20/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation

/// Manages time related calculation to provide valid working hours
class WorkingHourViewModel {
    let schedule: String
    
    private var schedulerInfoArray: [String]!
    
    init(schedule: String) {
        self.schedule = schedule
        splitDayTime()
    }
    
    /// calculates valid working hours and returns appropriate msg to be displayed in alert
    public func isCurrentDateTimeWithinWorkingHours() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday,.hour,.minute], from: Date())
        if isWorkingDayInSchedule(components: components){
            if(currentTimeInStartAndEndTime()){
                return AlertMessage.isWithinWorkingHours.rawValue
            }
            return AlertMessage.notWithinWorkingHours.rawValue
        }
        return AlertMessage.notWithinWorkingHours.rawValue
    }
    
    /// Validates current dat if it falls within working days
    /// - Parameter components: weekday component
    private func isWorkingDayInSchedule(components: DateComponents) -> Bool {
        if !(getWorkDayRange().contains(getAllWeekDays()[components.weekday ?? 0])) {
            return false
        }
        return true
    }
    
    /// function to get range of working days
    private func getWorkDayRange() -> [String] {
        let allWeekDays = getAllWeekDays()
        let rangeIndexes = getStartAndEndIndexForWorkDayRange(fromWeekdays: allWeekDays)
        var workWeekArray = [String]()
        for day in rangeIndexes.startIndex...rangeIndexes.endIndex {
            workWeekArray.append(allWeekDays[day])
        }
        return workWeekArray
    }
    /// filter working days from all weekdays
    private func getStartAndEndIndexForWorkDayRange(fromWeekdays: [String]) -> (startIndex: Int, endIndex: Int){
        let dayRange = self.schedulerInfoArray[0].components(separatedBy: "-")
        let startDayIndex = fromWeekdays.firstIndex(of: dayRange[0]) ?? 0
        let lastDayIndex = fromWeekdays.firstIndex(of: dayRange[1]) ?? 6
        return (startIndex: startDayIndex, endIndex: lastDayIndex)
    }
    
    /// comparing current time day falls within working day range
    private func currentTimeInStartAndEndTime() -> Bool {
        let startExactHour = getWorkSchedule().startTime.compare(getTime()) == .orderedSame
        let startRange = getWorkSchedule().startTime.compare(getTime()) == .orderedAscending
        let endExactHour = getWorkSchedule().endTime.compare(getTime()) == .orderedSame
        let endRange = getWorkSchedule().endTime.compare(getTime()) == .orderedDescending
        let result = (startExactHour || startRange) && (endExactHour || endRange)
        return result
    }
    
    /// get current time
    private func getTime() -> Date{
        let today = Date()
        let dateString = getTimeFormatter().string(from: today)
        return getTimeFormatter().date(from: dateString) ??  Date()
    }
    
    private func getAllWeekDays() -> [String] {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.veryShortWeekdaySymbols
    }
    
    private func splitDayTime() {
        schedulerInfoArray = schedule.components(separatedBy: " ")
    }
    
    private func getTimeComponentFromString(dateString: String) -> Date {
        let date = getTimeFormatter().date(from: dateString)!
        return date
    }
    private func convertDateToTimeComponent(date: Date) -> DateComponents {
        let calender = Calendar.current
        return calender.dateComponents([.day,.hour, .minute], from: date)
    }
    
    /// get work schedule
    private func getWorkSchedule() -> WorkSchedule {
        return WorkSchedule.init(workDays: getWorkDayRange(), startTime: getTimeComponentFromString(dateString: schedulerInfoArray[1]), endTime: getTimeComponentFromString(dateString: schedulerInfoArray[3]))
    }
    
    private func getTimeFormatter() -> DateFormatter{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        return inFormatter
    }
}

/// workschedule model to setup work schedule
struct WorkSchedule {
    let workDays:[String]!
    let startTime: Date!
    let endTime: Date!
}
