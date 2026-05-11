//
//  OnBoardingViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 11/05/2026.
//

import UIKit

protocol OnBoardingDelegate: AnyObject {
    func didTapNext()
    func didTapSkip()
}

class OnBoardingViewController: UIViewController {

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
        onBoardingImage.image = UIImage(systemName: "soccerball.inverse")
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.didTapNext()
    }

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        delegate?.didTapSkip()
    }
}
