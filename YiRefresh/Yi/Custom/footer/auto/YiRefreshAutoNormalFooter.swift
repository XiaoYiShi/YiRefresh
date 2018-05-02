//
//  YiRefreshAutoNormalFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshAutoNormalFooter: YiRefreshAutoStateFooter
{
    //pragma mark - 懒加载子控件
    lazy var loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(
            activityIndicatorStyle: self.activityIndicatorViewStyle)
        loading.hidesWhenStopped = true
        addSubview(loading)
        return loading
    }()
    /// 菊花的样式
    var activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray {
        didSet {
            self.loadingView.activityIndicatorViewStyle = activityIndicatorViewStyle
        }
    }
    //pragma mark - 重写父类的方法
    override func prepare() {
        super.prepare()
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.loadingView.constraints.count != 0  { return }
        
        // 圈圈
        var loadingCenterX = self.yi_w * 0.5
        if (!self.isRefreshingTitleHidden) {
            loadingCenterX -= self.stateLabel.yi_textWith() * 0.5 + self.labelLeftInset
        }
        let loadingCenterY = self.yi_h * 0.5
        self.loadingView.center = CGPoint.init(x: loadingCenterX, y: loadingCenterY)
    }
    
    override var state: YiRefreshState {
        didSet {
            if super.state == oldValue { return }
            // 根据状态做事情
            if state == .noMoreData || state == .idle
            {
                self.loadingView.stopAnimating()
            }
            else if state == .refreshing
            {
                self.loadingView.startAnimating()
            }
        }
    }
}




