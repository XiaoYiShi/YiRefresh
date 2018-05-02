//
//  YiRefreshAutoFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

/// ?????
class YiRefreshAutoFooter: YiRefreshFooter
{
    /** 是否自动刷新(默认为YES) */
    var isAutomaticallyRefresh : Bool = true
    
    /** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
    var triggerAutomaticallyRefreshPercent = CGFloat(1.0)
    
    /** 是否每一次拖拽只发一次请求 */
    var isOnlyRefreshPerDrag : Bool = false
    
    /** 一个新的拖拽 */
    private var isOneNewPan : Bool = false
    
    // mark - 初始化
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil
        { // 新的父控件
            if self.isHidden == false
            {
                self.scrollView?.yi_insetB += self.yi_h
            }

            // 设置位置
            self.yi_y = self.scrollView?.yi_contentH ?? 0
        }
        else
        { // 被移除了
            if self.isHidden == false
            {
                self.scrollView?.yi_insetB -= self.yi_h
            }
        }
    }

    // mark - 实现父类的方法
    override func prepare() {
        super.prepare()
        // 默认底部控件100%出现时才会自动刷新
        self.triggerAutomaticallyRefreshPercent = 1.0;

        // 设置为默认状态
        self.isAutomaticallyRefresh = true

        // 默认是当offset达到条件就发送请求（可连续）
        self.isOnlyRefreshPerDrag = false
    }
    
    override func scrollViewContentSize(did change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSize(did: change)
        // 设置位置
        self.yi_y = self.scrollView?.yi_contentH ?? 0
    }
    
    override func scrollViewContentOffset(did change: [NSKeyValueChangeKey : Any]?)
    {
        super.scrollViewContentOffset(did: change)
        
        if self.state != .idle
            || !self.isAutomaticallyRefresh
            || self.yi_y == 0
        { return }
        guard let scrollView = scrollView else {
            return
        }
        
        if scrollView.yi_insetT + scrollView.yi_contentH > scrollView.yi_h
        {   // 内容超过一个屏幕
            // 这里的_scrollView.yi_contentH替换掉self.yi_y更为合理
            if scrollView.yi_offsetY >= scrollView.yi_contentH - scrollView.yi_h + self.yi_h * self.triggerAutomaticallyRefreshPercent + scrollView.yi_insetB - self.yi_h
            {
                // 防止手松开时连续调用
                let old = change?[NSKeyValueChangeKey.oldKey] as? CGPoint
                let new = change?[NSKeyValueChangeKey.newKey] as? CGPoint
                
                guard let newY = new?.y, let oldY = old?.y else { return }
                if newY <= oldY
                { return }
                
                // 当底部刷新控件完全出现时，才刷新
                self.beginRefreshing()
            }
        }
    }
    
    
    override func scrollViewPanState(did change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanState(did: change)
        if self.state != .idle { return }
        
        guard let scrollView = scrollView else {
            return
        }
        
        let panState = scrollView.panGestureRecognizer.state
        if panState == UIGestureRecognizerState.ended
        {// 手松开
            if scrollView.yi_insetT + scrollView.yi_contentH <= scrollView.yi_h
            {  // 不够一个屏幕
                if scrollView.yi_offsetY >= -scrollView.yi_insetT
                { // 向上拽
                    self.beginRefreshing()
                }
            } else { // 超出一个屏幕
                if scrollView.yi_offsetY >= scrollView.yi_contentH + scrollView.yi_insetB - scrollView.yi_h
                {
                    self.beginRefreshing()
                }
            }
        }
        else if panState == UIGestureRecognizerState.began
        {
            self.isOneNewPan = true
        }
    }
    
    override func beginRefreshing() {
        if !self.isOneNewPan && self.isOnlyRefreshPerDrag { return }
        super.beginRefreshing()
        self.isOneNewPan = false
    }
    
    override var state: YiRefreshState {
        didSet {
            if (super.state == oldValue) { return }
            
            if super.state == .refreshing
            {
                self.executeRefreshingCallback()
            }
            else if super.state == .noMoreData || super.state == .idle
            {
                if oldValue == .refreshing
                {
                    self.endRefreshingCompletionBlock?()
                }
            }
        }
    }
    override var isHidden: Bool {
        didSet {
            if !oldValue && self.isHidden
            {
                self.state = .idle
                self.scrollView?.yi_insetB -= self.yi_h
            }
            else if oldValue && !self.isHidden
            {
                self.scrollView?.yi_insetB += self.yi_h
                // 设置位置
                self.yi_y = scrollView?.yi_contentH ?? 0
            }
        }
    }
}

