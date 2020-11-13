//
//  MusicPlayerViewModel.swift
//  iMusic
//
//  Created by Arman Davidoff on 13.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import AVKit
import RxCocoa
import RxSwift
import RxRelay

class MusicPlayerViewModel {
    private var avPlayer : AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = true
        return player
    }()
    
    private var AVPeriodicObserver:Any?
    private var AVBoundaryObserver:Any?
    
    private var flagPreviosTrack = true
    private var timerSettingAV: Timer?
    
    var delegate: MusicPlayerDelegate?
    
    var currentTrack = BehaviorRelay<TrackModelForPlayerView?>(value: nil)
    var status = BehaviorRelay<AVPlayer.TimeControlStatus?>(value: nil)
    
    var currentTimeTrackString = BehaviorRelay<String?>(value: nil)
    var remainsTimeTrackString  = BehaviorRelay<String?>(value: nil)
    
    var sliderCurrentTime = BehaviorRelay<CMTimeValue?>(value: nil)
    var fullTimeTrackForSlider = BehaviorRelay<CMTimeValue?>(value: nil)
    
    func setup(track: TrackModelForPlayerView?) {
        guard let track = track else { return }
        
        self.status.accept(.paused)
        flagPreviosTrack = true
        removeObserversAndRemoveItem()
        
        self.currentTrack.accept(track)
        guard let trackURL = URL(string: track.previewUrl ?? "") else { return }
        
        timerSettingAV = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {[weak self] (_) in
            self?.addItemAndSettingAV(url: trackURL)
            let trackTime = self?.avPlayer.currentItem?.duration.convertScale(1000000000, method: .default).value ?? CMTimeMake(value: 1, timescale: 1).value
            self?.fullTimeTrackForSlider.accept(trackTime)
            self?.remainsTimeTrackString.accept("-\(CalculatorTime.convertCMTimeToString(time: trackTime))")
        })
    }
    
    func seek(position: Float) {
        avPlayer.seek(to: CMTime(value: CMTimeValue(position), timescale: 1000000000))
    }
    func volume(value: Float) {
        avPlayer.volume = value
    }
    func playPause() {
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            status.accept(.playing)
        } else if avPlayer.timeControlStatus == .playing {
            avPlayer.pause()
            status.accept(.paused)
        }
    }
    func back() {
        if !flagPreviosTrack {
            avPlayer.seek(to: CMTime(value: 0, timescale: 1000000000),completionHandler: { [weak self] _ in
                self?.flagPreviosTrack = true
            })
        }
        else {
            timerSettingAV?.invalidate()
            guard let delegate = delegate else { return }
            guard let backTrack = delegate.backTrack() else { return }
            self.setup(track: backTrack)
        }
    }
    func next() {
        timerSettingAV?.invalidate()
        guard let delegate = delegate else { return }
        guard let nextTrack = delegate.nextTrack() else { return }
        self.setup(track:nextTrack)
    }
    
    private func addItemAndSettingAV(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        addBoundaryObserverAV()
        addPeriodicObserverAV()
        avPlayer.play()
    }
    
    //observerstime
    private func addBoundaryObserverAV() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        AVBoundaryObserver = avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.status.accept(.playing)
        }
    }
    private func addPeriodicObserverAV() {
        let time = CMTimeMake(value: 1, timescale: 2)
        AVPeriodicObserver = avPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (time) in
            
            if time.seconds > 2.5 { self?.flagPreviosTrack = false }
            
            let trackTime = self?.avPlayer.currentItem?.duration.convertScale(1000000000, method: .default).value ?? CMTimeMake(value: 1, timescale: 1).value
            let currentTime = time.value
            
            self?.fullTimeTrackForSlider.accept(trackTime)
            self?.currentTimeTrackString.accept(CalculatorTime.convertCMTimeToString(time: currentTime))
            self?.remainsTimeTrackString.accept("-\(CalculatorTime.convertCMTimeToString(time: trackTime - currentTime))")
            self?.sliderCurrentTime.accept(currentTime)
        }
    }
    private func removeObserversAndRemoveItem() {
        if let bObserver = AVBoundaryObserver, let pObserver = AVPeriodicObserver {
            avPlayer.removeTimeObserver(bObserver)
            avPlayer.removeTimeObserver(pObserver)
            AVPeriodicObserver = nil
            AVBoundaryObserver = nil
        }
        avPlayer.replaceCurrentItem(with: nil)
    }
    
}
