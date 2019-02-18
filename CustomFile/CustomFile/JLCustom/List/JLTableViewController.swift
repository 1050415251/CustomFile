//
//  ListViewController.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/18.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {

    var tableView: UITableView!


    



}





struct ListParams {

    var url: String = ""
    var params:[String:Any]?

    init(url: String,params: [String:Any]?) {
        self.url = url
        self.params = params
    }

}
