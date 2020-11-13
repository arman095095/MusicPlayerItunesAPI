//
//  Networking.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation
import Alamofire

class NetworkDataFetcher {
    
    enum ITunesAPI: String {
        case searchURL = "https://itunes.apple.com/search"
        func paramsForMusicSearch(_ searchText: String) -> [String:String] {
            return ["term":searchText,"limit":"20","media":"music"]
        }
    }
    
    var currentSearchText: String?
    
    func getSearchTracks(searchText:String,complition: @escaping (SearchTracksResponse?) -> Void) {
        self.currentSearchText = searchText
        let url = ITunesAPI.searchURL.rawValue
        let params = ITunesAPI.searchURL.paramsForMusicSearch(searchText)
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default).validate().responseDecodable(of: SearchTracksResponse.self) { [weak self] (response) in
            
            guard let currentSearchText = self?.currentSearchText else { return }
            if currentSearchText != searchText { return }
            
            switch response.result {
            case .success(let model):
                complition(model)
            case .failure(let error):
                print(error.localizedDescription)
                complition(nil)
            }
        }
    }
    
}
