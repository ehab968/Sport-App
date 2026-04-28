//
//  SportsCollectionViewCell.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sportImage: UIImageView!
    
    @IBOutlet weak var sportTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 12.0
        
        self.contentView.layer.masksToBounds = true
        
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
