//
//  extension_UILabel.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

extension UILabel
{
    class func yi_label() -> UILabel {
        let label = UILabel()
        label.font = UIFont.YiRefresh.Label
        label.textColor = UIColor.YiRefresh.LabelText
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    func yi_textWith() -> CGFloat {
        var stringWidth = CGFloat(0)
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude,
                               height: CGFloat.greatestFiniteMagnitude)
        if self.text != nil && self.text!.count > 0 {
            stringWidth = (self.text! as NSString).boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font:self.font],
                context: nil
                ).size.width
        }
        return stringWidth
    }
}

