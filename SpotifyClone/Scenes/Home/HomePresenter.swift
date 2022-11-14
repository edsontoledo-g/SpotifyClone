//
//  HomePresenter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyHomePresenter: AnyObject {
    var view: AnyHomeView? { get set }
    var interactor: AnyHomeInputInteractor? { get set }
    var router: AnyHomeRouter? { get set }
    
    var userProfile: UserProfile? { get set }
    var sections: [HomeSection] { get set }
    
    func viewDidLoad()
    func didPressPreferencesButton()
}

class HomePresenter: AnyHomePresenter {
    var view: AnyHomeView?
    var interactor: AnyHomeInputInteractor?
    var router: AnyHomeRouter?
    
    var userProfile: UserProfile?
    var sections: [HomeSection] = []
    
    func viewDidLoad() {
        Task {
            await interactor?.getUserProfile()
        }
    }
    
    func didPressPreferencesButton() {
        if let view = view, let userProfile = userProfile {
            router?.presentPreferences(on: view, for: userProfile)
        }
    }
}

extension HomePresenter: AnyHomeOuputInteractor {
    func didFinishGettingUserProfile(result: Result<UserProfile, APICaller.NetworkError>) {
        switch result {
        case .success(let userProfile):
            self.userProfile = userProfile
            sections.append(HomeSection(
                id: 1,
                category: .header,
                items: [HomeHeaderItem(userName: userProfile.display_name.components(separatedBy: " ")[0])]
            ))
            view?.shouldUpdateSnapshot()
            
            Task {
                await interactor?.getRecenlyPlayedTracks()
                await interactor?.getUserTopItems()
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func didFinishGettingRecentlyPlayedTracks(result: Result<[Track], APICaller.NetworkError>) {
        switch result {
        case .success(let tracks):
            Task {
                await interactor?.treatRecentlyPlayedTracks(tracks)
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func didFinishTreatingRecentlyplayedTracks(result: ([Artist], [Album])) {
        sections.append(HomeSection(
            id: 2,
            category: .recentlyPlayed,
            items: result.0.prefix(3).shuffled() + result.1.prefix(3).shuffled()
        ))
        view?.shouldUpdateSnapshot()
    }
    
    func didFinishGettingUserTopItems(result: Result<([Artist], [Track]), APICaller.NetworkError>) {
        switch result {
        case .success(let (artists, tracks)):
            interactor?.treatRecentlyTopItems(tracks: tracks, artists: artists)
            
            Task {
                await interactor?.getRecommendations(
                    seedArtist: artists.map { $0.id }.first ?? "",
                    seedGenre: artists.compactMap { $0.genres }.reduce([], +).first ?? "",
                    seedTrack: artists.map { $0.id }.first ?? ""
                )
                if let artist = artists.first {
                    await interactor?.getRelatedArtists(for: artist)
                }
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func didFinishTreatingTopItems(result: ([Artist], [Album])) {
        sections.append(HomeSection(
            id: 3,
            title: "Your top",
            category: .topItems,
            items: (result.0.prefix(6).shuffled() + result.1.prefix(6).shuffled()).shuffled()
        ))
        view?.shouldUpdateSnapshot()
    }
    
    func didFinishGettingRecomendations(result: Result<[Track], APICaller.NetworkError>) {
        switch result {
        case .success(let tracks):
            Task {
                await interactor?.treatRecommendations(tracks: tracks)
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func didFinishTreatingRecommendations(result: ([Artist], [Album])) {
        sections.append(HomeSection(
            id: 4,
            title: "Recommendations",
            category: .recommendations,
            items: (result.0.prefix(6).shuffled() + result.1.prefix(6).shuffled()).shuffled()
        ))
        view?.shouldUpdateSnapshot()
    }
    
    func didFinishGettingRelatedArtists(result: Result<(Artist, [Artist]), APICaller.NetworkError>) {
        switch result {
        case .success(let (artist, artists)):
            sections.append(HomeSection(
                id: 5,
                title: "Similars to",
                category: .relatedArtists,
                items: artists,
                relatedTo: artist
            ))
            view?.shouldUpdateSnapshot()
        case .failure(let error):
            print(error)
        }
    }
}
