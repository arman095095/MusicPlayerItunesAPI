//
//  MainTabBarController Extension.swift
//  iMusic
//
//  Created by Arman Davidoff on 10.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit

//Анимированное открытие и закрытие MusicPlayerView
extension MainTabBarController: CloseAndOpenDelegate {
    
    func animateOpen(model:TrackModelForPlayerView?) {
        minTopConstreint.isActive = false
        maxTopConstreint.isActive = true
        maxTopConstreint.constant = 0
        buttonConstreint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.musicPlayerView.mainStackView.alpha = 1
            self.musicPlayerView.miniView.alpha = 0
        }, completion: nil)
        musicPlayerView.setupViewModel(track: model)
    }
    
    func animateClose() {
        maxTopConstreint.isActive = false
        buttonConstreint.constant = self.view.frame.height
        minTopConstreint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.musicPlayerView.mainStackView.alpha = 0
            self.musicPlayerView.miniView.alpha = 1
        }, completion: nil)
    }
}
