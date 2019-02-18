//
//  ex+UIViewController.swift
//  CustomFile
//
//  Created by 国投 on 2018/10/19.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func refreshstatubarstyle(_ barstyle:UIStatusBarStyle) {
        UIApplication.shared.setStatusBarStyle(barstyle, animated: true)
    }

    func refreshstatusbarisHidden(_ isHidden:Bool) {
        UIApplication.shared.setStatusBarHidden(isHidden, with: .fade)
    }

}




extension UIViewController {



    @objc func willAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }
        DEBUG.DEBUGPRINT(obj: "runtime 拦截了viewwillAppear事件")
    }

    @objc func didAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }


    }

    @objc func willDisAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }
    }

    @objc func didDisAppear(animated:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }


    }

}
