//
//  FavLeagueCell.swift
//  Sport Mob
//
//  Created by Ehab Salah on 07/05/2026.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
class FavLeagueCell: UITableViewCell {
    
    @IBOutlet weak var favLeagueImage: UIImageView!
    @IBOutlet weak var favLeagueName: UILabel!
    @IBOutlet weak var favLeagueCountryName: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favLeagueImage.layer.cornerRadius = favLeagueImage.frame.size.width / 2
        favLeagueImage.clipsToBounds = true
        favLeagueImage.layer.borderWidth = 1.0
        favLeagueImage.layer.borderColor = UIColor.appPrimary.cgColor
        self.contentView.layer.cornerRadius = 12.0
        self.layer.cornerRadius = 12.0
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .cellBackground
        
        setupRemoveButton()
    }
    
    private func setupRemoveButton() {
        removeButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.85)
        removeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        removeButton.layer.shadowRadius = 8
        removeButton.layer.shadowOpacity = 0.3
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        favLeagueImage.layer.cornerRadius = favLeagueImage.frame.size.width / 2
        
        removeButton.layer.cornerRadius = removeButton.frame.size.height / 2
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setupCell(leagueName: String, countryName: String, leagueImageURL: String , removeAction: @escaping () -> Void) {
        favLeagueName.text = leagueName
        favLeagueCountryName.text = countryName
        let leaguePlaceholder = UIImage(named: "league_placeholder")
        if let url = URL(string: leagueImageURL) {
            favLeagueImage.sd_setImage(with: url,placeholderImage: leaguePlaceholder)
        }
        else {
            favLeagueImage.image = leaguePlaceholder
        }
        
        removeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.animateButtonTap()
                removeAction()
            })
            .disposed(by: disposeBag)
    }
    
    private func animateButtonTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.removeButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.removeButton.transform = .identity
            }, completion: nil)
        }
    }
}
