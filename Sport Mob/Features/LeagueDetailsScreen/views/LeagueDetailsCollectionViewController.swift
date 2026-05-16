//
//  LeagueDetailsCollectionViewController.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import UIKit
import SDWebImage

protocol LeagueDetailsProtocol : AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func setupTennisView()
    func showOfflineAlert()
}



class LeagueDetailsCollectionViewController:
    UICollectionViewController , LeagueDetailsProtocol {
    var isLoading = true
    var leagueDetailsPresenter : LeagueDetailsPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier)
        
        let layout = UICollectionViewCompositionalLayout{ index , enviornement in
            if index == 0 {
                return self.setupNextMatchsSection()
            }else if index == 1 {
                return self.setupLatestMatchesSection()
            }
            return self.setupLeagueTeams()
            
            
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
       
        Task {
            await leagueDetailsPresenter?.fetchLeagueDetails()
        }
    }
    
    
    func setupTennisView() {
        let emptyView = UIView(frame: self.collectionView.bounds)
        
        let imageView = UIImageView()
        imageView.image = UIImage.noFav
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        let titleLabel = UILabel()
        titleLabel.text = LocalizationKey.noTennisTeams.localized
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
        
        self.collectionView.backgroundView = emptyView
        
        
    }
    
    func showLoading() {
       isLoading = true
    }
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func hideLoading() {
       isLoading = false
    }
    
    func showError(message: String) {
        showAlert(title: LocalizationKey.errorTitle.localized, message: message)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showOfflineAlert() {
        showAlert(title: LocalizationKey.offlineTitle.localized, message: LocalizationKey.offlineMessage.localized)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    func setupNextMatchsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1) , heightDimension:.fractionalHeight(1) )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 16, bottom: 5, trailing: 8)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        
        return section
    }
    
    
    func setupLatestMatchesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 15, trailing: 16)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        return section
    }
    
    
    func setupLeagueTeams() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1) , heightDimension:.fractionalHeight(1) )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 8, bottom: 5, trailing: 5)
        
        section.boundarySupplementaryItems = [createHeaderLayout()]
        return section
    }
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLoading {
                    return 3
                }
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0 : return leagueDetailsPresenter?.getItemsCount(for: 0) ?? 0
        case 1 : return leagueDetailsPresenter?.getItemsCount(for: 1) ?? 0
        case 2 : return leagueDetailsPresenter?.getItemsCount(for: 2) ?? 0
        default : return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
                    
                    let cellIdentifier = indexPath.section == 0 ? "nextMatchesCell" : (indexPath.section == 1 ? "latestMatchesCell" : "leagueTeamsCell")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                    cell.startShimmering()
                    return cell
                }
        switch  indexPath.section {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nextMatchesCell", for: indexPath) as! NextMatchesCollectionViewCell
            cell.stopShimmering()
            let nextMatch = leagueDetailsPresenter?.getMatch(at : indexPath.row, for : 0)
            cell.firstTeamName.text = nextMatch?.HomeTeamName
            cell.secondTeamName.text = nextMatch?.AwayTeamName
            cell.matchDate.text = nextMatch?.eventDate
            cell.matchTime.text = nextMatch?.eventTime
            if let firstTeamLogo = nextMatch?.homeTeamLogo, let url = URL(string: firstTeamLogo) {
                cell.firstTeamImage.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
            } else {
                cell.firstTeamImage.image = UIImage.undifinedTeam
            }
            if let secondTeamLogo = nextMatch?.awayTeamLogo, let url = URL(string: secondTeamLogo) {
                cell.secondTeamImage.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
            } else {
                cell.secondTeamImage.image = UIImage.undifinedTeam
            }
            return cell
            
        case 1 :
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestMatchesCell", for: indexPath) as! LatestMatchesCollectionViewCell
            cell.stopShimmering()
            let lastMatch = leagueDetailsPresenter?.getMatch(at : indexPath.row, for : 1)
            
            cell.firstTeamName.text = lastMatch?.HomeTeamName
            cell.secondTeamName.text = lastMatch?.AwayTeamName
            cell.matchResult.text = lastMatch?.eventFinalResult
            if let firstTeamLogo = lastMatch?.homeTeamLogo, let url = URL(string: firstTeamLogo) {
                cell.firstTeamImage.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
            } else {
                cell.firstTeamImage.image = UIImage.undifinedTeam
            }
            if let secondTeamLogo = lastMatch?.awayTeamLogo, let url = URL(string: secondTeamLogo) {
                cell.secondTeamImage.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
            } else {
                cell.secondTeamImage.image = UIImage.undifinedTeam
            }
            
            return cell
            
            
        case 2 :
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueTeamsCell", for: indexPath) as! LeagueTeamsCollectionViewCell
            cell.stopShimmering()
            let Team = leagueDetailsPresenter?.getTeam(at: indexPath.row)
            if Team?.teamName == "Brighton & Hove Albion"{
                cell.teamName.text = "Brighton"
            }else if Team?.teamName == "Wolverhampton Wanderers" {
                cell.teamName.text = "Wolves"
            }else {
                if let teamName = Team?.teamName {
                    cell.teamName.text = teamName
                }else{
                    cell.teamName.text = "Unknown Team"
                }
            }
            if let TeamLogo = Team?.teamLogo, let url = URL(string: TeamLogo) {
                cell.teamImage.sd_setImage(with: url, placeholderImage: UIImage.undifinedTeam)
            } else {
                cell.teamImage.image = UIImage.undifinedTeam
            }
            
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueTeamsCell", for: indexPath) as! LeagueTeamsCollectionViewCell
            
            return cell
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && leagueDetailsPresenter?.isFootball() == true {
            
            let teamDetailsVc = storyboard?.instantiateViewController(identifier: "TeamDetailsViewController") as? TeamDetailsViewController
            teamDetailsVc?.presenter =
            TeamDetailsPresenter(
                teamId: String(leagueDetailsPresenter?.getTeam(at: indexPath.row)?.teamKey ?? 0),
                view: teamDetailsVc
            )
            let backButton = UIBarButtonItem()
            backButton.tintColor = .primary
            self.navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(teamDetailsVc!, animated: true)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath) as! SectionHeader

       
        switch indexPath.section {
        case 0: header.titleLabel.text = "Upcoming Matches"
        case 1: header.titleLabel.text = "Latest Results"
        case 2: header.titleLabel.text = "Teams"
        default: header.titleLabel.text = ""
        }
        
        return header
    }
    
    func createHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
