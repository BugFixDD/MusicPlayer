//
//  BFLyricModel.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit

class BFLyricModel: NSObject {
    /// 这句歌词开头的时间
    @objc var time: TimeInterval = 0
    /// 每句歌词
    @objc var text: String?
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
}
