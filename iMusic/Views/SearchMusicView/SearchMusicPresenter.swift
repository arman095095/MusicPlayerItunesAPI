//
//  SearchMusicPresenter.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright (c) 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import Foundation

class SearchMusicPresenter: SearchMusicPresentationLogic {
    weak var viewController: SearchMusicDisplayLogic?
    
    func presentData(response: SearchMusic.Model.Response.ResponseType) {
        switch response {
        case .presentSearchTracksResponse(let searchTracksResponse):
            let searchTrackModels = convert(trackResponse: searchTracksResponse?.results)
            viewController?.displayData(viewModel: .displaySearchTrackModelsForCells(searchTrackModelForCell: searchTrackModels))
        }
    }
    
    private func convert(trackResponse: [SearchTrack]?) -> [SearchTracksViewModel.SearchTrackModelForCell] {
        guard let trackResponse = trackResponse else { return [] }
        return trackResponse.map {
            SearchTracksViewModel.SearchTrackModelForCell(trackName: $0.trackName,
                                                    artistName: $0.artistName,
                                                    iconURL: $0.artworkUrl100,
                                                    albumName: $0.collectionName,
                                                    previewUrl: $0.previewUrl ) }
    }
}
