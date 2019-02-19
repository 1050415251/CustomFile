//
//  ListViewController.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/18.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import MJRefresh
import HandyJSON

class ListViewController: UIViewController {

    private(set) var tableView: UITableView!

    var customnavcomplete:(()->UIView?)?

//    private(set) var dataSrc: JLTableViewDataSource<T: HandyJSON>! {
//        didSet {
//            dataSrc.tableView = tableView
//            dataSrc.setUpObserVer()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUpUI()

    }

}

extension ListViewController {

    private func setUpUI() {
        addNav()
        addView()
    }

    private func addNav() {
        if let callback = customnavcomplete {
            if let v = callback() {
                self.view.addSubview(v)
            }else {
                tableView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(0)
                }
            }
        }else {
            /// 添加通用导航栏view
        }
    }

    private func addView() {
        tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.red
        tableView.register(JLTableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(JLTableViewCell.classForCoder()))

        self.view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(44)
        }

    }

}





