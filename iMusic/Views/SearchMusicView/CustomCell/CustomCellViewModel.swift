//
//  CustomCellViewModel.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation

class CustomCellViewModel {
    
    private var track: SearchTracksViewModel.SearchTrackModelForCell?
    
    func addToFavourite() {
        guard let track = self.track else { return }
        UserFavoritesTracks.shared.addToFavourite(model: track)
    }
    
    func setup(track: SearchTrackCellModelType) {
        self.track = track as? SearchTracksViewModel.SearchTrackModelForCell
    }
}
