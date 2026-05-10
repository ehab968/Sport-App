//
//  TeamDetailsViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit
import SDWebImage

protocol TeamDetailsViewProtocol : AnyObject{
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func setupHeader()
    
}


class TeamDetailsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,TeamDetailsViewProtocol  {
    
    var presenter : TeamDetailsPresenterProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var teamPlayersTableView: UITableView!
    @IBOutlet weak var tableHeaderView: TeamPlayersHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TeamPlayersTableViewCell", bundle: nil)
        teamPlayersTableView.register(nib, forCellReuseIdentifier: "TeamPlayersTableViewCell")
        teamPlayersTableView.register(UINib(nibName: "TeamPlayersCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TeamPlayersCellHeader")
        
        teamPlayersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
       
        
        Task {
            await presenter?.fetchTeamDetails()
           
        }
        // Do any additional setup after loading the view.
    }
    
    
    func setupHeader(){
        let team = presenter?.getTeam()
        if team?.teamName == "Brighton & Hove Albion"{
            tableHeaderView.teamName.text = "Brighton"
        }else if team?.teamName == "Wolverhampton Wanderers" {
            tableHeaderView.teamName.text = "Wolves"
        }else {
            tableHeaderView.teamName.text = team?.teamName ?? ""
        }
        if let teamImg = team?.teamLogo, let url = URL(string: teamImg) {
            tableHeaderView.teamLogo.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
        } else {
            tableHeaderView.teamLogo.image = UIImage.undifinedTeam
        }
    }
    
    
    func showLoading() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            indicator.center = window.center
            window.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    func reloadData() {
        self.teamPlayersTableView.reloadData()
    }
    
    func hideLoading() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func showError(message: String) {
        showAlert(title: "Error", message: message)
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
        switch section {
        case 0:
            return 1
        case 1:
            return presenter?.getGoalkeepersCount() ?? 0
        case 2:
            return  presenter?.getDefendersCount() ?? 0
        case 3:
            return presenter?.getMidfieldersCount() ?? 0
        case 4:
            return presenter?.getForwardsCount() ?? 0
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayersTableViewCell", for: indexPath) as! TeamPlayersTableViewCell
        let coach = presenter?.getCoach()
        let keeper = presenter?.getGoalkeeper(at: indexPath.row)
        let defenders = presenter?.getDefender(at: indexPath.row)
        let midfielders = presenter?.getMidfielder(at: indexPath.row)
        let forwards = presenter?.getForward(at: indexPath.row)
        switch indexPath.section {
        case 0:
            cell.playerName.text = coach?.coachName ?? "UnKnown"
            cell.playerAge.text = coach?.coachAge ?? ""
            cell.playerCountry.text = coach?.coachCountry ?? ""
            cell.playerNum.text = ""
            cell.playerImage.image = UIImage.coash
            
        case 1:
            cell.playerName.text = keeper?.playerName ??
            "UnKnown"
            cell.playerNum.text = keeper?.playerNumber ?? ""
            cell.playerAge.text = keeper?.playerAge ?? ""
            cell.playerCountry.text = keeper?.playerRating ?? ""
            if let playerImg = keeper?.playerImage, let url = URL(string: playerImg) {
                cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage.unknownPlayer)
            } else {
                cell.playerImage.image = UIImage.unknownPlayer
            }
            
        case 2:
            cell.playerName.text = defenders?.playerName ??
            "UnKnown"
            cell.playerNum.text = defenders?.playerNumber ?? ""
            cell.playerAge.text = defenders?.playerAge ?? ""
            cell.playerCountry.text = defenders?.playerRating ?? ""
            if let playerImg = defenders?.playerImage, let url = URL(string: playerImg) {
                cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage.unknownPlayer)
            } else {
                cell.playerImage.image = UIImage.unknownPlayer
            }
            
        case 3:
            cell.playerName.text = midfielders?.playerName ?? "UnKnown"
            cell.playerNum.text = midfielders?.playerNumber ?? ""
            cell.playerAge.text = midfielders?.playerAge ?? ""
            cell.playerCountry.text = midfielders?.playerRating ?? ""
            if let playerImg = midfielders?.playerImage, let url = URL(string: playerImg) {
                cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage.unknownPlayer)
            } else {
                cell.playerImage.image = UIImage.unknownPlayer
            }
        case 4:
            cell.playerName.text = forwards?.playerName ?? "UnKnowm"
            cell.playerNum.text = forwards?.playerNumber ?? ""
            cell.playerAge.text = forwards?.playerAge ?? ""
            cell.playerCountry.text = forwards?.playerRating ?? ""
            if let playerImg = forwards?.playerImage, let url = URL(string: playerImg) {
                cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage.unknownPlayer)
            } else {
                cell.playerImage.image = UIImage.unknownPlayer
            }
        default:
            cell.playerName.text = ""
        }
        
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
