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
import SkeletonView

protocol LeagueTableViewControllerProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func onSaveLeagueSuccess()
    func onRemoveLeagueSuccess()
    func onSaveLeagueFailure(message: String)
    func showOfflineAlert()
}



class LeagueTableViewController: UITableViewController , LeagueTableViewControllerProtocol {
    
    var presenter: LeaguePresenterProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.sectionHeaderTopPadding = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0))
        
        tableView.isSkeletonable = true
        
        Task {
            await presenter?.fetchLeagues()
        }
        self.navigationItem.title = LocalizationKey.leaguesTitle.localized
    }
    
    func showLoading() {
        tableView.showAnimatedGradientSkeleton()
    }
    
    func hideLoading() {
        tableView.hideSkeleton()
    }
    
    func showError(message: String) {
        showAlert(title: LocalizationKey.errorTitle.localized, message: message)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    func onSaveLeagueSuccess() {
        //        showAlert(title: "Success", message: "League added to favorites")
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.makeToast(LocalizationKey.leagueAddedMessage.localized, duration: 1.5, position: .bottom)
        }
    }
    func onRemoveLeagueSuccess() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.makeToast(LocalizationKey.leagueRemovedMessage.localized, duration: 1.5, position: .bottom)
        }
    }
    
    
    
    func onSaveLeagueFailure(message: String) {
        showAlert(title: LocalizationKey.errorTitle.localized, message: message)
    }
    
    func showOfflineAlert() {
        showAlert(title: LocalizationKey.offlineTitle.localized, message: LocalizationKey.offlineMessage.localized)
    }
    
    @IBAction func reloadBtnAction(_ sender: Any) {
        Task {
            await presenter?.fetchLeagues()
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LeagueTableViewController: SkeletonTableViewDataSource {
    
    // MARK: - Skeleton Table View Data Source
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
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
        
        let leaguePlaceholder = UIImage(named: "league_placeholder")
        if let logoString = league?.leagueLogo, let url = URL(string: logoString) {
            cell.leagueImage.sd_setImage(with: url, placeholderImage: leaguePlaceholder)
        } else {
            cell.leagueImage.image = leaguePlaceholder
        }
        
        let countryPlaceholder = UIImage(named: "country_placeholder")
        
        if let logoString = league?.countryLogo, let url = URL(string: logoString) {
            cell.countryImage.sd_setImage(with: url, placeholderImage: countryPlaceholder)
        } else {
            cell.countryImage.image = countryPlaceholder
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
        
        
        if presenter?.sportEndpointName == APIEndpoints.cricket{
            let cricketLeagueDetailsVc = storyboard?.instantiateViewController(identifier: "CricketTableViewController") as? CricketTableViewController
            cricketLeagueDetailsVc?.presenter = CricketPresenter(
                leagueId: String(presenter?.getLeague(at: indexPath.section).leagueKey ?? 0),
                sportEndpointName: (presenter as? LeaguePresenter)?.sportEndpointName
                , view: cricketLeagueDetailsVc
            )
            let backButton = UIBarButtonItem()
            backButton.tintColor = .primary
            self.navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(cricketLeagueDetailsVc!, animated: true)
            
        }else {
            let leagueDetailsVc = storyboard?.instantiateViewController(identifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController
            leagueDetailsVc?.leagueDetailsPresenter = LeagueDetailsPresenter(
                leagueId: String(presenter?.getLeague(at: indexPath.section).leagueKey ?? 0),
                sportEndpointName: (presenter as? LeaguePresenter)?.sportEndpointName
                , view: leagueDetailsVc
            )
            let backButton = UIBarButtonItem()
            backButton.tintColor = .primary
            self.navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(leagueDetailsVc!, animated: true)
        }
        
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
