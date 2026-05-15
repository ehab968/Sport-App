//
//  NextMatchsCollectionViewCell.swift
//  Sport Mob
//
//  Created by Al3dwy on 02/05/2026.
//

import UIKit

class NextMatchesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstTeamImage: UIImageView!
    
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var secondTeamImage: UIImageView!
    
    @IBOutlet weak var matchTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 12.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.appPrimary.cgColor
        self.contentView.backgroundColor = .cellBackground
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            stopShimmering() 
        }
}
