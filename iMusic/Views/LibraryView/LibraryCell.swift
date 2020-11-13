//
//  LibraryCell.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import SwiftUI
import URLImage

struct Cell: View {
    var track: SearchTracksViewModel.SearchTrackModelForCell
    var body: some View {
        HStack {
            URLImage(URL(string: self.track.iconURL ?? "--")!) { proxy in
                proxy.image.resizable()
            }.frame(width: 60, height: 60)
            VStack(alignment: .leading,spacing: 5) {
                Text(self.track.trackName ?? "--").lineLimit(1)
                Text(self.track.artistName ?? "--").font(.system(size: 14, weight: .light, design: .default))            }
        }.frame(height: 60)
    }
}
