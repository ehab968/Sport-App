import UIKit
import SDWebImage

class LatestMatchesContainerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "LatestMatchesContainerCell"
    
    var collectionView: UICollectionView!
    var presenter: LeagueDetailsPresenterProtocol?
    weak var parentViewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "LatestMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "latestMatchesCell")
        
        contentView.addSubview(collectionView)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getItemsCount(for: 1) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestMatchesCell", for: indexPath) as! LatestMatchesCollectionViewCell
        
        let lastMatch = presenter?.getMatch(at: indexPath.row, for: 1)
        
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
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}
