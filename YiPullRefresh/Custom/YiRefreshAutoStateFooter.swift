//
//  YiRefreshAutoStateFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshAutoStateFooter: YiRefreshAutoFooter
{
    /// 文字距离圈圈、箭头的距离
    var labelLeftInset : CGFloat = 0
    /// 隐藏刷新状态的文字
    var isRefreshingTitleHidden = false
    
    // pragma mark - 懒加载
    /** 所有状态对应的文字 */
    var stateTitles =  [YiRefreshState:String]()
    
    /// 显示刷新状态的label
    private(set) lazy var stateLabel : UILabel = {
        let label = UILabel.yi_label()
        self.addSubview(label)
        return label
    }()
    
    //  pragma mark - 公共方法
    /// 设置state状态下的文字
    func setTitle(title:String, for state:YiRefreshState ) {
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    //pragma mark - 私有方法
    @objc private func stateLabelClick() {
        if (self.state == .idle) {
            self.beginRefreshing()
        }
    }
    
    //pragma mark - 重写父类的方法
    override func prepare() {
        super.prepare()
        
        // 初始化间距
        self.labelLeftInset = CGFloat.YiRefresh.labelLeftInset
        
        // 初始化文字
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.auto.idle.rawValue), for: .idle)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.auto.refreshing.rawValue), for: .refreshing)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.auto.noMore.rawValue), for: .noMoreData)
        
        // 监听label
        self.stateLabel.isUserInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(stateLabelClick)))
    }
    override func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.constraints.count != 0 { return }
        // 状态标签
        self.stateLabel.frame = self.bounds
    }
    
    override var state: YiRefreshState {
        didSet {
            if super.state == oldValue { return }
            if self.isRefreshingTitleHidden && state == .refreshing {
                self.stateLabel.text = nil
            } else {
                self.stateLabel.text = self.stateTitles[state]
            }
        }
    }
}






