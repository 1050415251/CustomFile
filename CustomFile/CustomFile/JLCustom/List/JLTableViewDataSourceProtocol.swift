//
//  JLTableViewDataSourceProtocol.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/18.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

protocol JLTableViewDataSourceProtocol {

    func didSelectedAt(indexPath: IndexPath)

    func didSelectedAt<Cell: UITableViewCell>(cell: Cell)

    func didSelectedAtModel<Model: NSObject>(model: Model)

    func cellforRowAt<Model: NSObject>(indexPath: IndexPath,model :Model) -> UITableViewCell

    var sectionmodel: SectionModel<Any, Any> { get set }

}
