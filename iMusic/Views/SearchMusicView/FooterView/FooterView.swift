//
//  FooterView.swift
//  iMusic
//
//  Created by Arman Davidoff on 24.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    var loader:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var textLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        view.textColor = .lightGray
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(loader)
        addSubview(textLabel)
        
        textLabel.topAnchor.constraint(equalTo: topAnchor,constant: 20).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        loader.topAnchor.constraint(equalTo: textLabel.bottomAnchor,constant: 8).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func start() {
        loader.startAnimating()
        textLabel.text = "Загрузка"
    }
    func stop() {
        loader.stopAnimating()
        textLabel.text = ""
    }
}
