//
//  ThemeManager.swift
//  Sport Mob
//
//  Created by Ehab Salah on 09/05/2026.
//

import Foundation


class ThemeManager {
    static let shared = ThemeManager()
    
    func saveTheme(by constant: ThemeConstants) {
        UserDefaults.standard.set(constant.rawValue, forKey: ThemeConstants.appTheme.rawValue)
    }
    func getSavedTheme() -> ThemeConstants {
        let savedString = UserDefaults.standard.string(forKey: ThemeConstants.appTheme.rawValue)
        return ThemeConstants(rawValue: savedString ?? ThemeConstants.light.rawValue)!
    }
    
    func toogleTheme() {
        let currentTheme = getSavedTheme()
        let newTheme: ThemeConstants = (currentTheme == .light) ? .dark : .light
        saveTheme(by: newTheme)
    }
    func isDarkMode() -> Bool {
        return getSavedTheme() == .dark
    }
}
