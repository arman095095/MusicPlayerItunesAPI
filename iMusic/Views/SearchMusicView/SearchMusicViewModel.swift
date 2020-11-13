//
//  SearchMusicModels.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright (c) 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import AVKit
import SwiftUI

class SearchTracksViewModel:NSObject, NSCoding {
    
    private var cells = [SearchTrackModelForCell]()
    
    init(cells:[SearchTrackModelForCell]) {
        self.cells = cells
    }
    
    func getCellModel(at indexPath: IndexPath) -> SearchTrackCellModelType {
        return cells[indexPath.row]
    }
    
    func getPlayerViewModel(at indexPath: IndexPath) -> TrackModelForPlayerView {
        return cells[indexPath.row]
    }
    
    func updateCellModels(models: [SearchTrackModelForCell]) {
        self.cells = models
    }
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [SearchTrackModelForCell] ?? []
    }
    
    @objc(_TtCC6iMusic18SearchTracksModels23SearchTrackModelForCell)class SearchTrackModelForCell: NSObject, TrackModelForPlayerView, SearchTrackCellModelType, NSCoding, Identifiable {
        
        var id = UUID()
        var trackName: String?
        var artistName: String?
        var iconURL: String?
        var albumName: String?
        var previewUrl: String?
        var imageURL: URL? {
            URL(string: iconURL ?? "")
        }
        var favourite: Bool {
            UserFavoritesTracks.shared.containsInFavouritesList(track: self)
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(trackName, forKey: "trackName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(iconURL, forKey: "iconURL")
            coder.encode(albumName, forKey: "albumName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        required init?(coder: NSCoder) {
            trackName = coder.decodeObject(forKey: "trackName") as? String? ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String? ?? ""
            iconURL = coder.decodeObject(forKey: "iconURL") as? String? ?? ""
            albumName = coder.decodeObject(forKey: "albumName") as? String? ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
        }
        
        init(trackName: String?,artistName: String?,iconURL: String?,albumName: String?,previewUrl: String?) {
            self.trackName = trackName
            self.artistName = artistName
            self.iconURL = iconURL
            self.albumName = albumName
            self.previewUrl = previewUrl
        }
    }
    
}
