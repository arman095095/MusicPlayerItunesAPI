//
//  UserDefaults.swift
//  iMusic
//
//  Created by Arman Davidoff on 27.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class UserFavoritesTracks {
    static let shared = UserFavoritesTracks()
    let key = "Favorites"
    
    private init() { }
    
    func addToFavourite(model: SearchTracksViewModel.SearchTrackModelForCell) {
        var tracks = getFavoritesTracks()
        tracks.append(model)
        saveToFavorite(favoriteModels: tracks)
    }
    
    private func saveToFavorite(favoriteModels:[SearchTracksViewModel.SearchTrackModelForCell]) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: favoriteModels, requiringSecureCoding: false) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getFavoritesTracks() -> [SearchTracksViewModel.SearchTrackModelForCell]  {
        guard let favoritesTrackData = UserDefaults.standard.object(forKey: key) as? Data else { return [] }
        guard let favouritesTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(favoritesTrackData) as? [SearchTracksViewModel.SearchTrackModelForCell] else { return [] }
        return favouritesTracks
    }
    
    func deleteFromFavourites(favoriteModel:SearchTracksViewModel.SearchTrackModelForCell) -> [SearchTracksViewModel.SearchTrackModelForCell] {
        var favoritesTracks = getFavoritesTracks()
        guard let firstIndex = favoritesTracks.firstIndex(where: { (track) -> Bool in
            return track.trackName == favoriteModel.trackName && track.albumName == favoriteModel.albumName && track.artistName == favoriteModel.artistName && track.previewUrl == favoriteModel.previewUrl && track.iconURL == favoriteModel.iconURL
        }) else { return [] }
        favoritesTracks.remove(at: firstIndex)
        saveToFavorite(favoriteModels: favoritesTracks)
        return favoritesTracks
    }
    
    func deleteFromFavourites(indexSet:IndexSet) -> [SearchTracksViewModel.SearchTrackModelForCell] {
        var favoritesTracks = getFavoritesTracks()
        favoritesTracks.remove(atOffsets: indexSet)
        saveToFavorite(favoriteModels: favoritesTracks)
        return favoritesTracks
    }
    
    func containsInFavouritesList(track:SearchTracksViewModel.SearchTrackModelForCell) -> Bool {
        let favouritesTracks = getFavoritesTracks()
        return favouritesTracks.firstIndex(where: { (Track) -> Bool in
            return Track.albumName == track.albumName && Track.trackName == track.trackName && Track.previewUrl == track.previewUrl && Track.iconURL == track.iconURL && Track.artistName == track.artistName
        }) != nil
    }
}
