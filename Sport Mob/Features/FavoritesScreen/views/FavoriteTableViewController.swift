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
        
        let appearance = UINavigationBarAppearance()
        
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = LocalizationKey.favoritesTitle.localized
    }
    
    
    func setupBinding() {
        tableView.dataSource = nil
        presenter?.favLeaguesDriver
            .drive(tableView.rx.items(cellIdentifier: "favCell", cellType: FavLeagueCell.self)) {
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
        presenter?.errorDriver
            .drive(onNext: { [weak self] message in
                guard let self = self else { return }
                self.showAlert(title: LocalizationKey.errorTitle.localized, message: message)
            })
            .disposed(by: disposeBag)
        
        presenter?.removeSuccessDriver
            .drive(onNext: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    window.makeToast(LocalizationKey.leagueRemovedMessage.localized, duration: 1.5, position: .bottom)
                }
            }).disposed(by: disposeBag)
        
        presenter?.noFavDriver
            .drive(onNext: { [weak self] leagues in
                guard let self = self else { return }
                if leagues.isEmpty {
                    self.showNoFavImage()
                }
                else{
                    self.tableView.backgroundView = nil
                }
            }).disposed(by: disposeBag)
    }
    
    func showNoFavImage() {
        let emptyView = UIView(frame: self.tableView.bounds)
        
        let imageView = UIImageView()
        imageView.image = UIImage.noFav
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        let titleLabel = UILabel()
        titleLabel.text = "No Favorite Leagues"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.tableView.backgroundView = emptyView
        
        self.tableView.separatorStyle = .none
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
