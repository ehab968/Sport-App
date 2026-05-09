//
//  LocalizationKey.swift
//  Sport Mob
//
//  Created by Ehab Salah on 08/05/2026.
//
import Foundation

enum LocalizationKey: String {
    case appName = "app_name"
    case leaguesTitle = "leagues_nav_title"
    case favoritesTitle = "favorites_nav_title"
    case sportsTab = "sports_tab"
    case favoritesTab = "favorites_tab"
    case leaguePlaceholder = "league_name_placeholder"
    case countryPlaceholder = "country_name_placeholder"
    case removeBtn = "remove_btn"
    case vsLabel = "vs_label"
    case chooseYourSport = "choose_your_sport"
    case footballSport = "football_sport"
    case basketballSport = "basketball_sport"
    case tennisSport = "tennis_sport"
    case cricketSport = "cricket_sport"
    case errorTitle = "error_title"
    case chooseLanguage = "choose_language"
    case cancelBtn = "cancel_btn"
    case leagueAddedMessage = "league_added_message"
    case leagueRemovedMessage = "league_removed_message"
    var localized: String {
        let lang = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
    }
}




