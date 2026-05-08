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
import Toast

protocol LeagueTableViewControllerProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func onSaveLeagueSuccess()
    func onRemoveLeagueSuccess()
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
//        showAlert(title: "Success", message: "League added to favorites")
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.makeToast("League added to favorites", duration: 1.5, position: .bottom)
        }
    }
    func onRemoveLeagueSuccess() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.makeToast("League removed from favorites", duration: 1.5, position: .bottom)
        }
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
        
        // trigger cell data fetching and configure cell
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
        
        
        // configure fav button state
        var isFav = presenter?.isLeagueFav(at: indexPath.section) ?? false
        let favIcon = isFav ? "heart.fill" : "heart"
        cell.favBtn.setImage(UIImage(systemName: favIcon), for: .normal)
        
        
        // fav button action with RxSwift
        cell.favBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let league = league else { print("League data is unavailable"); return }
                if isFav == false {
                    self?.presenter?.addLeagueToFavorites(league: league)
                    cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    isFav = true
                }
                else {
                    self?.presenter?.removeLeagueFromFav(at: indexPath.section)
                    cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    isFav = false
                }
            }).disposed(by: cell.disposeBag)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetailsVc = storyboard?.instantiateViewController(identifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController
        leagueDetailsVc?.leagueDetailsPresenter = LeagueDetailsPresenter(
            leagueId: String(presenter?.getLeague(at: indexPath.row).leagueKey ?? 0),
            sportEndpointName: (presenter as? LeaguePresenter)?.sportEndpointName
            , view: leagueDetailsVc
        )
        navigationController?.pushViewController(leagueDetailsVc!, animated: true)
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
