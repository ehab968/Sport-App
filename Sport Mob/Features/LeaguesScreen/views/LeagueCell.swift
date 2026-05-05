//
//  LeagueCell.swift
//  Sport Mob
//
//  Created by Ehab Salah on 03/05/2026.
//

import UIKit
import RxSwift
class LeagueCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var disposeBag = DisposeBag()

        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }

}
