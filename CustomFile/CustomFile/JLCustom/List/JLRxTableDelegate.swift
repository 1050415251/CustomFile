//
//  JLRxTableDelegate.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/19.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

/// 类似于RxDataSources 自定义delegate
class JLTableViewSectionedDelegate<S: SectionModelType>: NSObject,UITableViewDelegate,RxTableViewDataSourceType {


    typealias Element = [S]
    public typealias I = S.Item
    public typealias Section = S

    public typealias SectionModelSnapshot = SectionModel<S, I>

    func tableView(_ tableView: UITableView, observedEvent: Event<[S]>) {
        Binder(self) { dataSource, element in
            tableView.reloadData()
        }.on(observedEvent)
    }



    typealias ViewForHeaderInSection = (JLTableViewSectionedDelegate<S>, Int) -> UIView?
    typealias ViewForFooterInSection = (JLTableViewSectionedDelegate<S>, Int) -> UIView?
    typealias HeightForHeaderInsection = () -> CGFloat
    typealias HeightForFooterInsection = () -> CGFloat

    var viewForHeaderInSection: ViewForHeaderInSection?
    var viewForFooterInSection: ViewForFooterInSection?
    var heightForHeaderInsection: HeightForHeaderInsection?
    var heightForFooterInsection: HeightForFooterInsection?

    


    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection?(self,section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection?(self,section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInsection?() ?? 0.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInsection?() ?? 0.0
    }
}


