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

class ListViewController<Model: NSObject>: UIViewController {

    private(set) var tableView: UITableView!

    /// 注册单个cell
    var registerAnyCellClass: AnyClass? {
        didSet {
            tableView.register(registerAnyCellClass!, forCellReuseIdentifier: NSStringFromClass(registerAnyCellClass!))
        }
    }


    var didSelectedAtIndexPath: ((IndexPath)->Void)?
    var cellforrowAtindexPath: ((IndexPath,Model)->UITableViewCell)?
    var didSelectedAtCell: ((UITableViewCell)->Void)?
    var didSelectedAtModel: ((Model)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

    }


}

extension ListViewController {

    private func setUpUI() {
        addNav()
        addView()
    }

    private func addNav() {

    }

    private func addView() {
        tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.white

        self.view.addSubview(tableView)
    }

}


extension ListViewController {

    private func setUpObserVer() {
        let _ = (tableView.rx.itemSelected).subscribe { [weak self] (event) in
            if let indexPath = event.element {

                self?.didSelectedAtIndexPath?(indexPath)
            }
        }

        let _ = (tableView.rx.modelSelected(Model.self)).subscribe { [weak self] (event) in
            if let model = event.element {
                self?.didSelectedAtModel?(model)
            }
        }

        let dataSrc = RxTableViewSectionedReloadDataSource<SEc>.init(configureCell: { (dataSrc, tableV, indexPath, s) -> UITableViewCell in

        })


    }

}



struct ListParams {

    var url: String = ""
    var params:[String:Any]?

    init(url: String,params: [String:Any]?) {
        self.url = url
        self.params = params
    }

}
