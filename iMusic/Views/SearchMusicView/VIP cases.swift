//
//  VIP cases.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation

enum SearchMusic {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getSearchTracks(searchText:String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentSearchTracksResponse(searchTracksResponse:SearchTracksResponse?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displaySearchTrackModelsForCells(searchTrackModelForCell:[SearchTracksViewModel.SearchTrackModelForCell])
            }
        }
    }
}
