//
//  YiRefreshHeader.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/28.
//  Copyright © 2018年 Yi. All rights reserved.
//
//  下拉刷新控件:负责监控用户下拉的状态

import UIKit

class YiRefreshHeader: YiRefreshComponent
{
    
    private var insetTDelta : CGFloat = 0
    
    // MARK: - 构造方法
    /** 创建header */
    class func header(refreshingBlock:@escaping YiRefreshComponentBlock_Refreshing) -> Self
    {
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    
    /** 创建header */
    class func header(target:AnyObject,action:Selector) -> Self
    {
        let cmp = self.init()
        cmp.setRefreshing(target: target, action: action)
        return cmp
    }
    
    // MARK: - 覆盖父类的方法
    override func prepare()
    {
        super.prepare()
        // 设置key
        self.lastUpdatedTimeKey = YiRefreshText.key.lastUpdatedTime.rawValue
        
        // 设置高度
        self.yi_h = CGFloat.YiRefresh.headerHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        self.yi_y = -self.yi_h - self.ignoredScrollViewContentInsetTop
    }
    override func scrollViewContentOffset(did change: [NSKeyValueChangeKey : Any]?)
    {
        super.scrollViewContentOffset(did: change)
        
        // 在刷新的refreshing状态
        if self.state == YiRefreshState.refreshing
        {
            // 暂时保留
            if self.window == nil { return }
            
            // sectionheader停留解决
            var insetT = -self.scrollView!.yi_offsetY > scrollViewOriginalInset.top ? -self.scrollView!.yi_offsetY : scrollViewOriginalInset.top
            
            insetT = insetT > self.yi_h + scrollViewOriginalInset.top ? self.yi_h + scrollViewOriginalInset.top : insetT
            
            self.scrollView!.yi_insetT = insetT
            
            self.insetTDelta = scrollViewOriginalInset.top - insetT
            return
        }
        
        // 跳转到下一个控制器时，contentInset可能会变
        scrollViewOriginalInset = self.scrollView!.yi_inset
        
        
        // 当前的contentOffset
        let offsetY = self.scrollView!.yi_offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        // >= -> >
        if offsetY > happenOffsetY { return }
        
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - self.yi_h
        let pullingPercent = (happenOffsetY - offsetY) / self.yi_h
        
        if self.scrollView!.isDragging // 如果正在拖拽
        {
            self.pullingPercent = pullingPercent;
            if self.state == YiRefreshState.idle && offsetY < normal2pullingOffsetY
            {
                // 转为即将刷新状态
                self.state = YiRefreshState.pulling
            }
            else if self.state == YiRefreshState.pulling && offsetY >= normal2pullingOffsetY
            {
                // 转为普通状态
                self.state = YiRefreshState.idle
            }
        }
        else if self.state == YiRefreshState.pulling
        {   // 即将刷新 && 手松开
            // 开始刷新
            self.beginRefreshing()
        }
        else if (pullingPercent < 1)
        {
            self.pullingPercent = pullingPercent
        }
    }
    
    override var state: YiRefreshState {   
        didSet {
            if (super.state == oldValue) { return }
            
            // 根据状态做事情
            if super.state == YiRefreshState.idle
            {
                if oldValue != YiRefreshState.refreshing { return }
                
                // 保存刷新时间
                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                
                // 恢复inset和offset
                UIView.animate(withDuration: TimeInterval.YiRefresh.slow, animations: {
                    self.scrollView?.yi_insetT += self.insetTDelta
                    
                    // 自动调整透明度
                    if (self.isAutomaticallyChangeAlpha)
                    {   self.alpha = 0.0    }
                }, completion: { (finished) in
                    self.pullingPercent = 0.0;
                    
                    self.endRefreshingCompletionBlock?()
                })
            }
            else if super.state == YiRefreshState.refreshing
            {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                        let top = self.scrollViewOriginalInset.top + self.yi_h
                        // 增加滚动区域top
                        self.scrollView?.yi_insetT = top
                        // 设置滚动位置
                        var offset = self.scrollView?.contentOffset ?? .zero
                        offset.y = -top
                        self.scrollView?.setContentOffset(offset, animated: false)
                    }, completion: { (finished) in
                        self.executeRefreshingCallback()
                    })
                }
            }
        }
    }
    
    
    // MARK: - 公共方法
    /** 这个key用来存储上一次下拉刷新成功的时间 */
    var lastUpdatedTimeKey : String = ""
    
    /** 上一次下拉刷新成功的时间 */
    var lastUpdatedTime : Date {
        get {
            return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as! Date
        }
    }
    
    
    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop : CGFloat = 0.0 {
        didSet {
            self.yi_y = -self.yi_h - ignoredScrollViewContentInsetTop
        }
    }
    
    
}
