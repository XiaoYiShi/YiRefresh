//
//  YiRefreshBackStateFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshBackStateFooter: YiRefreshBackFooter {
    
    /** 文字距离圈圈、箭头的距离 */
    var labelLeftInset : CGFloat = 0
    
    /** 显示刷新状态的label */
    private(set) lazy var stateLabel : UILabel = {
        let label = UILabel.yi_label()
        self.addSubview(label)
        return label
    }()
    /// 所有状态对应的文字
    private var stateTitles = [YiRefreshState:String]()
    /// 设置state状态下的文字
    func setTitle(title:String, for state:YiRefreshState ) {
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state]
    }
    /** 获取state状态下的title */
    func title(for state:YiRefreshState) -> String {
        return self.stateTitles[state] ?? ""
    }
    
    //pragma mark - 重写父类的方法
    override func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = CGFloat.YiRefresh.labelLeftInset
        // 初始化文字
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.back.idle.rawValue), for: .idle)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.back.pulling.rawValue), for: .pulling)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.back.refreshing.rawValue), for: .refreshing)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.footer.back.noMore.rawValue), for: .noMoreData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if (self.stateLabel.constraints.count != 0 ){ return }
        // 状态标签
        self.stateLabel.frame = self.bounds
    }
    override var state: YiRefreshState {
        didSet {
            if (state == oldValue) { return }
            // 设置状态文字
            self.stateLabel.text = self.stateTitles[state]
        }
    }
}

