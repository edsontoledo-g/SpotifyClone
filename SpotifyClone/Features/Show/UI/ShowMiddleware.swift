//
//  ShowMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation
import UnidirectionalFlow

class ShowMiddleware: Middleware {
    
    private let showUseCase: ShowUseCase
    
    init() {
        showUseCase = ShowInjector.provideShowUseCase()
    }
    
    func process(state: ShowState, with action: ShowAction) async -> ShowAction? {
        switch action {
        case .loadShowDetail(let accessToken, let showId):
            async let showCall = await showUseCase.fetchShow(accessToken: accessToken, id: showId)
            do {
                let (show) = try await (showCall)
                let showUi = handleFetchShowSuccess(show)
                return .setResults(showUi: showUi)
            } catch {
                return nil
            }
        case .setResults:
            return nil
        }
    }
}

extension ShowMiddleware {
    
    private func handleFetchShowSuccess(_ show: Show) -> ShowUi {
        var showUi = show.asShowUi()
        showUi.showSectionsUi.append(
            ShowSectionUi(
                id: 0,
                title: "All episodes",
                items: show.episodes?.asAnyShowItemsUi() ?? [],
                type: .episodes
            )
        )
        return showUi
    }
}
