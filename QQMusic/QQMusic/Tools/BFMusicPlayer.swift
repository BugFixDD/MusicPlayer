//
//  BFMusicPlayer.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit
import AVKit

class BFMusicPlayer: NSObject {
    
    static let shared = BFMusicPlayer()
    
    /// 正在播放的音乐的回调
    var playingBlock: ((TimeInterval, TimeInterval) -> ())?
    
    private lazy var musicCacheDic = [String: AVAudioPlayer]()
    
    private var timer: Timer!
    
    private var currentUrl: URL?
    
    override init() {
        super.init()
        
        setupTimer()
    }
    
    func play(url: URL) {
        
        currentUrl = url
    
        if let audioPlayer = musicCacheDic[url.absoluteString] {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            timer.fireDate = Date()
            return
        }
        
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else {
            print("url错误")
            return
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()

        timer.fireDate = Date()
        
        musicCacheDic[url.absoluteString] = audioPlayer
    }
    
    func pause(url: URL) {
        musicCacheDic[url.absoluteString]?.pause()
        
        timer.fireDate = NSDate.distantFuture
    }
    
    func stop(url: URL) {
        musicCacheDic[url.absoluteString]?.currentTime = 0
        musicCacheDic[url.absoluteString]?.stop()
        
        timer.fireDate = NSDate.distantFuture
    }
    
    /// 从某处开始播放
    ///
    /// - Parameter rate: 歌曲的比率
    func startFrom(rate: Double) {
        
        guard let url = currentUrl,
            let audioPlayer = musicCacheDic[url.absoluteString] else {
                
                return
        }
        
        audioPlayer.currentTime = Double(audioPlayer.duration) * rate
        
    }
    
    private func setupTimer() {
        timer = Timer(timeInterval: 1, repeats: true) { (_) in
            guard let url = self.currentUrl,
            let player = self.musicCacheDic[url.absoluteString] else {
                return
            }
            print("-----")
            self.playingBlock?(player.currentTime, player.duration)
        }
        
        timer.fireDate = NSDate.distantFuture
        timer.fire()
        
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
}
