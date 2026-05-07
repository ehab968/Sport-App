//
//  FavoriteTableViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class FavoriteTableViewController: UITableViewController{
    var presenter: FavLeaguePresenter?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavLeaguePresenter()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchFavLeaguesFromCoreData()
    }
    
    
    func setupBinding() {
        tableView.dataSource = nil
        presenter?.favLeaguesObservable
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: FavLeagueCell.self)) { (row, league, cell) in
                cell.favLeagueName.text = league.leagueName
                cell.favLeagueCountryName.text = league.countryName
                
                if let logoString = league.leagueImage, let url = URL(string: logoString) {
                    cell.favLeagueImage.sd_setImage(with: url, placeholderImage: UIImage.league)
                }
                else {
                    cell.favLeagueImage.image = UIImage.league
                }
               
            }
            .disposed(by: disposeBag)
        
        presenter?.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self = self else { return }
                self.showAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
