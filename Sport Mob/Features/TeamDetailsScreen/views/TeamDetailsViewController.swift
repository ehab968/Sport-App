//
//  TeamDetailsViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit

class TeamDetailsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teamPlayersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TeamPlayersTableViewCell", bundle: nil)
        teamPlayersTableView.register(nib, forCellReuseIdentifier: "TeamPlayersTableViewCell")
        teamPlayersTableView.register(UINib(nibName: "TeamPlayersCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TeamPlayersCellHeader")
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayersTableViewCell", for: indexPath) as! TeamPlayersTableViewCell
        // cell.isFirstCell = (indexPath.row == 0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TeamPlayersCellHeader") as? TeamPlayersCellHeader
        switch section {
        case 0:
            header?.playersPosition?.text = "Coash"
        case 1:
            header?.playersPosition?.text = "keepers"
        case 2:
            header?.playersPosition?.text = "Defenders"
        case 3:
            header?.playersPosition?.text = "Midfielders"
        case 4:
            header?.playersPosition?.text = "Forwards"
        default:
            header?.playersPosition?.text = ""
        }
            return header
            
            
            
            
            
        }
    
    
    
    
}

