//
//  CustomCell.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCellForSearchTrack: UITableViewCell {
    
    static let cellId = "customCellForTrack"
    
    var viewModel = CustomCellViewModel()
    
    @IBOutlet weak var iconTrack: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBAction func addAction(_ sender: Any) {
        self.viewModel.addToFavourite()
        addButtonOutlet.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconTrack.image = nil
    }
    
    func config(track:SearchTrackCellModelType) {
        viewModel.setup(track: track)
        addButtonOutlet.isHidden = track.favourite
        trackNameLabel.text = track.trackName ?? "-"
        artistNameLabel.text = track.artistName ?? "-"
        albumNameLabel.text = track.albumName ?? "-"
        iconTrack.sd_setImage(with: track.imageURL, completed: nil)
    }
    
    
}


