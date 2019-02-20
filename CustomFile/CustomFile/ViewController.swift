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

        let vc = ListViewController()
        self.present(vc, animated: true, completion: nil)

       // dataSrc = JLTableViewDataSource<CustomCell, JLSectionView, JLSectionView>.init(tableV: vc.tableView)

        let params = RequestParams.init(url: "https://www.weiyangpuhui.com/activityIf/activity/activityConfigure/activityInfo.htm", params: nil, type: .post,isForm: true)

        let _ = JLRxNetRequest<DataModel>.reuqestinfoToServer(requestParams: params).subscribe { (event) in
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class DataModel: BaseBean {
    var info = "1"
    var text: String = "2"
  
}

class CustomCell: JLTableViewCell {

}
