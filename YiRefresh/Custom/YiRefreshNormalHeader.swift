//
//  YiRefreshNormalHeader.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/28.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshNormalHeader: YiRefreshStateHeader {
    
    // MARK: - 懒加载子控件
    lazy var arrowView: UIImageView = {
        let arrow = UIImageView.init(image: Bundle.yi_arrowImage())
        addSubview(arrow)
        return arrow
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(style: self.activityIndicatorViewStyle)
        loading.hidesWhenStopped = true
        addSubview(loading)
        return loading
    }()
    
    /** 菊花的样式 */
    var activityIndicatorViewStyle : UIActivityIndicatorView.Style = .gray {
        didSet {
            loadingView.style = activityIndicatorViewStyle
        }
    }
    
    // MARK: - 重写父类的方法
    override func prepare() {
        super.prepare()
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        // 箭头的中心点
        var arrowCenterX = self.yi_w * 0.5
        if !self.stateLabel.isHidden
        {
            let stateWidth = self.stateLabel.yi_textWith()
            var timeWidth = CGFloat(0.0)
            if !self.lastUpdatedTimeLabel.isHidden
            {
                timeWidth = self.lastUpdatedTimeLabel.yi_textWith()
            }
            let textWidth = (stateWidth > timeWidth ? stateWidth : timeWidth)  //MAX(stateWidth, timeWidth);
            arrowCenterX -= textWidth / 2 + self.labelLeftInset
        }
        let arrowCenterY = self.yi_h * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        
        // 箭头
        if self.arrowView.constraints.count == 0 {
            self.arrowView.yi_size = self.arrowView.image?.size ?? .zero
            self.arrowView.center = arrowCenter
        }
        // 圈圈
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowView.tintColor = self.stateLabel.textColor;
    }
    
    override var state: YiRefreshState {
        didSet {
            if (super.state == oldValue) { return }
            
            // 根据状态做事情
            if super.state == .idle
            {
                if oldValue == .refreshing
                {
                    self.arrowView.transform = CGAffineTransform.identity
                    
                    UIView.animate(withDuration: TimeInterval.YiRefresh.slow, animations: {
                        self.loadingView.alpha = 0.0
                    }, completion: { (finished) in
                        // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                        if super.state != .idle { return }
                        
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    })
                }
                else
                {
                    self.loadingView.stopAnimating()
                    
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                        self.arrowView.transform = CGAffineTransform.identity
                    })
                }
            }
            else if super.state == .pulling
            {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                    self.arrowView.transform = CGAffineTransform.init(rotationAngle: 0.000001 - CGFloat.pi)
                })
            }
            else if super.state == .refreshing
            {
                self.loadingView.alpha = 1.0 // 防止refreshing -> idle的动画完毕动作没有被执行
                
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
            }
        }
    }
}

