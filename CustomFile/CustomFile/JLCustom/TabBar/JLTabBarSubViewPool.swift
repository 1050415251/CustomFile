//
//  JLTabBarSubViewControllerPool.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/22.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

typealias JLTabBarSubView = UIView

class JLTabBarSubViewPool: NSObject {

    private var vcpool: [String:[JLTabBarSubView]]! = [String:[JLTabBarSubView]]()

    private var registervcpool: [String: AnyClass?]! =  [String: AnyClass?]()
    

    override init() {
        super.init()

    }
    
    func registerJLTabBarSubViewController(identifer: String,subvcClass: AnyClass) {
        registervcpool[identifer] = subvcClass

    }


    func getJLTabBarSubViewController(identifer: String) -> JLTabBarSubView {
        objc_sync_enter(vcpool)
        if vcpool[identifer] != nil,vcpool[identifer]!.count > 0 {

            debugPrint(vcpool[identifer]!.count)
            let vc = vcpool[identifer]!.remove(at: 0)
            debugPrint("移除了1个缓存池中个数为：\(vcpool[identifer]!.count)")
            vc.isHidden = false
            objc_sync_exit(vcpool)

            return vc
        }
        if let classtype = registervcpool[identifer],let className = classtype as? JLTabBarSubView.Type {
            debugPrint("shilihual")
            let vc = className.init()
            vc.restorationIdentifier = identifer
            /// 将对象放入缓存池
            return vc
        }
        fatalError("identifer未注册")
    }


    func setJLTabBarSubViewController(identifer: String?,vc: JLTabBarSubView)  {
        guard let identy = identifer else {
            return
        }
        objc_sync_enter(vcpool)
        vc.isHidden = true
        if let _ = vcpool[identy] {
            vcpool[identy]!.append(vc)
        }else {
            vcpool[identy] = [vc]
        }
        debugPrint("添加了1个缓存池中个数为：\(vcpool[identy]!.count)")
        objc_sync_exit(vcpool)
    }


}
