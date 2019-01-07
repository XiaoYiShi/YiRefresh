//
//  YiRefreshFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshFooter: YiRefreshComponent
{
    
    // mark - 构造方法
    /** 创建footer */
    class func footer(refreshingBlock:@escaping YiRefreshComponentBlock_Refreshing) -> Self
    {
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    
    /** 创建footer */
    class func footer(target:AnyObject,action:Selector) -> Self
    {
        let cmp = self.init()
        cmp.setRefreshing(target: target, action: action)
        return cmp
    }
    
    
    
    // mark - 重写父类的方法
    override func prepare() {
        super.prepare()
        // 设置自己的高度
        self.yi_h = CGFloat.YiRefresh.footerHeight
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    // mark - 公共方法
    /** 提示没有更多的数据 */
    func endRefreshingWithNoMoreData()
    {
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    func resetNoMoreData()
    {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    
    /** 忽略多少scrollView的contentInset的bottom */
    var ignoredScrollViewContentInsetBottom = CGFloat(0)
}

