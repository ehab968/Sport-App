import Foundation
import UIKit

extension UIView {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set {
            guard let key = newValue else { return }
            
            let lang = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
            
            guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
                  let bundle = Bundle(path: path) else { return }
            
            let localizedValue = NSLocalizedString(key, bundle: bundle, comment: "")
            
            if let label = self as? UILabel {
                label.text = localizedValue
            }
            else if let button = self as? UIButton {
                button.setTitle(localizedValue, for: .normal)
            }
        }
    }
}
