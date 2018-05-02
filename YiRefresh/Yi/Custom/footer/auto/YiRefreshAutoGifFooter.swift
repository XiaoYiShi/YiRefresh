//
//  YiRefreshAutoGifFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshAutoGifFooter: YiRefreshAutoStateFooter
{
    // MARK: - 懒加载
    private(set) lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        addSubview(gifView)
        return gifView
    }()
    
    /** 所有状态对应的动画图片 */
    private var stateImages = [YiRefreshState:[UIImage]]()
    /** 所有状态对应的动画时间 */
    private var stateDurations = [YiRefreshState:TimeInterval]()
    
    //pragma mark - 公共方法
    /** 设置state状态下的动画图片images 动画持续时间duration*/
    func set(images:[UIImage],duration:TimeInterval,state:YiRefreshState) {
        self.stateImages[state] = images
        self.stateDurations[state] = duration
        
        /* 根据图片设置控件的高度 */
        if let image = images.first {
            if image.size.height > self.yi_h {
                self.yi_h = image.size.height
            }
        }
    }
    func set(images:[UIImage],state:YiRefreshState) {
        self.set(images: images, duration: TimeInterval(images.count) * 0.1, state: state)
    }
    
    //pragma mark - 实现父类的方法
    override func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = 20
    }
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.gifView.constraints.count != 0 { return }
        
        self.gifView.frame = self.bounds
        if self.isRefreshingTitleHidden
        {
            self.gifView.contentMode = .center
        } else {
            self.gifView.contentMode = .right
            self.gifView.yi_w = self.yi_w * 0.5 - self.labelLeftInset - self.stateLabel.yi_textWith() * 0.5
        }
    }
    
    override var state: YiRefreshState {
        didSet {
            if super.state == oldValue { return }
            
            // 根据状态做事情
            if (state == .refreshing) {
                let images = self.stateImages[state] ?? []
                if images.count == 0 { return }
                self.gifView.stopAnimating()
                
                self.gifView.isHidden = false
                if images.count == 1
                { // 单张图片
                    self.gifView.image = images.last
                } else { // 多张图片
                    self.gifView.animationImages = images
                    self.gifView.animationDuration = self.stateDurations[state] ?? 0
                    self.gifView.startAnimating()
                }
            }
            else if state == .noMoreData || state == .idle
            {
                self.gifView.stopAnimating()
                self.gifView.isHidden = true
            }
        }
    }
}


