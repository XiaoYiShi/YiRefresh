//
//  YiRefreshBackFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshBackFooter: YiRefreshFooter {

    var lastRefreshCount = Int(0)
    var lastBottomDelta = CGFloat(0)

    
    //     mark - 初始化
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollViewContentSize(did: nil)
    }
    
    //     mark - 实现父类的方法
    override func scrollViewContentOffset(did change: [NSKeyValueChangeKey : Any]?)
    {
        super.scrollViewContentOffset(did: change)
        // 如果正在刷新，直接返回
        if self.state == .refreshing { return }

        scrollViewOriginalInset = self.scrollView?.yi_inset ?? UIEdgeInsets.zero

        // 当前的contentOffset
        let currentOffsetY = self.scrollView?.yi_offsetY ?? 0
        // 尾部控件刚好出现的offsetY
        let happenOffsetY = self.happenOffsetY()
        // 如果是向下滚动到看不见尾部控件，直接返回
        if currentOffsetY <= happenOffsetY { return }

        let pullingPercent = (currentOffsetY - happenOffsetY) / self.yi_h

        // 如果已全部加载，仅设置pullingPercent，然后返回
        if self.state == .noMoreData
        {
            self.pullingPercent = pullingPercent
            return
        }

        if let isDragging = self.scrollView?.isDragging, isDragging
        {
            self.pullingPercent = pullingPercent
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetY = happenOffsetY + self.yi_h

            if self.state == .idle
                && currentOffsetY > normal2pullingOffsetY
            {

                // 转为即将刷新状态
                self.state = .pulling
            }
            else if self.state == .pulling
                    && currentOffsetY <= normal2pullingOffsetY
            {
                // 转为普通状态
                self.state = .idle
            }
        }
        else if self.state == .pulling
        {// 即将刷新 && 手松开
            // 开始刷新
            self.beginRefreshing()
        }
        else if (pullingPercent < 1)
        {
            self.pullingPercent = pullingPercent
        }
    }
    
    override func scrollViewContentSize(did change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSize(did: change)
        
        // 内容的高度
        let contentHeight = (self.scrollView?.yi_contentH ?? 0) + self.ignoredScrollViewContentInsetBottom
        // 表格的高度
        let scrollHeight = (self.scrollView?.yi_h ?? 0) - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        // 设置位置和尺寸
        self.yi_y = (contentHeight > scrollHeight ? contentHeight : scrollHeight)
    }
    
    override var state: YiRefreshState {
        didSet {
            if (super.state == oldValue) { return }
            // 根据状态来设置属性
            if super.state == .noMoreData
                || super.state == .idle
            {
                // 刷新完毕
                if .refreshing == oldValue
                {
                    UIView.animate(withDuration: TimeInterval.YiRefresh.slow, animations: {
                        self.scrollView?.yi_insetB -= self.lastBottomDelta

                        // 自动调整透明度
                        if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                    }, completion: { (finished) in
                        self.pullingPercent = 0.0
                        self.endRefreshingCompletionBlock?()
                    })
                }
                let deltaH = self.heightForContentBreakView()
                // 刚刷新完毕
                if .refreshing == oldValue
                    && deltaH > 0
                    && self.scrollView?.yi_totalDataCount() != self.lastRefreshCount
                {
                    self.scrollView?.yi_offsetY = (self.scrollView?.yi_offsetY ?? 0)
                }
            }
            else if super.state == .refreshing
            {
                // 记录刷新前的数量
                self.lastRefreshCount = self.scrollView?.yi_totalDataCount() ?? 0

                UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                    var bottom = self.yi_h + self.scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0
                    { // 如果内容高度小于view的高度
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - (self.scrollView?.yi_insetB ?? 0)
                    self.scrollView?.yi_insetB = bottom
                    self.scrollView?.yi_offsetY = self.happenOffsetY() + self.yi_h
                }, completion: { (finished) in
                    self.executeRefreshingCallback()
                })
            }
        }
    }
    
//     mark - 私有方法
//     mark 获得scrollView的内容 超出 view 的高度
    private func heightForContentBreakView() -> CGFloat {
        let h = (self.scrollView?.frame.size.height ?? 0) - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
        return (self.scrollView?.contentSize.height ?? 0) - h
    }
    
//     mark 刚好看到上拉刷新控件时的contentOffset.y
    private func happenOffsetY() -> CGFloat {
        let deltaH = self.heightForContentBreakView()
        if deltaH > 0
        {
            return deltaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }
}

