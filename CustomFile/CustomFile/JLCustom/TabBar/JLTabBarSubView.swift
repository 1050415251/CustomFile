//
//  JLTabBarSubViewController.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/22.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class JLTabBarSubView: UIView {

    var textLab: UILabel!


    convenience init(frame: CGRect,reuseIdentifier: String?) {
        self.init(frame: frame)
        self.restorationIdentifier = reuseIdentifier
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red

        textLab = UILabel()
        textLab.font = UIFont.systemFont(ofSize: 14)
        textLab.textColor = 0x333333.rgbColor
        textLab.frame = CGRect.init(x: 0, y: 0, width: 100, height: 200)
        self.addSubview(textLab)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
