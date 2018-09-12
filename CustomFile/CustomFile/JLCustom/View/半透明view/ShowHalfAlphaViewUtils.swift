//
//  ShowHalfAlphaViewUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/9/15.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

///显示出半透明的
class ShowHalfAlphaViewUtils: NSObject {
    
    
    fileprivate weak var ctr:UIViewController!
    var alphaV:AlphaView!

    fileprivate var obsrver:AnyObserver<Int>!///点击第n项
    
    init(ctr:UIViewController) {
        self.ctr = ctr
        super.init()
        initView()
    }
    
    func initView() {
        
        alphaV = AlphaView.init(ctr: ctr)
        alphaV.backgroundColor = UIUtils.makeColor(r: 0, g: 0, b: 0, a: 0.5)
        ctr.view.addSubview(alphaV)
        alphaV.hidden()
    }
    
    func getViewSize(baseV:UIView,WIDTH:CGFloat) -> CGSize {
        let height = baseV.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        let size = CGSize.init(width: WIDTH, height: height)
        return size
    }

    func hidden() {
        alphaV.hidden()
    }
    
}

//MARK:显示出半透明的view
extension ShowHalfAlphaViewUtils {
    
//MARK:-------------------------------------------------------------------------
    //TODO: 展示出新手奖励的view
    func showrewardCompassView(action: NoViceTaskAction,url:String) {

        let imgV = UIImageView()
        imgV.sd_setImage(with: URL.init(string: url)!)
        imgV.frame = CGRect.init(x: (SCREEN_WIDTH - 375) * 0.5, y: (SCREEN_HEIGHT - 380) * 0.5 - scale(50), width: 375, height: 380)
        alphaV.showVframe = imgV.frame
        imgV.isUserInteractionEnabled = true
        alphaV.addSubview(imgV)
        alphaV.show()

        let btn = UIButton(type:.custom)
        btn.setBackgroundImage(#imageLiteral(resourceName: "app_findmoreprize"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickToNoviceWeflareWeb), for: UIControlEvents.touchUpInside)
        imgV.addSubview(btn)
        btn.snp.remakeConstraints { (make) in
            make.centerX.equalTo(imgV)
            make.bottom.equalTo(imgV).offset(-scale(30))
            make.width.equalTo(scale(136))
            make.height.equalTo(scale(30))
        }
    }

    @objc func clickToNoviceWeflareWeb() {
        self.alphaV.hidden_Animation()
        APP.navController.goH5("activity/2018/noviceWelfare/noviceTask.html")
    }

   
    
}

//MARK:点击区域
extension ShowHalfAlphaViewUtils  {

    func showimgView(img: UIImage,complete: (()->Void)?) {
        let bgV = UIView()
        bgV.backgroundColor = UIColor.clear
        alphaV.addSubview(bgV)

        let imgV = UIImageView(image: img)
        imgV.backgroundColor =  0xffffff.rgbColor
        imgV.layer.cornerRadius = scale(9)

        bgV.addSubview(imgV)
        imgV.snp.remakeConstraints { (make) in
            make.centerX.equalTo(bgV)
            make.width.equalTo(img.size.width)
            make.height.equalTo(img.size.height)
            make.top.equalTo(bgV)
        }

        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_btn"), for: UIControlState.normal)
        bgV.addSubview(closeBtn)
        closeBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(scale(30))
            make.centerX.equalTo(bgV)
            make.bottom.equalTo(bgV)
        }

        let _ = closeBtn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] (event) in
            if let _ = event.element {
                self?.alphaV.hidden_Animation()
                complete?()
            }
        }

        let height = bgV.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        bgV.frame = CGRect.init(x: (SCREEN_WIDTH - 305) * 0.5, y: (SCREEN_HEIGHT - height) * 0.5, width: 305, height: height)
        alphaV.CLICKELSEHIDDEN = false
        alphaV.showVframe = bgV.frame
        alphaV.show_Animation()
    }

}

//MARK:点击区域
extension ShowHalfAlphaViewUtils {
    
    ///点击第n项的信号源
    var rx_click:Observable<Int> {
        return Observable.create({[weak self] (observers) -> Disposable in
            self?.obsrver = observers
            return Disposables.create {
            }
        })
    }
    
    ///接受view点击的回调信号
    fileprivate var rx_acceptclick:AnyObserver<Int> {
        return Binder.init(self, binding: {[weak self] (util, index) in
            self?.hidden()
            self?.obsrver.on(Event.next(index))
        }).asObserver()
      
    }
    
}
