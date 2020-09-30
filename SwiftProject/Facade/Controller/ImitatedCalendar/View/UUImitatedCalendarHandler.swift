//
//  UUImitatedCalendarHandler.swift
//  SwiftProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

import Foundation

class UUImitatedCalendarHandler {
    
    static let todayComponents = Calendar.current.dateComponents(in: .current, from: Date())
    
    // the begin index at first day of each month
    public static func beginIndex(with components: DateComponents) -> Int {
        guard let weekday = components.weekday else { return 0 }
        return weekday - 1
    }
    
    public static func monthDays(with components: DateComponents) -> Int {
        guard let month = components.month, let year = components.year else { return 0 }
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return isLeapYear(year) ? 29: 28
        default: return 0
        }
    }
    
    public static func isLeapYear(_ year: Int) -> Bool {
        return (year % 4  == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
    public static func buttonWillHidden(with components: DateComponents) -> Bool {
        let begin = beginIndex(with: components)
        let days = monthDays(with: components)
        return 42 - begin - days >= 7
    }
    
    public static func componentsWithMonthDeviation(_ deviation: Int) -> DateComponents {
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        var month = components.month!
        var year = components.year!
        
        var monthDeviation: Int, yearDeviation: Int
        if deviation > 0 {
            monthDeviation = deviation % 12
            yearDeviation = deviation / 12
            if month + monthDeviation > 12 {
                month = month + monthDeviation - 12
                yearDeviation += 1
            } else {
                month = month + monthDeviation
            }
        } else {
            monthDeviation = deviation % 12
            yearDeviation = deviation / 12
            if month + monthDeviation < 0 {
                month = month + monthDeviation + 12
                yearDeviation -= 1
            } else if month + monthDeviation == 0 {
                month = 12
                yearDeviation -= 1
            } else {
                month = month + monthDeviation
            }
        }
        year = year + yearDeviation
        let dateString = String(format: "%d%02d01", year, month)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)
        
        return Calendar.current.dateComponents(in: TimeZone.current, from: date!)
    }
    
}
