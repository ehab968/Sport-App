//
//  LeagueTableViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
protocol LeagueTableViewControllerProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func onSaveLeagueSuccess()
    func onSaveLeagueFailure(message: String)
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
    func onSaveLeagueSuccess() {
        showAlert(title: "Success", message: "League added to favorites")
    }
    
    func onSaveLeagueFailure(message: String) {
        showAlert(title: "Error", message: message)
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
        return presenter?.getleaguesCount() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueCell
        let league = presenter?.getLeague(at: indexPath.section)
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
        
        // fav button action
        cell.favBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if let league = league {
                    self?.presenter?.addLeagueToFavorites(league: league)
                    cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else {
                    self?.showAlert(title: "Error", message: "League data is unavailable")
                }
            }).disposed(by: cell.disposeBag)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
}
