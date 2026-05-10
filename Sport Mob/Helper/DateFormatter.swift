//
//  DateHelper.swift
//  Sport Mob
//
//  Created by Al3dwy on 05/05/2026.
//

import Foundation

enum DateHelper {
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.calendar = Calendar(identifier: .gregorian)
        return f
    }()
    
    static func today() -> String          { formatter.string(from: Date()) }
    static func daysAgo(_ n: Int) -> String {
        let d = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
        return formatter.string(from: d)
    }
    static func daysAhead(_ n: Int) -> String {
        let d = Calendar.current.date(byAdding: .day, value: n, to: Date()) ?? Date()
        return formatter.string(from: d)
    }
}
