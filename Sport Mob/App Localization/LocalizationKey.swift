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
    case noFavoritesMessage = "no_fav_Leagues"
    case noTennisTeams = "no_tennis_teams"
    case age = "age"
    case coach = "coach"
    case keepers = "keepers"
    case defenders = "defenders"
    case midfielders = "midfielders"
    case forwards = "forwards"
    case offlineTitle = "offline_title"
    case offlineMessage = "offline_message"
    case removeConfirmationTitle = "remove_confirmation_title"
    case removeConfirmationMessage = "remove_confirmation_message"
    
    var localized: String {
        let lang = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
    }
}




