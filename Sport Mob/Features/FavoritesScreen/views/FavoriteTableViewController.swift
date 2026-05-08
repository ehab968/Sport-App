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
import Toast
class FavoriteTableViewController: UITableViewController{
    var presenter: FavLeaguePresenter?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavLeaguePresenter()
        presenter?.fetchFavLeaguesFromCoreData()
        setupBinding()
        setupState()
    }
    
    
    func setupBinding() {
        tableView.dataSource = nil
        presenter?.favLeaguesObservable
            .bind(to: tableView.rx.items(cellIdentifier: "favCell", cellType: FavLeagueCell.self)) {
                [weak self] (row, league, cell) in
                guard let self = self else { return }
                cell.setupCell(
                    leagueName: league.leagueName ?? "",
                    countryName: league.countryName ?? "",
                    leagueImageURL: league.leagueImage ?? ""
                ){
                    self.presenter?.removeLeagueFromFav(at: Int(league.id))
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func setupState(){
        presenter?.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self = self else { return }
                self.showAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
        presenter?.removeSuccessState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    window.makeToast("League removed from favorites", duration: 1.5, position: .bottom)
                }
            }).disposed(by: disposeBag)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
