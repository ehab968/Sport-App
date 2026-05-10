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
            .subscribe(onNext: {
                removeAction()
            })
            .disposed(by: disposeBag)
    }
}
