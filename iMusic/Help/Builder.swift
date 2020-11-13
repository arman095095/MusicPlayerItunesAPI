//
//  Builder.swift
//  iMusic
//
//  Created by Arman Davidoff on 10.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import SwiftUI

class Builder {

    static func createMainWindowIOS13(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
        return window
    }
    
    static func createMusicPlayerView(closeOpen: CloseAndOpenDelegate, delegate: MusicPlayerDelegate) -> MusicPlayer {
        let musicPlayerView : MusicPlayer = MusicPlayer.loadFromNib()
        musicPlayerView.viewModel.delegate = delegate
        musicPlayerView.closeDelegate = closeOpen
        musicPlayerView.translatesAutoresizingMaskIntoConstraints = false
        return musicPlayerView
    }
    
    static func createSearchVC(closeOpen: CloseAndOpenDelegate) -> SearchMusicViewController {
        let vc = SearchMusicViewController()
        vc.navigationItem.title = "Search"
        vc.openDelegate = closeOpen
        return vc
    }
    
    static func createNavVC(root: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: root)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.tabBarItem.title = "Search"
        navVC.tabBarItem.image = #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon")
        return navVC
    }
    
    static func createHostVC(closeOpen: CloseAndOpenDelegate) -> UIHostingController<Library> {
        let library = Library()
        library.viewModel.openTrackDelegate = closeOpen
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        hostVC.tabBarItem.title = "Library"
        return hostVC
    }
}
