//
//  ShowUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

struct ShowUi: Equatable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var thriller: AnyShowItemUi = AnyShowItemUi()
    var showSectionsUi: [ShowSectionUi] = []
}

struct ShowSectionUi: Identifiable, Equatable, Hashable {
    var id: Int
    var title: String?
    var items: [AnyShowItemUi]
    var type: SectionType
    
    enum SectionType {
        case episodes
    }
}

struct AnyShowItemUi: Identifiable, Equatable, Hashable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var description: String = ""
    var releaseDate: String = ""
    var durationTime: String = ""
}

extension ShowUi {
    
    func hasLoaded() -> Bool {
        !showSectionsUi.isEmpty
    }
}

extension ShowSectionUi {
    
    #if DEBUG
    static let sampleData = ShowSectionUi(
        id: 0,
        title: "All episodes",
        items: [
            AnyShowItemUi(
                id: "3lZ7xL4ZNlHoXEosDw15yj",
                name: "New to Night Vale? Start here!",
                image: "https://i.scdn.co/image/b9e486b756ad8a7027bdb304ad24fdfa7de28fea",
                description: "We know that over 100 episodes can seem a little intimidating, so here's a short introduction to the show and some suggestions on getting into it.   For a text version of this guide, and a list of some of our favorite episodes, head over here: welcometonightvale.com/listen",
                releaseDate: "2012-06-01",
                durationTime: "28 min 42 sec"
            ),
            AnyShowItemUi(
                id: "6zs79bz9Nb0lXhoHtGDudJ",
                name: "1 - Pilot",
                image: "https://i.scdn.co/image/b9e486b756ad8a7027bdb304ad24fdfa7de28fea",
                description: "Pilot Episode. A new dog park opens in Night Vale. Carlos, a scientist, visits and discovers some interesting things. Seismic things. Plus, a helpful guide to surveillance helicopter-spotting.  Weather: \"These and More Than These\" by Joseph Fink  Music: Disparition, disparition.info  Logo: Rob Wilson, silastom.com  Produced by Night Vale Presents. Written by Joseph Fink and Jeffrey Cranor. Narrated by Cecil Baldwin. More Info: welcometonightvale.com, and follow @NightValeRadio on Twitter or Facebook.",
                releaseDate: "2012-06-15",
                durationTime: "36 min 09 sec"
            ),
            AnyShowItemUi(
                id: "0hbAUeRZNeJwWCJ4hO9cYN",
                name: "2 - Glow Cloud",
                image: "https://i.scdn.co/image/b9e486b756ad8a7027bdb304ad24fdfa7de28fea",
                description: "A mysterious, glowing cloud makes its way across Night Vale. Plus, new Boy Scouts hierarchy, community events calendar, and a PTA bake sale for a great cause!  Weather: \"The Bus is Late\" by Satellite High, satellite-high.com  Music: Disparition, disparition.info  Logo: Rob Wilson, silastom.com  Produced by Night Vale Presents. Written by Joseph Fink and Jeffrey Cranor. Narrated by Cecil Baldwin. More Info: welcometonightvale.com, and follow @NightValeRadio on Twitter or Facebook.",
                releaseDate: "2012-07-01",
                durationTime: "32 min 22 sec"
            ),
        ],
        type: .episodes
    )
    #endif
}
