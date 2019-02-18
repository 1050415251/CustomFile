//
//  KeyBoardUpUtils.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/18.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift




//键盘事件弹出事件 输入框随键盘变化 与 KeyBoardUpUtils区别 这个是自带的输入框而KeyBoardUpUtils是view上面的textview
class KeyBoardUtils: NSObject {
    
    weak var contentView:UIView!
    
    let keyboardBg = DisposeBag()
    
    var keyboardchangecallback:((CGFloat)->Void)?
    
    @objc dynamic var KEYBOARDDIDAPPEAR:Bool = false//键盘已经出现或者消失
    @objc dynamic var KEYBOARDWILLAPPEAR:Bool = false//键盘将要出现或者消失
    
    
    func initKeyBoardObserVer(view:UIView) {
        self.contentView = view
        (NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.handlerKeyboardNotice(sender:sender.element!)
            }
            
            }.disposed(by:keyboardBg)
        
        ///监听键盘显示 did
        (NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDDIDAPPEAR = true
            }
            }.disposed(by:keyboardBg)
        let _ = (NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDDIDAPPEAR = false
            }
            }.disposed(by:keyboardBg)
        
        ///监听键盘显示 will
        (NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDWILLAPPEAR = true
            }
            }.disposed(by:keyboardBg)
        let _ = (NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDWILLAPPEAR = false
            }
            }.disposed(by:keyboardBg)
        
    }
    
    private func handlerKeyboardNotice(sender:Notification) {
        
        let userinfo:[AnyHashable:Any] = sender.userInfo!
        
        let animation:TimeInterval = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame:CGRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        if keyboardchangecallback != nil {
            keyboardchangecallback?(endFrame.origin.y)
        }else {
            UIView.animate(withDuration: animation, animations: { [weak self] in
                if let s = self {
                    if s.contentView.frame.maxY > endFrame.origin.y {
                        // s.contentView.frame.origin.y = endFrame.origin.y - s.contentView.frame.size.height
                        s.contentView.snp.remakeConstraints({ (make) in
                            make.left.right.equalTo(0)
                            make.bottom.equalTo(-endFrame.height)
                        })
                    }else {
                        //  s.contentView.frame.origin.y = SCREEN_HEIGHT - s.contentView.frame.size.height
                        s.contentView.snp.remakeConstraints({ (make) in
                            make.left.right.equalTo(0)
                            make.bottom.equalTo(-UIUtils.TOLLBAR_HEIGHT)
                        })
                    }
                    s.contentView.layoutIfNeeded()
                }
            })
        }
    }
}




