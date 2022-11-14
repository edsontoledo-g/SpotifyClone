//
//  HomeViewController+DataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

extension HomeViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection.ID, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeSection.ID, String>
    
    func cellProviderHandler(collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) -> UICollectionViewCell? {
        guard let section = presenter?.sections[indexPath.section] else { return nil }
        
        switch section.category {
        case .header:
            let cell = self.configureCell(HomeHeaderCell.self, for: indexPath, with: itemIdentifier)
            cell.didPressPreferencesButton = { [weak self] in
                self?.presenter?.didPressPreferencesButton()
            }
            return cell
        case .recentlyPlayed:
            let cell = self.configureCell(RecentlyPlayedTrackCell.self, for: indexPath, with: itemIdentifier)
            return cell
        case .topItems:
            let cell = self.configureCell(UserTopItemCell.self, for: indexPath, with: itemIdentifier)
            return cell
        case .relatedArtists:
            let cell = self.configureCell(GenericItemCell.self, for: indexPath, with: itemIdentifier)
            return cell
        default:
            let cell = self.configureCell(GenericItemCell.self, for: indexPath, with: itemIdentifier)
            return cell
        }
    }
    
    func supplementaryViewProviderHander(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        guard let sectionId = dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier) else { return nil }
        let section = section(for: sectionId)
        
        if let content = section.relatedTo {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RelatedSectionHeader.reuseIdentifier, for: indexPath) as? RelatedSectionHeader else {
                return nil
            }
            sectionHeader.configure(with: content)
            return sectionHeader
        } else {
            guard
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GenericSectionHeader.reuseIdentifier, for: indexPath) as? GenericSectionHeader,
                let title = section.title
            else {
                return nil
            }
            sectionHeader.configure(with: title)
            return sectionHeader
        }
    }
    
    func item(for itemIdentifier: String, in sectionIndex: Int) -> AnySpotifyContent {
        guard let item = presenter?.sections[sectionIndex].items.first(where: { $0.uuid == itemIdentifier }) else {
            fatalError()
        }
        
        return item
    }
    
    func section(for sectionId: HomeSection.ID) -> HomeSection {
        guard let section = presenter?.sections.first(where: { $0.id == sectionId }) else {
            fatalError()
        }
        
        return section
    }
}
