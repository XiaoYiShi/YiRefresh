//
//  YiRefreshGifHeader.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshGifHeader: YiRefreshStateHeader
{
    // mark - 公共方法
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
    
    /** 所有状态对应的动画图片 */
    private var stateImages = [YiRefreshState:[UIImage]]()
    /** 所有状态对应的动画时间 */
    private var stateDurations = [YiRefreshState:TimeInterval]()
    
    // MARK: - 懒加载
    private(set) lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        addSubview(gifView)
        return gifView
    }()
    
   // mark - 实现父类的方法
    override func prepare()
    {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = 20;
    }
    
    override var pullingPercent: CGFloat
    {
        didSet {
            if let images = self.stateImages[.idle], images.count > 0 {
                if self.state != .idle { return }
                // 停止动画
                self.gifView.stopAnimating()
                // 设置当前需要显示的图片
                var index = Int(CGFloat(images.count) * pullingPercent)
                if index >= images.count
                {
                    index = images.count - 1
                }
                self.gifView.image = images[index];
            }
        }
    }
    
    override func placeSubviews()
    {
        super.placeSubviews()
        
        if self.gifView.constraints.count > 0 { return }
        self.gifView.frame = self.bounds
        
        if self.stateLabel.isHidden
            && self.lastUpdatedTimeLabel.isHidden
        {
            self.gifView.contentMode = .center
        }
        else
        {
            self.gifView.contentMode = .right
            let stateWidth = self.stateLabel.yi_textWith()
            var timeWidth = CGFloat(0.0)
            
            if !self.lastUpdatedTimeLabel.isHidden
            {
                timeWidth = self.lastUpdatedTimeLabel.yi_textWith()
            }
            let textWidth = (stateWidth > timeWidth ? stateWidth : timeWidth)  //MAX(stateWidth, timeWidth);
            self.gifView.yi_w = self.yi_w * 0.5 - textWidth * 0.5 - self.labelLeftInset
        }
    }
    
    override var state: YiRefreshState {
        didSet {
            if (super.state == oldValue) { return }
            // 根据状态做事情
            if super.state == .pulling || super.state == .refreshing
            {
                if let images = self.stateImages[super.state],images.count > 0 {
                    self.gifView.stopAnimating()
                    if (images.count == 1)
                    { // 单张图片
                        self.gifView.image = images.last
                    }
                    else
                    { // 多张图片
                        self.gifView.animationImages = images
                        self.gifView.animationDuration = self.stateDurations[super.state] ?? 0
                        self.gifView.startAnimating()
                    }
                }
            }
            else if super.state == .idle
            {
                self.gifView.stopAnimating()
            }
        }
    }
}


