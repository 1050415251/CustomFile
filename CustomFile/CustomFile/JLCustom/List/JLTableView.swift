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
import Alamofire

class JLTableView<T: BaseBean>: UITableView {


    var requestParams: RequestParams!

    private var requestPage = 1
    var requestsize: Int = 10



    typealias CellforRowAtIndexPath = ((UITableView,Int,T) -> UITableViewCell)
    typealias DidSelectedRowAtIndexPath = ((IndexPath,T)->Void)

    var cellforRowAtindexPath: CellforRowAtIndexPath!
    var didSelectedRowAtindexPath: DidSelectedRowAtIndexPath?

    var requestObserVerable: Observable<[T]> =  Observable<[T]>.just([])

    var dataArr:BehaviorRelay = BehaviorRelay<[T]>.init(value: [])


    convenience init(requestParams: RequestParams) {
        self.init()
        self.requestParams = requestParams

    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
        setUpObserVer()
    }

 

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension JLTableView {

    private func setUp() {
        addView()
    }

    private func addView() {
        self.clipsToBounds = true
        self.separatorStyle = .none
        self.tableFooterView = UIView()
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 80
        self.backgroundColor = UIColor.red
    }

}


extension JLTableView {


    func setUpObserVer() {

        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.downpullRefresh()
        })

        self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.uppullLoad()
        })

        let _ = Observable.zip(self.rx.itemSelected,self.rx.modelSelected(T.self)).subscribe { [weak self] (event) in
            if let (indexPath,item) = event.element {
                debugPrint("点击了第\(indexPath.section)单元的第\(indexPath.row)项")
                self?.didSelectedRowAtindexPath?(indexPath,item)
            }
        }

        let _ = dataArr.bind(to: self.rx.items) {
            tableV,index,model  -> UITableViewCell in
            return self.cellforRowAtindexPath(tableV,index,model)
        }
    }

    private func loadData(downpullRefresh: Bool) {
        requestObserVerable = JLRxNetRequest<T>.reuqestlistinfoToServer(requestParams: requestParams)

        let _ = requestObserVerable.subscribe(onNext: { (data) in
            downpullRefresh ? self.handlerdownPullResult(data: data,  error: nil):self.handleruppullResult(data: data, error: nil)
        }, onError: { (error) in
            downpullRefresh ? self.handlerdownPullResult(data: [],  error: error):self.handleruppullResult(data: [], error: error)
        }, onCompleted: {

        }, onDisposed: {

        })

    }



}

extension JLTableView {

    func downpullRefresh() {
        requestPage = 1
        if let _ = requestParams.params {
            requestParams.params!["page"] = requestPage
        }else {
            requestParams.params = ["page":requestPage]
        }
        loadData(downpullRefresh: true)
    }

    func uppullLoad() {
        requestPage += 1
        if let _ = requestParams.params {
            requestParams.params!["page"] = requestPage
        }else {
            requestParams.params = ["page":requestPage]
        }
        loadData(downpullRefresh: false)
    }

    /// 下拉刷新
    func handlerdownPullResult(data: [T],error: Error?) {
        self.mj_header.endRefreshing()
        if let e = error {
             debugPrint(e.localizedDescription)

        }else {

            dataArr.accept(data)
        }
    }

    func handleruppullResult(data: [T],error: Error?) {
        self.mj_footer.endRefreshing()

        if let e = error {
            debugPrint(e.localizedDescription)

        }else {
            dataArr.accept(dataArr.value + data)
        }

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
