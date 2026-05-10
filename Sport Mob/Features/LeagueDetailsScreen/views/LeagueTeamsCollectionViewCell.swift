//
//  LeagueTeamsCollectionViewCell.swift
//  Sport Mob
//
//  Created by Al3dwy on 02/05/2026.
//

import UIKit

class LeagueTeamsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var teamImage: UIImageView!
    
    @IBOutlet weak var teamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 12.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.appPrimary.cgColor
        self.contentView.backgroundColor = .cellBackground
    }
}
