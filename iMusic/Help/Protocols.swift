//
//  Protocol.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation

protocol SearchMusicDisplayLogic: class {
    func displayData(viewModel: SearchMusic.Model.ViewModel.ViewModelData)
}

protocol MainTabDelegate: class {
    func setupMusicPlayerView()
}

protocol SearchMusicBusinessLogic {
    func makeRequest(request: SearchMusic.Model.Request.RequestType)
}

protocol SearchMusicPresentationLogic {
    func presentData(response: SearchMusic.Model.Response.ResponseType)
}

protocol TrackModelForPlayerView {
    var trackName: String? { get }
    var artistName: String? { get }
    var iconURL: String? { get }
    var previewUrl: String? { get }
}

protocol MusicPlayerDelegate {
    func nextTrack() -> TrackModelForPlayerView?
    func backTrack() -> TrackModelForPlayerView?
}

protocol SearchTrackCellModelType {
    var trackName: String? { get }
    var artistName: String? { get }
    var albumName: String? { get }
    var imageURL: URL? { get }
    var favourite: Bool { get }
}
