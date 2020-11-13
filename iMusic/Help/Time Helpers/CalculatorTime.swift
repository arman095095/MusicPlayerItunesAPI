//
//  CalculatorTime.swift
//  iMusic
//
//  Created by Arman Davidoff on 24.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation
import AVKit

struct TrackTime {
    var minutes:Int
    var seconds:Int
}


class CalculatorTime {
    
    private static func fromMiliToSeconds(mili:Int?) -> Int {
        guard let mili = mili else { return 0 }
        return mili / 1000
    }
    
    private static func getMinutes(mili: Int?) -> Int {
        let seconds = fromMiliToSeconds(mili: mili)
        return seconds / 60
    }
    
    private static func getOstSeconds(mili:Int?) -> Int {
        let seconds = fromMiliToSeconds(mili: mili)
        let minutes = getMinutes(mili: mili)
        if minutes == 0 {
            return seconds
        }
        return seconds%(minutes*60)
    }
    
    private static func calculateMiliToTrackTime(mili: Int?) -> TrackTime {
        return TrackTime(minutes: getMinutes(mili: mili), seconds: getOstSeconds(mili: mili))
    }
    
    private static func convertTimeTrackToString(time:TrackTime) -> String {
        let seconds =  time.seconds < 10 ? "0" + "\(time.seconds)" : "\(time.seconds)"
        
        return "\(time.minutes):\(seconds)"
    }
    
    private static func convertFromCMTimeToMili(time: CMTimeValue) -> Int {
        return Int(time/1000000)
    }
    
    static func convertFromMiliToCMTime(milli:Int?) -> CMTimeValue  {
        guard let milli = milli else { return 0 }
        return CMTimeValue(milli*1000000)
    }
    
    static func convertCMTimeToString(time:CMTimeValue) -> String {
        let mili = convertFromCMTimeToMili(time: time)
        let trackTime = calculateMiliToTrackTime(mili: mili)
        return convertTimeTrackToString(time: trackTime)
    }
    
    
}
