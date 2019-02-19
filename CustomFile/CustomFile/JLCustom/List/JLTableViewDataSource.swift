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
import RxSwift
import RxCocoa
import Alamofire
import MJRefresh
import HandyJSON

class JLTableViewDataSource<T: HandyJSON>: NSObject,UITableViewDelegate {


    var requestParams: RequestParams! {
        didSet {
            loadData()
        }
    }
    weak var tableView: UITableView!

    var behaviorSubjuect: BehaviorSubject<[T]> =  BehaviorSubject<[T]>.init(value: [])

    private var currentPage = 1
    var size: Int = 10

    lazy var dataSrc: RxTableViewSectionedReloadDataSource<SectionModel<String,HandyJSON>>! = {
        let datasrc = RxTableViewSectionedReloadDataSource<SectionModel<String,HandyJSON>>.init(
            configureCell:{ [weak self] (dataSrc, tableV, indexPath, item) -> UITableViewCell in
                let cell = tableV.dequeueReusableCell(withIdentifier: NSStringFromClass(JLTableViewCell.classForCoder()), for: indexPath) as! JLTableViewCell
                cell.setResult(data: item)
                return cell
            }
        )
        return datasrc
    }()

//    lazy var delegate: JLTableViewSectionedDelegate<Model>! = {
//        return JLTableViewSectionedDelegate.init()
//    }()

    override init() {
        super.init()
    }

    func setUpObserVer() {

        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.downpullRefresh()
        })

        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.uppullLoad()
        })

        let _ = Observable.zip(tableView.rx.itemSelected,tableView.rx.modelSelected(HandyJSON.self)).subscribe { (event) in
            if let (indexPath,item) = event.element {
                debugPrint("点击了第\(indexPath.section)单元的第\(indexPath.row)项")
                debugPrint(item)
            }
        }

       // let _ = requestToServer(params: requestParams).bind(to: tableView.rx.items(dataSource: dataSrc))

        let _ = behaviorSubjuect.bind(to: tableView.rx.items(dataSource: dataSrc))

        let _ = behaviorSubjuect.subscribe(onNext: { (data) in

        }, onError: { (error) in

        }, onCompleted: {

        }, onDisposed: {

        })


    }

    private func loadData() {

    }

    func requestToServer(params: RequestParams) -> Observable<[T]> {
        //return JLRxNetRequest<T>.reuqestinfoToServer(requestParams: requestParams)
    }

}

extension JLTableViewDataSource {

    private func downpullRefresh() {
        currentPage = 1
        if let _ = requestParams.params {
            requestParams.params!["page"] = currentPage
        }else {
            requestParams.params = ["page":currentPage]
        }
        loadData()
    }

    private func uppullLoad() {
        currentPage += 1
        if let _ = requestParams.params {
            requestParams.params!["page"] = currentPage
        }else {
            requestParams.params = ["page":currentPage]
        }
        loadData()
    }

}


/// 请求参数封装 此处是结构体 注意 值引用和指针引用
struct RequestParams {

    var url: String!
    var params: [String: Any]?
    var type: HTTPMethod! = .post
    var isForm: Bool!

    init(url: String!,params: [String: Any]?,type: HTTPMethod = .post,isForm: Bool = true) {
        self.url = url
        self.params = params
        self.type = type
        self.isForm = isForm
    }

}

