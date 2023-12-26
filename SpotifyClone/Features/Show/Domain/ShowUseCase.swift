//
//  ShowUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

class ShowUseCase {
    
    private let showRepository: ShowRepository
    
    init(showRepository: ShowRepository) {
        self.showRepository = showRepository
    }
    
    func fetchShow(accessToken: String, id: String) async throws -> Show {
        try await showRepository.fetchShow(accessToken: accessToken, id: id)
    }
    
    func fetchSeveralShows(accessToken: String, ids: [String]) async throws -> [Show] {
        try await showRepository.fetchSeveralShows(accessToken: accessToken, ids: ids).shows
    }
}
