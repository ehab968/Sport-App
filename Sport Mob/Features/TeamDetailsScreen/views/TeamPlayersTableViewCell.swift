//
//  TeamPlayersTableViewCell.swift
//  Sport Mob
//
//  Created by Al3dwy on 07/05/2026.
//

import UIKit

class TeamPlayersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .cellBackground
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.masksToBounds = true
        
        playerImage.layer.cornerRadius = playerImage.frame.size.width / 2
        playerImage.clipsToBounds = true
        playerImage.layer.borderWidth = 2
        
        self.contentView.layer.borderColor = UIColor.appPrimary.cgColor
        playerImage.layer.borderColor = UIColor.appPrimary.cgColor
    }
   
    @IBOutlet weak var playerNum: UILabel!
    @IBOutlet weak var playerCountry: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerAge: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var ageTopSpace: UIView!
    @IBOutlet weak var stackTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imageTopSpace: NSLayoutConstraint!
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }

}
