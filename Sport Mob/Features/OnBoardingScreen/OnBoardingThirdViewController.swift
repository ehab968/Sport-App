//
//  OnBoardingThirdViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 11/05/2026.
//

import UIKit

class OnBoardingThirdViewController: UIViewController {

    @IBOutlet weak var onBoardingImage: UIImageView!
    @IBOutlet weak var onBoardingTitle: UILabel!
    @IBOutlet weak var onboardingDescribtion: UILabel!
    
    weak var delegate: OnBoardingDelegate?

    var imageTitle: String?
    var mainTitle: String?
    var subTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        onBoardingImage.image = UIImage(systemName: "trophy.fill")
    }

    @IBAction func getStartedTapped(_ sender: UIButton) {
        delegate?.didTapNext()
    }
}
