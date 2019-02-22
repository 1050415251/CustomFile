//
//  NetRequest.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/19.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import Alamofire
import HandyJSON


class JLRxNetRequest<T: BaseBean>: NSObject {

    class func reuqestlistinfoToServer(pathkey: String? = "data",requestParams: RequestParams) -> Observable<[T]> {
        let url = requestParams.url!
        let params = requestParams.params

        return Observable.create({  (observer) -> Disposable in
            switch requestParams.type! {
            case .post:
                /// post或者 form表单
                var header:[String: String] = ["Content-Type":requestParams.isForm ? "application/x-www-form-urlencoded":"application/json"]
                /// post请求
                self.toServer(pathkey: pathkey, url: url, params: params, method: .post,encoding:requestParams.isForm ? URLEncoding.default:JSONEncoding.default ,header: &header, complete: nil,completelistdata: { listdata in
                    observer.onNext(listdata)
                    observer.onCompleted()
                },failed: { (error) in
                    observer.onError(error)
                    observer.onCompleted()
                })
            case .get:
                var header: [String:String] = [String:String]()
                /// get请求
                self.toServer(pathkey: pathkey, url: url, params: params, method: .get, header: &header, complete: nil, completelistdata: { listdata in
                    observer.onNext(listdata)
                    observer.onCompleted()
                }, failed: { (error) in
                    observer.onError(error)
                    observer.onCompleted()
                })

            default:
                break
            }
            return Disposables.create {

            }
        })
    }


    /// 对外的api
    ///
    /// - Parameters:
    ///   - pathkey: json层级比如数据位于第三层级 可以 data/data1/data2 直接取到第三层级的数据
    ///   - requestParams: 请求参数
    /// - Returns: 返回数据的观察者
    class func reuqestinfoToServer(pathkey: String? = "data",requestParams: RequestParams) -> Observable<T> {

        let url = requestParams.url!
        let params = requestParams.params

        return Observable.create({  (observer) -> Disposable in
            switch requestParams.type! {
            case .post:
                /// post或者 form表单
            var header:[String: String] = ["Content-Type":requestParams.isForm ? "application/x-www-form-urlencoded":"application/json"]
            /// post请求
            self.toServer(pathkey: pathkey, url: url, params: params, method: .post,encoding:requestParams.isForm ? URLEncoding.default:JSONEncoding.default ,header: &header, complete: { (data) in
                observer.onNext(data)
                observer.onCompleted()
            }, failed: { (error) in
                observer.onError(error)
                observer.onCompleted()
            })
            case .get:
                var header: [String:String] = [String:String]()
            /// get请求
                self.toServer(pathkey: pathkey, url: url, params: params, method: .get, header: &header, complete: { (data) in
                observer.onNext(data)
                observer.onCompleted()
            }, failed: { (error) in
                observer.onError(error)
                observer.onCompleted()
            })
                
            default:
                break
            }
            return Disposables.create {

            }
        })
    }


    private class func toServer(pathkey: String?,url: String,params: [String:Any]?,method: HTTPMethod,encoding: ParameterEncoding = URLEncoding.default,header: inout  HTTPHeaders,complete: ((T)->Void)? = nil,completelistdata: (([T])->Void)? = nil,failed: ((Error)->Void)?) {

        AlamofireManager.shareInstance().request(URL.init(string: url)!, method: method, parameters: params, encoding: encoding, headers: header).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    var json = JSON.init(value)
                    debugPrint(json)
                    if let key = pathkey {
                        for (_,key) in key.components(separatedBy: "/").enumerated() {
                            json = json["\(key)"]
                        }
                    }
                    if let array = json.array {
                        var list: [T] = [T]()
                        for arr in array {
                            list.append(JSONDeserializer<T>.deserializeFrom(dict: arr.dictionaryObject)!)
                        }
                        completelistdata?(list)
                    }else {
                        if let result = JSONDeserializer<T>.deserializeFrom(dict: json.dictionaryObject) {
                            result.json = json
                            if let _ = pathkey {
                                result.result = json["result"].intValue
                                result.msg = json["msg"].stringValue
                            }
                            result.statuscode = response.response!.statusCode
                            complete?(result)
                        }
                    }
                }else {
                    failed?(JLError.dataError)
                }
            }else {
                failed?(JLError.unknowerror)

            }
        }

    }


    func uploadimageToServer(imgs:[UIImage],url:String,fileNames:[String]? = nil,complete: (()->Void)?,failed: (()->Void)?) {

        if imgs.count == 0 {
            fatalError("请检查照片数量为何不为0")
        }
        if let _ = fileNames {
            if imgs.count != fileNames!.count {
                fatalError("请检查照片数量与filename参数相等")
            }
        }

        var imageDataArray:[Data] = []
        for item in imgs {
            imageDataArray.append(zipPicture(item: item, imgData: item.jpegData(compressionQuality: 1.0)!).base64EncodedData())
        }
        AlamofireManager.shareInstance().upload(multipartFormData: { (multipartFormData) in
            for i in 0..<imageDataArray.count {
                multipartFormData.append(imageDataArray[i], withName: "file", mimeType: "image/jpeg")
                if let _ = fileNames {
                    multipartFormData.append(fileNames![i].data(using: String.Encoding.utf8)!, withName: "fileName")
                }
            }
        }, to: NetConstants.api + url, method: HTTPMethod.post) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.isSuccess,let value = response.result.value  {
                        let json = JSON.init(value)
                        debugPrint(json)
                        if json["result"].intValue == 0 {
                            complete?()
                        }
                    }else if response.result.isFailure {
                        failed?()
                    }
                }
            case .failure:
                break
            }
        }

    }

    private  func zipPicture(item:UIImage,imgData:Data) -> Data {
        DEBUG.DEBUGPRINT(obj: imgData.count)
        var compression: CGFloat = 0.9//压缩比例
        let maxSize = 1024//最小大小
        let maxCompression: CGFloat = 0.5//最小比例

        var newimgData = imgData
        while (imgData.count > maxSize) && (compression > maxCompression)  {

            compression-=0.1

            if let data = item.jpegData(compressionQuality: compression) {
                newimgData = data
            }else {
                return newimgData
            }
        }
        DEBUG.DEBUGPRINT(obj: newimgData.count)

        return newimgData
    }

}


class BaseBean: NSObject,HandyJSON {

    var statuscode: Int = 0
    var result:Int?
    var msg:String = ""
    var json: JSON?

    required override init() {

    }
}

class ResultListData<T: HandyJSON>: NSObject,HandyJSON {

    var statuscode: Int = 0
    var data: [T]?
    var result:Int?
    var msg:String = ""
    var json: JSON?
    required override init() {

    }
}

struct Result {

    static let SUCCESS = 0
    static let FAILED = 1
    static let REQUESTING = 2
    static let NOT_REQUEST = 3

}

class AlamofireManager {
    private static var session:SessionManager!
    class func shareInstance() -> SessionManager {
        //不应该每次调用此方法都要初始化，应当检测是否初始化过，如果已经初始化就不需要进行初始化
        if session == nil {
            ///初始化
            let configuration = URLSessionConfiguration.default
            #if DEBUG

            configuration.timeoutIntervalForRequest = 15

            #else
            configuration.timeoutIntervalForRequest = 15
            #endif
            if session == nil {
                session = Alamofire.SessionManager(configuration:configuration)
            }
        }
        return session
    }
}
