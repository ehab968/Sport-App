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
    
    @IBOutlet weak var themeIcon: UIBarButtonItem!
    @IBOutlet weak var localizationIcon: UIBarButtonItem!
    var presenter: FavLeaguePresenter?
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavLeaguePresenter()
        presenter?.fetchFavLeaguesFromCoreData()
        setupBinding()
        setupState()
        setupTheme()
        
        let appearance = UINavigationBarAppearance()
        
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.primary,
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
        titleLabel.text = LocalizationKey.noFavoritesMessage.localized
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .primary
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        self.tableView.backgroundView = emptyView
        
        self.tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116  // 100pt content + 16pt for top/bottom spacing insets
    }
    
}

 // Nav button actions
extension FavoriteTableViewController {
    func setupTheme() {
        self.themeIcon.image = UIImage(systemName: ThemeManager.shared.isDarkMode() ? "sun.max.fill" : "moon.fill")
        onThemeChanged()
    }
    
    func onThemeChanged() {
        themeIcon.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            ThemeManager.shared.toogleTheme()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = ThemeManager.shared.isDarkMode() ? .dark : .light
            }
            
            self.themeIcon.image = UIImage(systemName: ThemeManager.shared.isDarkMode() ? "sun.max.fill" : "moon.fill")
        }).disposed(by: self.disposeBag)
    }
    
    @IBAction func localizationaction(_ sender: Any) {
        self.ShowLanguageAlert()
    }
}
