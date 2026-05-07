//
//  FavLeagueCell.swift
//  Sport Mob
//
//  Created by Ehab Salah on 07/05/2026.
//

import UIKit

class FavLeagueCell: UITableViewCell {

    @IBOutlet weak var favLeagueImage: UIImageView!
    @IBOutlet weak var favLeagueName: UILabel!
    @IBOutlet weak var favLeagueCountryName: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
