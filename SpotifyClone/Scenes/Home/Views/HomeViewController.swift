//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import UIKit

protocol AnyHomeView: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    
    func shouldUpdateSnapshot()
}

class HomeViewController: UICollectionViewController {
    var presenter: AnyHomePresenter?
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeRouter.createModule(for: self)
        presenter?.viewDidLoad()
        
        collectionView.collectionViewLayout = createCompositionalLayout()
        dataSource = DataSource(collectionView: collectionView, cellProvider: cellProviderHandler)
        dataSource.supplementaryViewProvider = supplementaryViewProviderHander
        
        registerCells()
        updateSnapshot()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let section = self?.presenter?.sections[sectionIndex] else { fatalError() }
            
            switch section.category {
            case .header:
                return self?.createHomeHeaderLayoutSection(using: section)
            case .recentlyPlayed:
                return self?.createRecentlyPlayedLayoutSection(using: section)
            case .topItems:
                return self?.createUserTopLayoutSection(using: section)
            default:
                return self?.createGenericLayoutSection(using: section)
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 24.0
        layout.configuration = configuration
        
        return layout
    }
    
    func registerCells() {
        let genericSectionHeaderNib = UINib(nibName: GenericSectionHeader.reuseIdentifier, bundle: nil)
        collectionView.register(genericSectionHeaderNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GenericSectionHeader.reuseIdentifier)
        
        let relatedSectionHeaderNib = UINib(nibName: RelatedSectionHeader.reuseIdentifier, bundle: nil)
        collectionView.register(relatedSectionHeaderNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RelatedSectionHeader.reuseIdentifier)
        
        let homeHeaderCellNib = UINib(nibName: HomeHeaderCell.reuseIdentifier, bundle: nil)
        collectionView.register(homeHeaderCellNib, forCellWithReuseIdentifier: HomeHeaderCell.reuseIdentifier)
        
        let recentlyPlayedTrackCellNib = UINib(nibName: RecentlyPlayedTrackCell.reuseIdentifier, bundle: nil)
        collectionView.register(recentlyPlayedTrackCellNib, forCellWithReuseIdentifier: RecentlyPlayedTrackCell.reuseIdentifier)
        
        let userTopItemCellNib = UINib(nibName: UserTopItemCell.reuseIdentifier, bundle: nil)
        collectionView.register(userTopItemCellNib, forCellWithReuseIdentifier: UserTopItemCell.reuseIdentifier)
        
        let genericItemCellNib = UINib(nibName: GenericItemCell.reuseIdentifier, bundle: nil)
        collectionView.register(genericItemCellNib, forCellWithReuseIdentifier: GenericItemCell.reuseIdentifier)
    }
    
    func updateSnapshot() {
        guard let sections = presenter?.sections else { return }
        
        var snapshot = Snapshot()
        snapshot.appendSections(sections.map({ $0.id }))
        
        for section in sections {
            snapshot.appendItems(section.items.map { $0.uuid }, toSection: section.id)
        }
        
        dataSource.apply(snapshot)
    }
    
    func configureCell<T: SelfConfiguringHomeCell>(_ type: T.Type, for indexPath: IndexPath, with itemIdentifier: String) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        let content = item(for: itemIdentifier, in: indexPath.section)
        
        switch content.type {
        case "header_item":
            guard let content = content as? HomeHeaderItem else {
                fatalError()
            }
            
            cell.configure(with: content)
            return cell
        case "album":
            guard let content = content as? Album else {
                fatalError()
            }
            
            cell.configure(with: content)
            return cell
        case "artist":
            guard let content = content as? Artist else {
                fatalError()
            }
            
            cell.configure(with: content)
            return cell
        default:
            fatalError()
        }
    }
    
    func createHomeHeaderLayoutSection(using homeSection: HomeSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(125.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        
        return section
    }
    
    func createRecentlyPlayedLayoutSection(using homeSection: HomeSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4.0, leading: 4.0, bottom: 4.0, trailing: 4.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 12.0, bottom: 0.0, trailing: 12.0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createUserTopLayoutSection(using homeSection: HomeSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 16.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(115.0), heightDimension: .estimated(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 0.0)
        section.orthogonalScrollingBehavior = .continuous
        
        if homeSection.relatedTo != nil {
            section.boundarySupplementaryItems = [createRelatedSectionHeader()]
        } else {
            section.boundarySupplementaryItems = [createGenericSectionHeader()]
        }
        
        return section
    }
    
    func createGenericLayoutSection(using homeSection: HomeSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 16.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150.0), heightDimension: .estimated(190.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 0.0)
        section.orthogonalScrollingBehavior = .continuous
        
        if homeSection.relatedTo != nil {
            section.boundarySupplementaryItems = [createRelatedSectionHeader()]
        } else {
            section.boundarySupplementaryItems = [createGenericSectionHeader()]
        }
        
        return section
    }
    
    func createGenericSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
    
    func createRelatedSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(82.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArtistViewController(nibName: "ArtistViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: AnyHomeView {
    func shouldUpdateSnapshot() {
        updateSnapshot()
    }
}
