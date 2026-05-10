//
//  TeamPlayersCellHeader.swift
//  Sport Mob
//
//  Created by Al3dwy on 08/05/2026.
//

import UIKit

class TeamPlayersCellHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var playersPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .appBackground
        self.backgroundView = backgroundView
        
        playersPosition.textColor = .appPrimary
        playersPosition.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
