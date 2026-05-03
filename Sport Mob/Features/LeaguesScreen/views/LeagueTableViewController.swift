//
//  LeagueTableViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit
import SDWebImage
protocol LeagueTableViewControllerProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
}



class LeagueTableViewController: UITableViewController , LeagueTableViewControllerProtocol {
    var presenter: LeaguePresenterProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await presenter?.fetchLeagues()
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
    
    func hideLoading() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func showError(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func reloadBtnAction(_ sender: Any) {
        Task {
            await presenter?.fetchLeagues()
        }
    }
    
}

extension LeagueTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getleaguesCount() ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueCell
        let league = presenter?.getLeague(at: indexPath.row)
        cell.leagueLabel.text = league?.leagueName
        cell.countryLabel.text = league?.countryName
        
        if let logoString = league?.leagueLogo, let url = URL(string: logoString) {
            cell.leagueImage.sd_setImage(with: url, placeholderImage: UIImage.league)
        } else {
            cell.leagueImage.image = UIImage.league
        }
        

        
        let placeholder = UIImage(systemName: "globe.europe.africa.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        if let logoString = league?.countryLogo, let url = URL(string: logoString) {
            cell.countryImage.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            cell.countryImage.image = placeholder
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
