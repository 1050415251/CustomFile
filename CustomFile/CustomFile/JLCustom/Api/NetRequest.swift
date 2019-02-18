////
////  NetRequest.swift
////  GTEDai
////
////  Created by 国投 on 2018/1/24.
////  Copyright © 2018年 国投. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//
//class AlamofireManager {
//    private static var session:SessionManager!
//    class func shareInstance() -> SessionManager {
//        //不应该每次调用此方法都要初始化，应当检测是否初始化过，如果已经初始化就不需要进行初始化
//        if session == nil {
//            ///初始化
//            let configuration = URLSessionConfiguration.default
//            #if DEBUG
//
//                configuration.timeoutIntervalForRequest = 15
//
//            #else
//                configuration.timeoutIntervalForRequest = 15
//            #endif
//            if session == nil {
//                session = Alamofire.SessionManager(configuration:configuration)
//            }
//        }
//        return session
//    }
//}
//
//
//
//class RequestClient<T: BaseBean>: NSObject {
//
//
//
//    //TODO:- 请求接口
//    /// - parameter method: 请求方式
//    /// - parameter url: 请求url
//    /// - parameter params: 请求参数
//    /// - parameter jsonDatacallback: 回调，返回原始json数据
//    /// - parameter successful:请求成功的回调
//    /// - parameter failed:请求失败的回调
//    class func requestByget(url:String,params:[String:Any]?,jsonDatacallback:((JSON)->Void)?,successful:((T?)->Void)?,failed:((NSError)->Void)?,dataKey:String?) {
//
//        let newurl = NetConstants.api + url
//        DEBUG.DEBUGPRINT(obj: "来自\(newurl)的参数：")
//        var p:[String:Any] = ["":""]
//
//        p.removeValue(forKey: "")
//        DEBUG.DEBUGPRINT(obj: "来自\(newurl)的参数：")
//        DEBUG.DEBUGPRINT(obj: p,bringTime:false)
//        if RequestManager.shared.containsRequestWith(urlString: newurl) {
//            return
//        }
//        let request = AlamofireManager.shareInstance().request(newurl, method: .get, parameters: p).responseJSON {(response) in
//            handlerJsonInfo(response: response, isList: false, newUrl: newurl, jsonDatacallback: jsonDatacallback, successful: successful, failed: failed, dataKey: dataKey)
//        }
//        RequestManager.shared.addRequest(requestUrlString: newurl, request: request)
//    }
//
//    //MARK:- 请求表数据接口
//    /// - parameter method: 请求方式
//    /// - parameter url: 请求url
//    /// - parameter params: 请求参数
//    /// - parameter jsonDatacallback: 回调，返回原始json数据
//    /// - parameter successful:请求成功的回调
//    /// - parameter failed:请求失败的回调
//    /// - dataKey: 数组list放到json的key  传nil意思为直接从data里取 否则是data对应的obj然后去obj对应的数组
//    class func requestList(method:HTTPMethod,url:String,params:[String:Any]?,byForm: Bool,jsonDatacallback:((JSON)->Void)?,successful:(([T]?) -> Void)?,failed:((NSError)->Void)?,dataKey:String?) {
//        var headers:[String:String] = ["Content-Type":byForm ? "application/x-www-form-urlencoded":"application/json"]
//
//        headers.updateValue(SystemUtils.getLocalAppVersion(), forKey: "appVersion")
//        headers.updateValue("ios", forKey: "platForm")
//
//        let newurl = NetConstants.api + url
//        var p:[String:Any] = ["":""]
//        if let _ = params {
//            p = params!
//
//        }
//        p.removeValue(forKey: "")
//        DEBUG.DEBUGPRINT(obj: "来自\(newurl)的参数：")
//        DEBUG.DEBUGPRINT(obj: p,bringTime:false)
//
//        if RequestManager.shared.containsRequestWith(urlString: newurl) {
//            return
//        }
//
//        if byForm {
//            let request = AlamofireManager.shareInstance().request(newurl,method: .post,parameters: p,headers: headers).responseJSON { (response) in
//                handlerJsonInfo(response: response, isList: true, newUrl: newurl, jsonDatacallback: jsonDatacallback, successfullist: successful, failed: failed, dataKey: dataKey)
//            }
//            RequestManager.shared.addRequest(requestUrlString: newurl, request: request)
//
//        }else {
//            let request = AlamofireManager.shareInstance().request(newurl, method: .post, parameters:params,encoding:JSONEncoding.default ,headers:headers).responseJSON{ (response) in
//                handlerJsonInfo(response: response, isList: true, newUrl: newurl, jsonDatacallback: jsonDatacallback, successfullist: successful, failed: failed, dataKey: dataKey)
//            }
//            RequestManager.shared.addRequest(requestUrlString: newurl, request: request)
//        }
//    }
//
//
//    class func requestByPost(url:String,params:[String:Any]?,byForm:Bool,jsonDatacallback:((JSON)->Void)?,successful:((T?) -> Void)?,failed:((NSError)->Void)?,dataKey:String?) {
//        var headers:[String:String] = ["Content-Type":byForm ? "application/x-www-form-urlencoded":"application/json"]
//
//        headers.updateValue(SystemUtils.getLocalAppVersion(), forKey: "appVersion")
//        headers.updateValue("ios", forKey: "platForm")
//
//        let newurl = NetConstants.api + url
//        var p:[String:Any] = ["":""]
//        if let _ = params {
//            p = params!
//
//        }
//
//        p.removeValue(forKey: "")
//        DEBUG.DEBUGPRINT(obj: "来自\(newurl)的参数：")
//        DEBUG.DEBUGPRINT(obj: p,bringTime:false)
//        if RequestManager.shared.containsRequestWith(urlString: newurl) {
//            return
//        }
//        if byForm {
//
//            let request =  AlamofireManager.shareInstance().request(newurl,method: .post,parameters: p,headers: headers).responseJSON { (response) in
//                handlerJsonInfo(response: response, isList: false, newUrl: newurl, jsonDatacallback: jsonDatacallback, successful: successful, failed: failed, dataKey: dataKey)
//            }
//            RequestManager.shared.addRequest(requestUrlString: newurl, request: request)
//        }else {
//            let request =  AlamofireManager.shareInstance().request(newurl, method: .post, parameters:p,encoding:JSONEncoding.default ,headers:headers).responseJSON{ (response) in
//                handlerJsonInfo(response: response, isList: false, newUrl: newurl, jsonDatacallback: jsonDatacallback, successful: successful, failed: failed, dataKey: dataKey)
//            }
//            RequestManager.shared.addRequest(requestUrlString: newurl, request: request)
//        }
//    }
//
//    //处理下载的json数据
//    private class func handlerJsonInfo(response:DataResponse<Any>,isList:Bool,newUrl:String,jsonDatacallback:((JSON)->Void)?,successful:((T?) -> Void)? = nil,successfullist:(([T]?)->Void)? = nil,failed:((NSError)->Void)?,dataKey:String?) {
//    }
//
//}
//
////        RequestManager.shared.removeRequestWith(urlString: newUrl)
////        DEBUG.DEBUGPRINT(obj: "来自\(newUrl)的数据：")
////
////        if response.result.isSuccess {
////
////            let json = JSON.init(response.result.value!)
////           // DEBUG.DEBUGPRINT(obj: "来自\(newurl)的数据:")
////
////            DEBUG.DEBUGPRINT(obj: json,bringTime:false)
////            jsonDatacallback?(json)
////
////            ///此处解析如果 datakey里面是 obj 或者 array类型可以解析出来但是如果是string或者int 就需要单独调 jsoncallback因为 泛型不支持
////            if json["result"].intValue == ResultCode.PASS {
////                let info = json["data"]
////                if !isList {
////                    if let _ = dataKey {
////                        var js:JSON = info
////                        for (_,key) in dataKey!.components(separatedBy: ",").enumerated() {
////                            js = js["\(key)"]
////                        }
////                        if let data = T.yy_model(with: (info["\(dataKey!)"].dictionaryObject) ?? ["":""]) {
////                            successful?(data)
////                        }
////                    }else {
////                        if let data = T.yy_model(with: (json["data"].dictionaryObject) ?? ["":""]) {
////                            successful?(data)
////                        }else {
////                            successful?(nil)
////                        }
////                    }
////                }else  {
////                    if let _ = dataKey {
////
////                        var js:JSON = info
////                        for (_,key) in dataKey!.components(separatedBy: ",").enumerated() {
////                            js = js["\(key)"]
////                        }
////                        if let datas = js.arrayObject,let array = NSArray.yy_modelArray(with: T.self, json: datas) as? [T] {
////                            successfullist?(array)
////                        }else {
////                            let info = [NSLocalizedDescriptionKey: "数据格式错误"]
////                            failed?(NSError.init(domain: "数据格式错误", code: 999, userInfo: info))
////                        }
////                    }else {
////                        if let datas = info.arrayObject,let array = NSArray.yy_modelArray(with: T.self, json: datas) as? [T] {
////                            successfullist?(array)
////                        }else {
////                            let info = [NSLocalizedDescriptionKey: "数据格式错误"]
////                            failed?(NSError.init(domain: "数据格式错误", code: 999, userInfo: info))
////                        }
////                    }
////                }
////            }else {
////                if (json["result"].intValue == -30 || json["result"].intValue == 21308) && User.shared.isLogined {
////                    Eventbus.instance.post(message: LoginOtherDevice())
////                }else {
////                    let info = [NSLocalizedDescriptionKey: json["msg"].stringValue]
////                    failed?(NSError.init(domain: json["msg"].stringValue, code: json["result"].intValue, userInfo: info))
////                }
////            }
////        }
////        else {
////            //如果把errorcode放到前面可能收不到失败的回调
////            DEBUG.DEBUGPRINT(obj: response.result.error?.localizedDescription ?? "",bringTime:false)
////            if response.result.error?.localizedDescription == "已取消" {
////                HUDUtil.hideHud()
////                return
////            }
////            if response.result.error?.localizedDescription == "似乎已断开与互联网的连接。" {
////                let info = [NSLocalizedDescriptionKey: ""]
////                failed?(NSError.init(domain:LocalError.BADNETWORD.errorDescription ?? "", code: ResultCode.NETERROR, userInfo: info))
////                return
////            }
////
////            guard let errcode = response.response?.statusCode else {
////                HUDUtil.hideHud()
////                let info = [NSLocalizedDescriptionKey: ""]
////                failed?(NSError.init(domain:"", code: ResultCode.PASS, userInfo: info))
////                return
////            }
////            DEBUG.DEBUGPRINT(obj: "错误码：\(errcode)",bringTime:false)
////
////            if APP.netmanager.reach.currentReachabilityStatus() == .NotReachable {
////                let info = [NSLocalizedDescriptionKey: "无网络链接"]
////                failed?(NSError.init(domain:"无网络链接", code: ResultCode.PASS, userInfo: info))
////            }else {
////                let info = [NSLocalizedDescriptionKey:response.error?.localizedDescription ?? "数据请求失败"]
////                failed?(NSError.init(domain: response.error?.localizedDescription ?? "数据请求失败", code: ResultCode.GETERROR, userInfo: info))
////            }
////
////
////        }
//
//
//
//
//
//
//
