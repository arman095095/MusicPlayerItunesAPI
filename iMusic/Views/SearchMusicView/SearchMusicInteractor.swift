//
//  SearchMusicInteractor.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright (c) 2020 Arman Davidoff. All rights reserved.
//

import UIKit

class SearchMusicInteractor: SearchMusicBusinessLogic {
    
    var presenter: SearchMusicPresentationLogic?
    var network = NetworkDataFetcher()
    
    func makeRequest(request: SearchMusic.Model.Request.RequestType) {
        
        switch request {
        case .getSearchTracks(let searchText):
            network.getSearchTracks(searchText: searchText) {[weak self] (tracksResponse) in
                self?.presenter?.presentData(response: .presentSearchTracksResponse(searchTracksResponse: tracksResponse))
            }
        }
    }
    
}
