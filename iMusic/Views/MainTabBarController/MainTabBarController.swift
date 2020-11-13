//
//  ContentView.swift
//  CanvasTemplate
//
//  Created by Arman Davidoff on 19.02.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import SwiftUI

protocol CloseAndOpenDelegate:class {
    func animateClose()
    func animateOpen(model:TrackModelForPlayerView?)
}

class MainTabBarController: UITabBarController, MainTabDelegate {
    
    var searchMusicVC: SearchMusicViewController!
    var hostVC: UIHostingController<Library>!
    var musicPlayerView : MusicPlayer!
    
    var maxTopConstreint: NSLayoutConstraint!
    var minTopConstreint: NSLayoutConstraint!
    var buttonConstreint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        setupViews()
        setupMusicPlayerView()
        viewControllers = [Builder.createNavVC(root: searchMusicVC),
                           hostVC]
    }
    
    private func initializeViews() {
        hostVC = Builder.createHostVC(closeOpen: self)
        searchMusicVC = Builder.createSearchVC(closeOpen: self)
        musicPlayerView = Builder.createMusicPlayerView(closeOpen: self, delegate: searchMusicVC)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
    }
    
    
    func setupMusicPlayerView() {
        self.view.insertSubview(musicPlayerView, belowSubview: tabBar)
        
        maxTopConstreint = musicPlayerView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: view.frame.height)
        minTopConstreint = musicPlayerView.topAnchor.constraint(equalTo: self.tabBar.topAnchor,constant: -64)
        buttonConstreint = musicPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.frame.height)
        
        buttonConstreint.isActive = true
        maxTopConstreint.isActive = true
        
        musicPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        musicPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
    }
    
}





