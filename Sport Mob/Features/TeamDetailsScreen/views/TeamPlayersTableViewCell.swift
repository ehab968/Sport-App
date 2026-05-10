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
        // Initialization code
        
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
            
           
         
          
            
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

}
