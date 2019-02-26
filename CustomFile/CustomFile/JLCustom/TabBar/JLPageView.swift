//
//  JLTabController.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/22.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class JLPageView: UIScrollView {


    var maxVCS: Int! = 1

    @objc dynamic var currentindex: Int = 0
    /// j滑动的方向
    private var drawdirection: UISwipeGestureRecognizer.Direction?
    private var startDraw: CGPoint = CGPoint.zero

    private var pools:JLTabBarSubViewPool = JLTabBarSubViewPool()

    private var cachesubV: [String: JLTabBarSubView] =  [String: JLTabBarSubView]()


    var tabBarSubviewForRowAt: ((JLPageView,Int) -> JLTabBarSubView)!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        reloadSubView()
        super.layoutSubviews()

    }

}

extension JLPageView {

    func setUpUI() {
        self.isPagingEnabled = true
    }

    func reloadData() {
        self.contentSize = CGSize.init(width: CGFloat(maxVCS) * self.frame.width, height: self.frame.height)
        self.contentOffset.x = 0

    }

    // 利用layoutsubview
    func reloadSubView() {
        let visiblebounds = CGRect.init(x: self.contentOffset.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        for index in 0..<maxVCS {
            let rowRect = CGRect.init(x: CGFloat(index) * self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            if visiblebounds.intersects(rowRect)  {
                if (self.subviews.filter { (subv) -> Bool in
                    return subv.frame == rowRect && !subv.isHidden
                }).count == 0  {
                    let v = tabBarSubviewForRowAt(self,index)
                    v.frame = rowRect
                    cachesubV["\(index)"] = v
                }
            }else {
                if let v = cachesubV["\(index)"] {
                    pools.setJLTabBarSubViewController(identifer: v.restorationIdentifier, vc: v)
                }
                cachesubV.removeValue(forKey: "\(index)")
            }
        }
    }

}

/// 
extension JLPageView {

    open func dequeueReusableTabBarSubController(identifer: String) ->  JLTabBarSubView {
        let view = pools.getJLTabBarSubViewController(identifer: identifer)
        if !self.subviews.contains(view) {
            self.addSubview(view)
        }
        return view
    }

    open func register(_ vcClass: AnyClass, forVcReuseIdentifier: String) {
        pools.registerJLTabBarSubViewController(identifer: forVcReuseIdentifier, subvcClass: vcClass)
    }


}

