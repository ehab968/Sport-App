//
//  CollectionViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit


class SportsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let sportsArray = [("football","Football"), ("basketball","Basketball"), ("tennis","Tennis"), ("cricket","Cricket")]
    
    var presenter: SportsPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SportsPresenter()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.collectionView.delegate = self
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportsCollectionViewCell
        cell.sportImage.image = UIImage(named: sportsArray[indexPath.row].0)
        cell.sportTitle.text = sportsArray[indexPath.row].1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: 170, height: 300)
        
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 16
        let totalPadding = spacing * (numberOfColumns + 1)
        
        let availableWidth = collectionView.bounds.width - totalPadding
        let cellWidth = availableWidth / numberOfColumns
        
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            if let titleLabel = header.viewWithTag(100) as? UILabel {
                        titleLabel.text = "Choose Your Sport"
                        titleLabel.textColor = .black
                    }
            return header
        }
        return UICollectionReusableView()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sportEndpoint = presenter?.getEndpoint(at: indexPath.row) ?? ""
        let leagueVC = storyboard?.instantiateViewController(withIdentifier: "LeagueTableViewController") as? LeagueTableViewController
        print("sport endpoint: \(sportEndpoint)")
        let leaguePresenter = LeaguePresenter(view: leagueVC, sportEndpointName: sportEndpoint)
        leagueVC?.presenter = leaguePresenter
        navigationController?.pushViewController(leagueVC!, animated: true)
    }
}
