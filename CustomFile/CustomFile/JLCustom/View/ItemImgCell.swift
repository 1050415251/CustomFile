//
//  ItemImgCell.swift
//  GTEDai
//
//  Created by 国投 on 2018/7/17.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation


class ItemImgCell: ItemBasicabCell {

    private(set) var rightImgV: UIImageView!

    var changeswitchcallback:((Bool)->Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addImgView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addImgView() {
        arrowImgV.isHidden = true

        rightImgV = UIImageView()
        self.addSubview(rightImgV)
        rightImgV.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-15)
            make.size.equalTo(scale(30))
        }
    }

    func setResult(data: Any) {
        if let urlstr = data as? String,let url = URL.init(string: urlstr) {
            rightImgV.image = nil
            rightImgV.sd_setImage(with: url)
        }
        if let img = data as? UIImage {
            rightImgV.image = img
        }

    }

}
