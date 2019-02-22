//
//  JLTabBarSubViewControllerPool.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/22.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

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
        if var vcs = vcpool[identifer],vcs.count == 2 {
            objc_sync_exit(vcpool)
            return vcs.remove(at: 0)
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
        if let _ = vcpool[identy] {
            vcpool[identy]?.append(vc)
        }else {
            vcpool[identy] = [vc]
        }
        objc_sync_exit(vcpool)
    }


}
