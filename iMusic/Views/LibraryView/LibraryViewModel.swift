//
//  LibraryViewModel.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import SwiftUI

class LibraryViewModel: ObservableObject {
    
    var openTrackDelegate: CloseAndOpenDelegate?
    @Published var tracks: [SearchTracksViewModel.SearchTrackModelForCell]
    
    init() {
        self.tracks = UserFavoritesTracks.shared.getFavoritesTracks()
    }
    
    var deletedTrack: SearchTracksViewModel.SearchTrackModelForCell!
    var selectedTrack: SearchTracksViewModel.SearchTrackModelForCell!
    
    func delete(indexSet:IndexSet) {
        self.tracks = UserFavoritesTracks.shared.deleteFromFavourites(indexSet: indexSet)
    }
    func delete(track:SearchTracksViewModel.SearchTrackModelForCell) {
        self.tracks = UserFavoritesTracks.shared.deleteFromFavourites(favoriteModel: self.deletedTrack)
    }
    func playFirstTrack() {
        self.changeDelegateForMusicPlayer()
        self.selectedTrack = self.tracks.first
        guard let delegate = self.openTrackDelegate,let firstTrack = tracks.first else { return }
        delegate.animateOpen(model: firstTrack)
    }
    func updatePlayList() {
        self.tracks = UserFavoritesTracks.shared.getFavoritesTracks()
    }
    func changeDelegateForMusicPlayer() {
        guard let mainTabBar = UIApplication.getKeyWindow()?.rootViewController as? MainTabBarController else { return }
        mainTabBar.musicPlayerView.viewModel.delegate = self
    }
}

//MARK:- MusicPlayerDelegate
extension LibraryViewModel: MusicPlayerDelegate {
    func nextTrack() -> TrackModelForPlayerView? {
        guard let firstIndex = tracks.firstIndex(where: { (track) -> Bool in
            return track.trackName == selectedTrack.trackName && track.albumName == selectedTrack.albumName && track.artistName == selectedTrack.artistName && track.previewUrl == selectedTrack.previewUrl && track.iconURL == selectedTrack.iconURL
        }) else {
            print("error")
            return nil }
        if firstIndex == tracks.count - 1 {
            self.selectedTrack = tracks[0]
            return tracks[0]
        } else {
            self.selectedTrack = tracks[firstIndex + 1]
            return tracks[firstIndex + 1]
        }
    }
    
    func backTrack() -> TrackModelForPlayerView? {
        guard let firstIndex = tracks.firstIndex(of: selectedTrack) else {
            print("error")
            return nil }
        if firstIndex == 0 {
            self.selectedTrack = tracks[tracks.count - 1]
            return tracks[tracks.count - 1]
        } else {
            self.selectedTrack = tracks[firstIndex - 1]
            return tracks[firstIndex - 1]
        }
    }
}
