//
//  BFSongsViewModel.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import Foundation

/// 管理多个BFSingleSongViewModel的viewModel
class BFSongsViewModel {
    lazy var songViewModels = [BFSingleSongViewModel]()
    
    init() {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            print("Musics.plist不存在")

            return
        }

        for dict in NSArray(contentsOfFile: path)! {
            songViewModels += [BFSingleSongViewModel(dict: dict as! [String : Any])]
        }
        
    }
}
