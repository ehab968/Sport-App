//
//  LanguageAlert.swift
//  Sport Mob
//
//  Created by Ehab Salah on 09/05/2026.
//

import Foundation
import UIKit


extension UIViewController{
    func ShowLanguageAlert() {
        let alert = UIAlertController(title: LocalizationKey.chooseLanguage.localized,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: "English", style: .default) { _ in
            LanguageManager.changeLanguage(to: "en")
        }
        
        
        let arabicAction = UIAlertAction(title: "العربية", style: .default) { _ in
            LanguageManager.changeLanguage(to: "ar")
        }
        
        let cancelAction = UIAlertAction(title: LocalizationKey.cancelBtn.localized, style: .cancel, handler: nil)
        
        alert.addAction(englishAction)
        alert.addAction(arabicAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
