//
//  JLTableViewCell.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/18.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class JLTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setResult<T>(data: T) {

    }


}


class JLSectionView: UIView {


    func setResult<T>(data: T) {

    }

}
