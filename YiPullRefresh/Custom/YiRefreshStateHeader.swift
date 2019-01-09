//
//  YiRefreshStateHeader.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/28.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshStateHeader: YiRefreshHeader
{
    
    // MARK: - 刷新时间相关
    /** 利用这个block来决定显示的更新时间文字 */
    var lastUpdatedTimeText : ((Date?)->String?)?
    
    /** 显示上一次刷新时间的label */
    private(set) lazy var lastUpdatedTimeLabel : UILabel = {
        let label = UILabel.yi_label()
        self.addSubview(label)
        return label
    }()
    
    // mark - 状态相关
    /** 文字距离圈圈、箭头的距离 */
    var labelLeftInset = CGFloat(0)
    
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
    
    
    // mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
    func currentCalendar() -> Calendar
    {
        return Calendar.init(identifier: Calendar.Identifier.gregorian)
    }
    
    // mark key的处理
    override var lastUpdatedTimeKey : String
    {
        didSet {
            // 如果label隐藏了，就不用再处理
            if self.lastUpdatedTimeLabel.isHidden {
                return
            }
            let lastUpdatedTime = UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
            // 如果有block
            if self.lastUpdatedTimeText != nil {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText?(lastUpdatedTime)
                return
            }
            if let lastUpdatedTime = lastUpdatedTime {
                // 1.获得年月日
                let calendar = self.currentCalendar()
                let unitFlags : Set<Calendar.Component> = [.year,
                                                        .month,
                                                        .day,
                                                        .hour,
                                                        .minute]
                let cmp1 = calendar.dateComponents(unitFlags, from: lastUpdatedTime)
                let cmp2 = calendar.dateComponents(unitFlags, from: Date())
                // 2.格式化日期
                let formatter = DateFormatter.init()
                var isToday = false
                if cmp1.day == cmp2.day
                {// 今天
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1.year == cmp2.year { // 今年
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let time = formatter.string(from: lastUpdatedTime)
                
                // 3.显示日期
                self.lastUpdatedTimeLabel.text = Bundle.yi_localizedStringForKey(key: YiRefreshText.time.last.rawValue) + (isToday ? Bundle.yi_localizedStringForKey(key: YiRefreshText.time.today.rawValue) :"") + time
            } else {
                self.lastUpdatedTimeLabel.text = Bundle.yi_localizedStringForKey(key: YiRefreshText.time.last.rawValue) + Bundle.yi_localizedStringForKey(key: YiRefreshText.time.none.rawValue)
            }
        }
    }
    
    
    // mark - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        // 初始化间距
        self.labelLeftInset = CGFloat.YiRefresh.labelLeftInset
        
        // 初始化文字
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.header.idle.rawValue), for: .idle)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.header.pulling.rawValue), for: .pulling)
        self.setTitle(title: Bundle.yi_localizedStringForKey(key: YiRefreshText.header.refreshing.rawValue), for: .refreshing)
    }
    
    override func placeSubviews()
    {
        super.placeSubviews()
        
        if self.stateLabel.isHidden {
            return
        }
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0
        
        if self.lastUpdatedTimeLabel.isHidden {
            // 状态
            if noConstrainsOnStatusLabel
            { self.stateLabel.frame = self.bounds }
        } else {
            let stateLabelH = self.yi_h * 0.5
            
            // 状态
            if noConstrainsOnStatusLabel {
                self.stateLabel.yi_x = 0;
                self.stateLabel.yi_y = 0;
                self.stateLabel.yi_w = self.yi_w;
                self.stateLabel.yi_h = stateLabelH;
            }
            
            // 更新时间
            if (self.lastUpdatedTimeLabel.constraints.count == 0) {
                self.lastUpdatedTimeLabel.yi_x = 0
                self.lastUpdatedTimeLabel.yi_y = stateLabelH
                self.lastUpdatedTimeLabel.yi_w = self.yi_w
                self.lastUpdatedTimeLabel.yi_h = self.yi_h - self.lastUpdatedTimeLabel.yi_y
            }
        }
    }
    
    override var state: YiRefreshState
    {
        didSet {
            if (super.state == oldValue) { return }
            // 设置状态文字
            self.stateLabel.text = self.stateTitles[super.state]
            
            // 重新设置key（重新显示时间）
            let key = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = key
        }
    }
    
}
