import UIKit

extension UIColor {
    static var appPrimary: UIColor {
        return UIColor(named: "Primary Color") ?? .systemBlue
    }
    
    static var appAccent: UIColor {
        return UIColor(named: "AccentColor") ?? .systemBlue
    }
    
    static var textButtonn: UIColor {
        return UIColor(named: "TextButton") ?? .white
    }
    
    static var appText: UIColor {
        return UIColor(named: "TextColor") ?? .black
    }
    
    static var appBackground: UIColor {
        return UIColor(named: "App BackGround") ?? .systemBackground
    }
    
    static var cellBackground: UIColor {
        return UIColor(named: "cell color") ?? .secondarySystemBackground
    }
}
