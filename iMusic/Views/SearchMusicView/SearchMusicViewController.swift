//
//  SearchMusicViewController.swift
//  iMusic
//
//  Created by Arman Davidoff on 23.03.2020.
//  Copyright (c) 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import SwiftUI
import SDWebImage

class SearchMusicViewController: UIViewController, SearchMusicDisplayLogic {
    
    var interactor: SearchMusicBusinessLogic?
    
    var tableView: UITableView!
    var timer:Timer?
    var searchTrackViewModel = SearchTracksViewModel.init(cells: [])
    var footer = FooterView()
    
    weak var openDelegate: CloseAndOpenDelegate?
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchMusicInteractor()
        let presenter             = SearchMusicPresenter()
        viewController.interactor = interactor
        interactor.presenter      = presenter
        presenter.viewController  = viewController
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        definesPresentationContext = true
        setup()
        setupSearchBar()
        setupTableView()
    }
    
    func displayData(viewModel: SearchMusic.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displaySearchTrackModelsForCells(let searchTrackModelsForCells):
            footer.stop()
            searchTrackViewModel.updateCellModels(models: searchTrackModelsForCells)
            tableView.reloadData()
        }
    }
}

// MARK: UI setup
private extension SearchMusicViewController {
    private func setupSearchBar() {
        let searchContoller = UISearchController(searchResultsController: nil)
        searchContoller.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchContoller
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: CustomCellForSearchTrack.cellId)
        tableView.tableFooterView = footer
    }
}

//TableViewMethods
extension SearchMusicViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTrackViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellForSearchTrack.cellId, for: indexPath) as! CustomCellForSearchTrack
        let model = searchTrackViewModel.getCellModel(at: indexPath)
        cell.config(track: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        if navigationItem.searchController?.searchBar.text == "" {
            view.text = "Введите Ваш поисковый запрос..." } else {
                view.text = "Ничего не найдено..."
            }
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchTrackViewModel.numberOfRows() == 0 ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        let model = searchTrackViewModel.getPlayerViewModel(at: indexPath)
        changeDelegateForMusicPlayer()
        openDelegate?.animateOpen(model: model)
    }
}

//MusicPlayerDelegate Next Previous
extension SearchMusicViewController: MusicPlayerDelegate {
    
    func changeDelegateForMusicPlayer() {
        guard let mainTabBar = UIApplication.getKeyWindow()?.rootViewController as? MainTabBarController else { return }
        mainTabBar.musicPlayerView.viewModel.delegate = self
    }
    
    func backTrack() -> TrackModelForPlayerView? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        var newIndexPath = IndexPath(row: searchTrackViewModel.numberOfRows() - 1, section: indexPath.section)
        if indexPath.row != 0 {
            newIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        }
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .none)
        return searchTrackViewModel.getPlayerViewModel(at: newIndexPath)
    }
    
    func nextTrack() -> TrackModelForPlayerView? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        var newIndexPath = IndexPath(row: 0, section: indexPath.section)
        if indexPath.row != searchTrackViewModel.numberOfRows() - 1 {
            newIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .none)
        return searchTrackViewModel.getPlayerViewModel(at: newIndexPath)
    }
}

//UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        footer.start()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (_) in
            self?.interactor?.makeRequest(request: .getSearchTracks(searchText:searchText))
        }
    }
}

//Canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerCanvas().edgesIgnoringSafeArea(.all)
    }
    struct ViewControllerCanvas: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: ContentView_Previews.ViewControllerCanvas.UIViewControllerType, context: UIViewControllerRepresentableContext<ContentView_Previews.ViewControllerCanvas>) {
            
        }
        func makeUIViewController(context: UIViewControllerRepresentableContext<ContentView_Previews.ViewControllerCanvas>) -> MainTabBarController {
            return MainTabBarController()
        }
        
        
    }
}
