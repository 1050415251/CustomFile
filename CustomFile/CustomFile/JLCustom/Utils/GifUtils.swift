//
//  GifUtils.swift
//  CustomFile
//
//  Created by 国投 on 2018/10/8.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation
import ImageIO
import QuartzCore
import UIKit

class GifView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    func showgif(path: String?) {
        if let realpath = Bundle.main.path(forResource: path, ofType: "gif") {
            showgirFrame(url: URL.init(string: realpath))
        }
    }

    private func showgirFrame(url: URL) {
        let cfurl = url as! CFURL
        let gifsource = CGImageSourceCreateWithURL(cfurl, nil)
        let imgcount = CGImageSourceGetCount(gifsource)



        var imgArray:[CGImage] = []
        var timeArray:[NSNumber] = []
        for index in 0..<imgcount {
            let imgRef = CGImageSourceCreateImageAtIndex(gifsource, index, nil)
            imgArray.append(imgRef)

            let sourceDic = CGImageSourceCopyPropertiesAtIndex(imgRef, index, nil) as! NSDictionary
            let gifdic = sourceDic![kCGImagePropertyGIFDictionary]
            let time = gifdic![kCGImagePropertyGIFDelayTime]
            timeArray.append(time)
            /// 自适应uiview
            let imgWidth = sourceDic![kCGImagePropertyWidth] as! CGFloat
            let imgHeight = sourceDic![kCGImagePropertyHeight] as! CGFloat
            if self.frame.size.width/self.frame.size.height != imgWidth/imgHeight {
                fitscale(imgWidth: imgWidth, imgHeight: imgHeight)
            }
        }
        showAnimation(timeArr: timeArr, gifArr: imgArray)
    }

    private func fitscale(imgWidth: CGFloat,imgHeight: CGFloat) {
        var newWidth:CGFloat = 0
        var newHeight:CGFloat = 0
        if imgWidth/imgHeight > self.frame.size.width/self.frame.size.height {
            newWidth = self.frame.size.width
            newHeight = self.frame.size.width/(imgWidth/imgHeight)
        }else {
            newWidth = self.frame.size.height * (imgWidth/imgHeight)
            newHeight = self.frame.size.height
        }
        let point = self.center
        self.frame.size = CGSize.init(width: newWidth, height: newHeight)
        self.center = point
    }

    private func showAnimation(timeArr:[NSNumber],totaltime: NSNumber,imgArray:[CGImage]) {
        let animation = CAKeyframeAnimation.init(keyPath: "contents")
        var current:Float = 0
        var currentTimeArr:[NSNumber] = []
        for time in timeArr {
            currentTimeArr.append(NSNumber.init(value: current/totaltime))
            current += time.floatValue
        }
        animation.keyTimes = timeArr
        animation.values = imgArray
        animation.duration = totaltime
        animation.isRemovedOnCompletion = false
    }
}
