//
//  OnBoardingPageViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 11/05/2026.
//

import UIKit

class OnBoardingPageViewController: UIPageViewController {
    
    var onboardingViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPageControl.appearance().currentPageIndicatorTintColor = .appPrimary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
        self.view.backgroundColor = .appBackground
        setupOnboardingViewControllers()
        
        dataSource = self
        delegate = self
        
        if let firstVC = onboardingViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupOnboardingViewControllers() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        let vc2 = sb.instantiateViewController(withIdentifier: "OnBoardingSecondViewController") as! OnBoardingSecondViewController
        let vc3 = sb.instantiateViewController(withIdentifier: "OnBoardingThirdViewController") as! OnBoardingThirdViewController
        
        vc1.delegate = self
        vc2.delegate = self
        vc3.delegate = self
        
        onboardingViewControllers = [vc1, vc2, vc3]
    }
    
    func navigateToMain() {
        UserDefaults.standard.set(true, forKey: OnboardingConstants.hasSeenOnboarding.rawValue)
        
        guard let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else { return }
        
        
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

extension OnBoardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return onboardingViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.firstIndex(of: viewController), index < onboardingViewControllers.count - 1 else {
            return nil
        }
        return onboardingViewControllers[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first,
              let index = onboardingViewControllers.firstIndex(of: firstVC) else {
            return 0
        }
        return index
    }
}

extension OnBoardingPageViewController: OnBoardingDelegate {
    func didTapNext() {
        guard let currentVC = viewControllers?.first,
              let currentIndex = onboardingViewControllers.firstIndex(of: currentVC) else { return }
        
        let nextIndex = currentIndex + 1
        
        if nextIndex < onboardingViewControllers.count {
            setViewControllers([onboardingViewControllers[nextIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            navigateToMain()
        }
    }
    
    func didTapSkip() {
        navigateToMain()
    }
}
