//
//  TeamPlayersHeader.swift
//  Sport Mob
//
//  Created by Al3dwy on 07/05/2026.
//

import UIKit

class TeamPlayersHeader: UIView , NibLoadable{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
   
     }
    */
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        self.backgroundColor = .clear
    }

    
}
