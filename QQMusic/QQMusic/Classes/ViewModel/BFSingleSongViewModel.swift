//
//  BFSingleSongViewModel.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit

class BFSingleSongViewModel {
    var songModel: BFSongModel
    lazy var lyricModels = [BFLyricModel]()
    
    var backgroundImg: UIImage?
    /// 歌曲文件URL
    var fileUrl: URL?
    
    init(dict: [String: Any]) {
        songModel = BFSongModel(dict: dict)
        
        setProperties()
    }
    
    /// 根据当前时间，找出对应歌词模型的索引
    func indexForLyricModel(currentTime: TimeInterval) -> NSInteger {
        
        for i in 1..<lyricModels.count {
            let previousModel = lyricModels[i - 1]
            let currentModel = lyricModels[i]
            
            if currentTime > previousModel.time && currentTime < currentModel.time {
                
                if i == -1 {
                    return 0
                } else {
                    return i - 1
                }
            }
        }
        
        return lyricModels.count - 1
    }
    
    func setProperties() {
        backgroundImg = UIImage(named: songModel.icon ?? "")
        
        fileUrl = Bundle.main.url(forResource: songModel.filename, withExtension: nil)
        
        guard let path = Bundle.main.path(forResource: songModel.lrcname, ofType: nil),
            let lyric = try? String(contentsOfFile: path),
            let lyricArr = lyric.handleLyric(timeKey: "time", textKey: "text") else {
            return
        }
        
        for dict in lyricArr {
            lyricModels += [BFLyricModel(dict: dict)]
        }
        
    }
    
    func handleLyric() {
        
    }
}
