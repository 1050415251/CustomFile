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

    var vcs: [UIViewController] = []

    var maxVCS: Int! = 1


    @objc dynamic var currentindex: Int = 0
    /// j滑动的方向
    private var drawdirection: UISwipeGestureRecognizer.Direction?
    private var startDraw: CGPoint = CGPoint.zero

    private var pools:JLTabBarSubViewPool = JLTabBarSubViewPool()


    var tabBarSubviewForRowAt: ((JLPageView,Int) -> JLTabBarSubView)!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JLPageView {

    func setUpUI() {
        self.delegate = self
        self.isPagingEnabled = true
    }

    func reloadData() {
        self.contentSize = CGSize.init(width: CGFloat(maxVCS) * self.frame.width, height: self.frame.height)
        self.contentOffset.x = 0

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            let v = self.tabBarSubviewForRowAt(self,0)
            v.frame = self.bounds
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


extension JLPageView: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentindex = Int(self.contentOffset.x/self.frame.width)
        startDraw = scrollView.contentOffset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        objc_sync_enter(scrollView)
        handlerDrawDirection(offset: scrollView.contentOffset)
        recoverysubView()
        objc_sync_exit(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentindex = Int(self.contentOffset.x/self.frame.width)
        drawdirection = nil

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            debugPrint("减速完成")
        }
    }


    private func handlerDrawDirection(offset: CGPoint) {
        var currentdrawdirection: UISwipeGestureRecognizer.Direction!
        currentdrawdirection = offset.x < startDraw.x ? .right:.left



        if  currentdrawdirection !=  drawdirection {
            drawdirection = currentdrawdirection

            if currentindex  >= 0 && currentindex  < maxVCS ?? 0 {
                var rect: CGRect = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)

                rect.origin = CGPoint.init(x: drawdirection == .right ? CGFloat(currentindex - 1) * self.frame.width:CGFloat(currentindex + 1) * self.frame.width, y: 0)

                if !((currentindex == 0 && drawdirection == .right) || (currentindex == maxVCS - 1 && drawdirection == .left)) {
                    tabBarSubviewForRowAt(self,(drawdirection == .left || drawdirection == .up) ? currentindex + 1:currentindex - 1).frame = rect
                }
            }
        }
    }


    private func recoverysubView() {
        //// 把屏幕外面的放入缓存吃
        let vcs = self.subviews.filter { (subv) -> Bool in
            return (subv.frame.origin.x < CGFloat(currentindex - 1) * self.frame.width || subv.frame.origin.x > CGFloat(currentindex + 1) * self.frame.width) && subv.frame != CGRect.zero
        }
        vcs.forEach {
            if let v = $0 as? JLTabBarSubView {
                pools.setJLTabBarSubViewController(identifer: $0.restorationIdentifier, vc: v)
            }

        }
    }


}
