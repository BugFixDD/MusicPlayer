//
//  BFMusicLyricScrollerVw.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit

class BFMusicLyricScrollerVw: UIScrollView {

    var viewModel: BFSingleSongViewModel? {
        didSet {
            tableVw.reloadData()
        }
    }
    
    var currentTime: TimeInterval? {
        didSet {
            let idx = viewModel?.indexForLyricModel(currentTime: currentTime ?? 0) ?? 0
            
            tableVw.scrollToRow(at: IndexPath(row: idx, section: 0), at: .middle, animated: true)
            
            for cell in tableVw.visibleCells {
                cell.textLabel?.textColor = UIColor.lightGray
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            }
            
            if let cell = tableVw.cellForRow(at: IndexPath(row: idx, section: 0)) {
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            }
        }
    }
    
    private lazy var tableVw = UITableView(frame: .zero, style: .plain)
    private var backgroundVw: UIVisualEffectView!
    
    /// 设置scrollview的contentSize和子控件的frame
    func setUpContentSize() {
        tableVw.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
//        backgroundVw.frame = tableVw.frame
        contentSize = CGSize(width: bounds.width * 2, height: bounds.height)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()


//        let effect = UIBlurEffect(style: .dark)
//        backgroundVw = UIVisualEffectView(effect: effect)
//        backgroundVw = UIVisualEffectView()
//        addSubview(backgroundVw)
//        backgroundVw.backgroundColor = UIColor.black
//        backgroundVw.alpha = 0.5
        
        tableVw.delegate = self
        tableVw.dataSource = self
        tableVw.showsVerticalScrollIndicator = false
        tableVw.allowsSelection = false
        tableVw.backgroundColor = nil
        tableVw.separatorStyle = .none
        addSubview(tableVw)
        
        
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BFMusicLyricScrollerVw: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.lyricModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reusedID")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reusedID")
        }
        
        cell?.textLabel?.text = viewModel?.lyricModels[indexPath.row].text
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = nil
        
        return cell!
    }
    
    
}
