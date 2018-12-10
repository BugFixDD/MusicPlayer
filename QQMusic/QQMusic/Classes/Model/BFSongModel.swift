//
//  BFSongModel.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit

class BFSongModel: NSObject {
    @objc var name: String?
    @objc var filename: String?
    @objc var lrcname: String?
    @objc var singer: String?
    @objc var singerIcon: String?
    @objc var icon: String?
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
}
