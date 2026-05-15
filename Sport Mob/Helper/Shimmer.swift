//
//  Shimmer.swift
//  Sport Mob
//
//  Created by Al3dwy on 14/05/2026.
//

import Foundation
import UIKit


extension UIView {
    func startShimmering() {
        let light = UIColor(white: 0.9, alpha: 1.0).cgColor
        let dark = UIColor(white: 0.8, alpha: 1.0).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -self.bounds.width, y: 0, width: self.bounds.width * 3, height: self.bounds.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0, 0.5, 1.0]
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        
        gradient.add(animation, forKey: "shimmer")
        self.layer.addSublayer(gradient)
        self.layer.name = "shimmerLayer" 
    }

    func stopShimmering() {
        self.layer.sublayers?.removeAll(where: { $0.animation(forKey: "shimmer") != nil })
    }
}
