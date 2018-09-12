//
//  CenterToastView.swift
//  GTEDai
//
//  Created by 国投 on 2018/7/19.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation

class CenterToastView: UIView {

    private var toastV:RefreshView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        toastV = RefreshView.init(frame: CGRect.init(x: (SCREEN_WIDTH - scale(80)) * 0.5, y:(SCREEN_HEIGHT - scale(80)) * 0.5 - UIUtils.NAV_HEIGHT, width: scale(80), height: scale(80)))
        toastV?.backgroundColor = 0xffffff.rgbColor
        self.addSubview(toastV)
    }


    func showToast(_ text: String) {
        toastV?.text = text
        toastV?.startToastAnimation()
    }

    func hideToast() {
        toastV?.closeAnimation()
    }

}
