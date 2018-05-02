//
//  YiRefreshBackNormalFooter.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/4/2.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

class YiRefreshBackNormalFooter: YiRefreshBackStateFooter
{
    
    // MARK: - 懒加载子控件
    lazy var arrowView: UIImageView = {
        let arrow = UIImageView.init(image: Bundle.yi_arrowImage())
        addSubview(arrow)
        return arrow
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(
            activityIndicatorStyle: self.activityIndicatorViewStyle)
        loading.hidesWhenStopped = true
        addSubview(loading)
        return loading
    }()
    
    /** 菊花的样式 */
    var activityIndicatorViewStyle : UIActivityIndicatorViewStyle = .gray {
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
        
        // 箭头的中心点
        var arrowCenterX = self.yi_w * 0.5
        if !self.stateLabel.isHidden {
            arrowCenterX -= self.labelLeftInset + self.stateLabel.yi_textWith() * 0.5
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
        
        self.arrowView.tintColor = self.stateLabel.textColor
    }
    
    override var state: YiRefreshState {
        didSet {
            if (super.state == oldValue) { return }
            // 根据状态做事情
            if (super.state == .idle) {
                if (oldValue == .refreshing) {
                    self.arrowView.transform = CGAffineTransform.init(rotationAngle: 0.000001 - CGFloat.pi)
                    UIView.animate(withDuration: TimeInterval.YiRefresh.slow, animations: {
                        self.loadingView.alpha = 0.0
                    }) { (finished) in
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    self.arrowView.isHidden = false
                    self.loadingView.stopAnimating()
                    UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                        self.arrowView.transform = CGAffineTransform.init(rotationAngle: 0.000001 - CGFloat.pi)
                    })
                }
            }
            else if (super.state == .pulling)
            {
                self.arrowView.isHidden = false
                self.loadingView.stopAnimating()
                UIView.animate(withDuration: TimeInterval.YiRefresh.fast, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            }
            else if (super.state == .refreshing)
            {
                self.arrowView.isHidden = true
                self.loadingView.startAnimating()
            }
            else if (super.state == .noMoreData)
            {
                self.arrowView.isHidden = true
                self.loadingView.stopAnimating()
            }
        }
    }
}


