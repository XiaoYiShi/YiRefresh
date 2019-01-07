//
//  YiRefreshComponent.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

/// 刷新控件的状态
enum YiRefreshState : Int {
    /// 普通闲置状态
    case idle           = 1
    /// 松开就可以进行刷新的状态
    case pulling        = 2
    /// 正在刷新中的状态
    case refreshing     = 3
    /// 即将刷新的状态
    case willRefresh    = 4
    /// 所有数据加载完毕，没有更多的数据了
    case noMoreData     = 5
}

/// 进入刷新状态的回调
typealias YiRefreshComponentBlock_Refreshing                = ()->Void
/// 开始刷新后的回调(进入刷新状态后的回调)
typealias YiRefreshComponentBlock_beginRefreshingCompletion = ()->Void
/// 结束刷新后的回调
typealias YiRefreshComponentBlock_EndRefreshingCompletion   = ()->Void



/** 刷新控件的基类 */
class YiRefreshComponent: UIView
{
    //MARK:- 刷新回调
    /// 正在刷新的回调
    var refreshingBlock : YiRefreshComponentBlock_Refreshing?
    /// 开始刷新后的回调(进入刷新状态后的回调)
    var beginRefreshingCompletionBlock : YiRefreshComponentBlock_beginRefreshingCompletion?
    /// 结束刷新的回调
    var endRefreshingCompletionBlock : YiRefreshComponentBlock_EndRefreshingCompletion?
    
    /// 回调对象
    var refreshingTarget : AnyObject?
    /// 回调方法
    var refreshingAction : Selector?
    /// 设置回调对象和回调方法
    func setRefreshing(target:AnyObject, action:Selector ) -> Void {
        self.refreshingTarget = target;
        self.refreshingAction = action;
    }
    
    //MARK:- 初始化
    /// 记录scrollView刚开始的inset
    //    private(set)
    var scrollViewOriginalInset : UIEdgeInsets!
    ///  父控件
    private(set) var scrollView : UIScrollView?
    /// 父控件的拖拽手势
    private var  pan : UIPanGestureRecognizer?
    
    /// - 初始化
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        // 准备工作
        self.prepare()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        // 基本属性
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    
    func placeSubviews() {}
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let newSuperview = newSuperview else {
            return
        }
        // 如果不是UIScrollView，不做任何事情
        if newSuperview is UIScrollView {} else { return }
        
        // 旧的父控件移除监听
        self.removeObservers()
        
        if let newSuperview = newSuperview as? UIScrollView { // 新的父控件
            // 设置宽度
            self.yi_w = newSuperview.yi_w
            // 设置位置
            if scrollView != nil {
                self.yi_x = -scrollView!.yi_insetL
            } else {
                self.yi_x = 0
            }
            
            // 记录UIScrollView
            scrollView = newSuperview
            // 设置永远支持垂直弹簧效果
            scrollView?.alwaysBounceVertical = true
            // 记录UIScrollView最开始的contentInset
            scrollViewOriginalInset = scrollView?.yi_inset
            
            // 添加监听
            self.addObservers()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
    
    //MARK: - 刷新状态控制
    /** 刷新状态 一般交给子类内部实现 */
    // 默认是普通状态
    var state : YiRefreshState = .idle {
        didSet {
            if (self.state == oldValue) { return }
            // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    // 进入刷新状态
    func beginRefreshing() {
        UIView.animate(withDuration: TimeInterval.YiRefresh.fast) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0;
        // 只要正在刷新，就完全显示
        if self.window != nil {
            self.state = .refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if self.state != .refreshing {
                self.state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    func beginRefreshing(completionBlock:@escaping (()->Void)) -> Void {
        self.beginRefreshingCompletionBlock = completionBlock
        self.beginRefreshing()
    }
    /// 结束刷新状态
    func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    func endRefreshing(completionBlock:@escaping (()->Void)) -> Void {
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }
    
    
    /// 是否正在刷新
    var isRefreshing : Bool {
        get {
            return self.state == .refreshing || self.state == .willRefresh
        }
    }
    
    //MARK: - 自动切换透明度
    /** 根据拖拽比例自动切换透明度 */
    var isAutomaticallyChangeAlpha : Bool = false {
        didSet {
            if self.isRefreshing {
                return
            }
            if (isAutomaticallyChangeAlpha) {
                self.alpha = self.pullingPercent;
            } else {
                self.alpha = 1.0;
            }
        }
    }
    // 拉拽的百分比(交给子类重写)
    // 根据拖拽进度设置透明度
    var pullingPercent : CGFloat = 0 {
        didSet {
            if self.isRefreshing {
                return
            }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    /// 触发回调（交给子类去调用）
    func executeRefreshingCallback() {
        DispatchQueue.main.async {
            self.refreshingBlock?()
            if let action = self.refreshingAction,
                let target = self.refreshingTarget,
                self.canPerformAction(action, withSender: target)
            {
                self.target(forAction: action, withSender: target)
            }
            self.beginRefreshingCompletionBlock?()
        }
    }
    
    /// 监听调用的方法
    func scrollViewContentOffset(did    change:[NSKeyValueChangeKey : Any]?) {}
    func scrollViewContentSize(did      change:[NSKeyValueChangeKey : Any]?) {}
    func scrollViewPanState(did         change:[NSKeyValueChangeKey : Any]?) {}
}


// MARK: - MARK: - KVO监听
extension YiRefreshComponent {
    func addObservers()
    {
        let options : NSKeyValueObservingOptions = [.new, .old]
        self.scrollView?.addObserver(
            self,
            forKeyPath: YiRefreshText.key.contentOffset.rawValue,
            options: options,
            context: nil)
        self.scrollView?.addObserver(
            self,
            forKeyPath: YiRefreshText.key.contentSize.rawValue,
            options: options,
            context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: YiRefreshText.key.panState.rawValue, options: options, context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: YiRefreshText.key.contentOffset.rawValue)
        self.superview?.removeObserver(self, forKeyPath: YiRefreshText.key.contentSize.rawValue)
        self.superview?.removeObserver(self, forKeyPath: YiRefreshText.key.panState.rawValue)
        self.pan = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 遇到这些情况就直接返回
        if !self.isUserInteractionEnabled { return }
        
        // 这个就算看不见也需要处理
        if keyPath == YiRefreshText.key.contentSize.rawValue {
            self.scrollViewContentSize(did: change)
        }
        
        // 看不见
        if self.isHidden {return}
        if keyPath == YiRefreshText.key.contentOffset.rawValue {
            self.scrollViewContentOffset(did: change)
        } else if keyPath == YiRefreshText.key.panState.rawValue {
            self.scrollViewPanState(did: change)
        }
    }
}







