//
//  Model.swift
//  
//
//  Created by Arman Davidoff on 23.03.2020.
//

import Foundation
import UIKit


struct SearchTracksResponse: Decodable {
    var resultCount: Int
    var results: [SearchTrack]
}

struct SearchTrack: Decodable {
    var trackName: String?
    var artistName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
    var trackTimeMillis: Int
}
