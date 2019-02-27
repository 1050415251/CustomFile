//
//  ViewController.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import SwiftyJSON
import HandyJSON

class ViewController: UIViewController {





    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

       // dataSrc = JLTableViewDataSource<CustomCell, JLSectionView, JLSectionView>.init(tableV: vc.tableView)

//        let params = RequestParams.init(url: "https://www.weiyangpuhui.com/activityIf/activity/activityConfigure/activityInfo.htm", params: nil, type: .post,isForm: true)
//
//
//        let tableV = JLTableView<DataModel>.init(requestParams: params)
//        tableV.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "1")
//        tableV.frame = CGRect.init(x: 0, y: 0, width: 300, height: 500)
//        self.view.addSubview(tableV)
//
//        tableV.cellforRowAtindexPath = {  v,index,model -> UITableViewCell in
//            let cell = v.dequeueReusableCell(withIdentifier: "1")!
//            cell.textLabel?.text = model.actDesc
//            return cell
//        }
        let view = JLPageView()
        view.maxVCS = 100
        view.backgroundColor = UIColor.lightGray
        view.frame = CGRect.init(x: 0, y: 0, width: 300, height: 500)
        self.view.addSubview(view)
        view.reloadData()
        view.register(JLTabBarSubView.classForCoder(), forVcReuseIdentifier: "JLTabBarSubView")
        view.pageSubviewForRowAt = { scrollv,index -> JLTabBarSubView in
            let v = scrollv.dequeueReusableTabBarSubController(identifer: "JLTabBarSubView")
            v.backgroundColor = UIColor.red
            return v
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class DataModel: BaseBean {
    var actDesc = "1"
    var text: String = "2"
  
}

