//
//  ViewController.swift
//  YiRefreshDemo
//
//  Created by 史晓义 on 2019/1/7.
//  Copyright © 2019 史晓义. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = .white
        
        table = UITableView.init(frame: CGRect.init(x: 20, y: 50, width: 300, height: 500), style: .grouped)
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        table.yi_header = YiRefreshNormalHeader.header(refreshingBlock: {
            self.cellCount = 8
            self.perform(#selector(self.reloadData), with: nil, afterDelay: 1)
        })
        table.yi_footer = YiRefreshBackNormalFooter.footer(refreshingBlock: {
            self.cellCount += 8
            self.perform(#selector(self.reloadData), with: nil, afterDelay: 2)
        })
    }
    var cellCount = 8
    
    @objc func reloadData() {
        if cellCount > 20 {
            table.yi_footer.endRefreshingWithNoMoreData()
        } else {
            table.yi_footer?.endRefreshing()
        }
        table.yi_header?.endRefreshing()
        table.reloadData()
    }
    
    var table : UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let cellid_none = "noneCellId"
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: cellid_none)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellid_none)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

