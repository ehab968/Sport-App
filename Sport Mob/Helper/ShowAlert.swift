//
//  Helper.swift
//  Sport Mob
//
//  Created by Ehab Salah on 02/05/2026.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showConfirmationAlert(title: String, message: String, confirmTitle: String, cancelTitle: String, confirmHandler: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in
                confirmHandler()
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
