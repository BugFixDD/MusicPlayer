//
//  BFMusicPlayerControllerViewController.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/4/30.
//  Copyright © 2018年 BF. All rights reserved.
//

import UIKit

class BFMusicPlayerController: UIViewController {

    //MARK: xib属性
    @IBOutlet weak var backgroundImgVw: UIImageView!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    
    @IBOutlet weak var lyricLbl: UILabel!
    
    @IBOutlet weak var iconImgVw: UIImageView!
    
    @IBOutlet weak var scrollVw: BFMusicLyricScrollerVw!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    //MARK: 代码属性
    lazy var songsViewModel = BFSongsViewModel()
    
    lazy var idx: Int = 0
    lazy var lastIndex: Int = 0
    
    init() {
        super.init(nibName: "BFMusicPlayerController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.progressSlider.value = 0
        BFMusicPlayer.shared.playingBlock = { (currentTime: TimeInterval, duration: TimeInterval) in

            self.updateValue(currentTime: currentTime, duration: duration)
            
            self.scrollVw.currentTime = currentTime
        }
        
        
    }
    
    /// 根据歌曲的当前时间和总时间，更新进度条和开始，结束label
    func updateValue(currentTime: TimeInterval, duration: TimeInterval) {
        self.progressSlider.value = Float(currentTime / duration)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let zeroDate = formatter.date(from: "00:00")!
        
        let currentDate = Date(timeInterval: currentTime, since: zeroDate)
        let durationDate = Date(timeInterval: duration, since: zeroDate)
        
        self.startTimeLbl.text = "\(formatter.string(from: currentDate))"
        self.endTimeLbl.text = "\(formatter.string(from: durationDate))"
        
        let viewModel = songsViewModel.songViewModels[idx]
        let index = viewModel.indexForLyricModel(currentTime: currentTime)
        print(index)
        self.lyricLbl.text = viewModel.lyricModels[index].text
    }

    override func viewDidAppear(_ animated: Bool) {
        iconImgVw.layer.cornerRadius = iconImgVw.bounds.width / 2
        iconImgVw.layer.masksToBounds = true
        
        scrollVw.setUpContentSize()
    }
    
    //MARK: 按钮监听方法
    @IBAction func slideValueChange(_ sender: UISlider) {
    
        BFMusicPlayer.shared.startFrom(rate: Double(sender.value))
        
    }
    
    
    @IBAction func startBtnClick(_ sender: UIButton) {
        if sender.isSelected == false {
            // 播放
            iconImgVw.layer.resumeAnim()
            
            if let url = songsViewModel.songViewModels[idx].fileUrl {
                BFMusicPlayer.shared.play(url: url)
            }
        } else {
            // 暂停
            iconImgVw.layer.pauseAnim()
            
            if let url = songsViewModel.songViewModels[idx].fileUrl {
                BFMusicPlayer.shared.pause(url: url)
            }
            
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        lastIndex = idx
        idx = ((idx + 1) + songsViewModel.songViewModels.count) % songsViewModel.songViewModels.count
        
        nextOrPrevious()
    }
    
    @IBAction func previousBtnClick(_ sender: UIButton) {
        lastIndex = idx
        idx = ((idx - 1) + songsViewModel.songViewModels.count) % songsViewModel.songViewModels.count
        
        nextOrPrevious()
    }
    
    /// 切换下一曲或者上一曲：改变音乐和改变UI
    func nextOrPrevious() {
        setValueForUI(viewModel: songsViewModel.songViewModels[idx])
        
        if let url = songsViewModel.songViewModels[lastIndex].fileUrl {
            BFMusicPlayer.shared.stop(url: url)
        }
        
        if let url = songsViewModel.songViewModels[idx].fileUrl {
            BFMusicPlayer.shared.play(url: url)
        }
        
        startBtn.isSelected = true
    }
}

// MARK: - UIScrollViewDelegate
extension BFMusicPlayerController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        iconImgVw.isHidden = scrollVw.contentOffset.x == view.bounds.width ? true : false
        lyricLbl.isHidden = iconImgVw.isHidden
        

    }
}

// MARK: - 设置页面
extension BFMusicPlayerController {
    func setupUI() {
        iconImgVw.layer.borderColor = UIColor.black.cgColor
        iconImgVw.layer.borderWidth = 6
        
        iconImgVwAddAnimation()
        iconImgVw.layer.pauseAnim()
        
        if let viewModel  = songsViewModel.songViewModels.first {
            setValueForUI(viewModel: viewModel)
        }
        
        scrollVw.delegate = self
    }
    
    /// 根据模型给UI页面赋值
    func setValueForUI(viewModel: BFSingleSongViewModel) {
        backgroundImgVw.image = viewModel.backgroundImg
        iconImgVw.image = viewModel.backgroundImg
        
        songLbl.text = viewModel.songModel.name
        singerLbl.text = viewModel.songModel.singer
        
        startTimeLbl.text = "00:00"
        
        scrollVw.viewModel = viewModel
    }

    /// 给icon添加动画
    func iconImgVwAddAnimation() {

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 2 * Double.pi
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        iconImgVw.layer.add(animation, forKey: "rotateAnimation")
    }
    
}









