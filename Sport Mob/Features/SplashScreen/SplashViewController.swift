//
//  SplashViewController.swift
//  Sport Mob
//
//  Created by Sport Mob.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - IBOutlets (connected in Main.storyboard)
    
    @IBOutlet weak var glowCircle: UIView!
    @IBOutlet weak var logoContainer: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runSplashAnimation()
    }
    
    // MARK: - Appearance
    
    private func setupAppearance() {
        // Apply dynamic colors that can't be set in storyboard
        glowCircle.backgroundColor = UIColor.appPrimary.withAlphaComponent(0.08)
        glowCircle.layer.cornerRadius = 110
        
        logoImageView.tintColor = .appPrimary
        
        appNameLabel.textColor = .appPrimary
        taglineLabel.textColor = UIColor.appPrimary.withAlphaComponent(0.7)
        
        // Initial hidden states for animation
        glowCircle.alpha = 0
        glowCircle.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        logoContainer.alpha = 0
        appNameLabel.alpha = 0
        taglineLabel.alpha = 0
    }
    
    // MARK: - Animation
    
    private func runSplashAnimation() {
        
        // 1. Glow circle expands in
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.glowCircle.alpha = 1
            self.glowCircle.transform = .identity
        }
        
        // 2. Logo scales in with a bounce
        logoContainer.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.65, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.logoContainer.alpha = 1
            self.logoContainer.transform = .identity
        }
        
        // 3. App name fades + slides up
        appNameLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut) {
            self.appNameLabel.alpha = 1
            self.appNameLabel.transform = .identity
        }
        
        // 4. Tagline fades in
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut) {
            self.taglineLabel.alpha = 1
        }
        
        // 5. Pulse the logo once
        UIView.animate(withDuration: 0.2, delay: 0.9, options: .curveEaseIn) {
            self.logoContainer.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.logoContainer.transform = .identity
            }
        }
        
        // 6. Navigate to main TabBar after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.transitionToMain()
        }
    }
    
    private func transitionToMain() {
        guard let mainVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else { return }
        
        guard let window = view.window else { return }
        
        let savedThemeIsDark = ThemeManager.shared.isDarkMode()
        window.overrideUserInterfaceStyle = savedThemeIsDark ? .dark : .light
        
        if let items = mainVC.tabBar.items, items.count >= 2 {
            items[0].image = UIImage(systemName: "soccerball")
            items[0].selectedImage = UIImage(systemName: "soccerball.inverse")
            items[1].image = UIImage(systemName: "heart")
            items[1].selectedImage = UIImage(systemName: "heart.fill")
        }
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        present(mainVC, animated: true)
    }
}
