//
//  HudUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/7/26.
//  Copyright © 2017年 ZhanTengMr'S Zhang. All rights reserved.
//

import Foundation


///显示hud
class HUDUtil:NSObject {

    private static var BindShowHUD:Int = 0///HUD展示数量

    ///显示hud
    class func showHud(_ text:String? = nil) {

        DispatchQueue.main.async {
            BindShowHUD = BindShowHUD + 1
        }

    }


    
    ///隐藏hud
    class func hideHud(isForce: Bool = false) {
        if isForce {
            BindShowHUD = 0
        }
        DispatchQueue.main.async {
            BindShowHUD = BindShowHUD - 1

            if BindShowHUD <= 0 {

            }
        }

    }


    ///显示文字hud
    class func showHudWithText(text: String, delay: Double = 1.0) {

       
    }
}



