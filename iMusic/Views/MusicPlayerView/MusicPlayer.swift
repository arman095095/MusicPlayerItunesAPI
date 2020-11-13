//
//  MusicPlayer.swift
//  iMusic
//
//  Created by Arman Davidoff on 24.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import RxCocoa
import RxSwift
import RxRelay

class MusicPlayer:UIView {
    
    var viewModel = MusicPlayerViewModel()
    var dispose = DisposeBag()
    weak var closeDelegate: CloseAndOpenDelegate?
   
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var miniImageView: UIImageView!
    @IBOutlet weak var miniLabel: UILabel!
    @IBOutlet weak var miniPlayePause: UIButton!
    @IBOutlet weak var miniNextTrack: UIButton!
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeTrack: UILabel!
    @IBOutlet weak var remainsTimeTrack: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackPositionSlider:UISlider!
    
    
    @IBAction func volumeControle(_ sender: UISlider) {
        viewModel.volume(value: sender.value)
    }
    @IBAction func pausePlayeButtonPlayey(_ sender: UIButton) {
        viewModel.playPause()
    }
    @IBAction func closePlayerView(_ sender: UIButton) {
        guard let delegate = closeDelegate else { return }
        delegate.animateClose()
    }
    @IBAction func backButtonPlayer(_ sender: Any) {
        viewModel.back()
    }
    @IBAction func nextButtonPlayer(_ sender: Any) {
        viewModel.next()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSlider()
        setupBinding()
        trackImageView.layer.cornerRadius = 5
        addGestureRecognize()
    }
    
    private func setupBinding() {
        viewModel.status.asDriver().drive(onNext: { status in
            guard let status = status else { return }
            switch status {
            case .paused:
                self.pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                self.miniPlayePause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                self.animatingImageView(state: .reduce)
            case .playing:
                self.pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.miniPlayePause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.animatingImageView(state: .raise)
            default:
                break
            }
        }).disposed(by: dispose)
        
        viewModel.currentTimeTrackString.asDriver().drive(onNext: { currentTimeString in
            guard let currentTimeString = currentTimeString else { return }
            self.currentTimeTrack.text = currentTimeString
        }).disposed(by: dispose)
        
        viewModel.remainsTimeTrackString.asDriver().drive(onNext: { remainsTimeString in
            guard let remainsTimeString = remainsTimeString else { return }
            self.remainsTimeTrack.text = remainsTimeString
        }).disposed(by: dispose)
        
        viewModel.currentTrack.asDriver().drive(onNext: { track in
            guard let track = track else { return }
            self.config(track: track)
        }).disposed(by: dispose)
        
        viewModel.sliderCurrentTime.asDriver().drive(onNext: { time in
            guard let time = time else { return }
            if self.trackPositionSlider.isTracking { return }
            self.trackPositionSlider.value = Float(time)
        }).disposed(by: dispose)
        
        viewModel.fullTimeTrackForSlider.asDriver().drive(onNext: { time in
            guard let time = time else { return }
            self.trackPositionSlider.maximumValue = Float(time)
        }).disposed(by: dispose)
    }
    
    func setupViewModel(track: TrackModelForPlayerView?) {
        viewModel.setup(track: track)
    }
    
    private func config(track: TrackModelForPlayerView?) {
        guard let track = track else { return }
        
        miniLabel.text = track.trackName ?? "--"
        trackName.text = track.trackName ?? "--"
        artistName.text = track.artistName ?? "--"
        let newIconURL = track.iconURL?.replacingOccurrences(of: "100x100", with: "600x600")
        trackImageView.sd_setImage(with: URL(string: newIconURL ?? ""), completed: nil)
        miniImageView.sd_setImage(with: URL(string: newIconURL ?? ""), completed: nil)
    }
    
    private func setupSlider() {
        trackPositionSlider.setThumbImage(#imageLiteral(resourceName: "Knob"), for: .normal)
        trackPositionSlider.minimumValue = Float(0)
        trackPositionSlider.addTarget(self, action: #selector(sliderAction(slider:event:)), for: .valueChanged)
    }
    
    @objc private func sliderAction(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                viewModel.seek(position: slider.value)
            default:
                break
            }
        }
    }
}
//MARK:- Setup Gestures and Animations
private extension MusicPlayer {
    enum AnimateState {
        case reduce
        case raise
        var animateScale: CGFloat {
            return 0.8
        }
    }
    //жесты касания
    func addGestureRecognize() {
        miniView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOpenMainStackView)))
        miniView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panOpenMainStackView)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCloseMainStackView)))
    }
    
    //жест тапа для открытия
    @objc func tapOpenMainStackView() {
        closeDelegate?.animateOpen(model: nil)
    }
    
    //жесты перетаскивания закрытия
    @objc func panCloseMainStackView(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            changingPositionWhileClosing(gesture: gesture)
        case .ended:
            endChangingPositionWhileClosing(gesture: gesture)
        default:
            break
        }
    }
    func changingPositionWhileClosing(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview).y
        if translation > 0 {
            self.transform = CGAffineTransform(translationX: 0, y: translation) }
    }
    func endChangingPositionWhileClosing(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview).y
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1,initialSpringVelocity: 1 ,options: .curveEaseInOut, animations: {
            self.transform = .identity
            if translation > 180  {
                self.closeDelegate?.animateClose()
            }
        }, completion: nil)
    }
    
    //Жесты перетаскивания открывания
    @objc func panOpenMainStackView(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            changingPositionWhileOpenning(gesture: gesture)
        case .ended:
            endChangingPositionWhileOpenning(gesture: gesture)
        default:
            break
        }
    }
    func changingPositionWhileOpenning(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview).y
        self.transform = CGAffineTransform(translationX: 0, y: translation)
        let newAlpha = 1 + translation / 200
        self.miniView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.mainStackView.alpha = -translation / 200
    }
    func endChangingPositionWhileOpenning(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview).y
        let velocity = gesture.velocity(in: self.superview).y
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1,initialSpringVelocity: 1 ,options: .curveEaseInOut, animations: {
            self.transform = .identity
            if translation < -200 || velocity < -500  {
                self.closeDelegate?.animateOpen(model: nil)
            } else {
                self.miniView.alpha = 1
                self.mainStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    //animate ready
    func animatingImageView(state: AnimateState) {
        switch state {
        case .raise:
            animate(form: .identity)
        case .reduce:
            animate(form: CGAffineTransform(scaleX: state.animateScale, y: state.animateScale))
        }
    }
    func animate(form: CGAffineTransform) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = form
        }, completion: nil)
    }
}
