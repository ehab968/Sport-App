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
        presenter = LeaguePresenter(view: self)
        let indicator = UIActivityIndicatorView(style: .large)
    }
    
    
    
    func showLoading() {
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let league = presenter?.getLeague(at: indexPath.row)
        cell.textLabel?.text = league?.leagueName
        cell.detailTextLabel?.text = league?.countryName
        
        if let logoString = league?.leagueLogo, let url = URL(string: logoString) {
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage.league)
        } else {
            cell.imageView?.image = UIImage.league
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let placeholder = UIImage(systemName: "globe.europe.africa.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        if let logoString = league?.countryLogo, let url = URL(string: logoString) {
            imageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            imageView.image = placeholder
        }
        cell.accessoryView = imageView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
