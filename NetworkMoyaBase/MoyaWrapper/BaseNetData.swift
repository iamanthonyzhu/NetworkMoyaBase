//
//  BaseNetData.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/10.
//

import Foundation
import HandyJSON

public class BaseNetData:HandyJSON {
    var code:Int!
    var message:String?
    var data:Any?
    public var rawData:[String:Any]?
    var bizModel:Any?
    required public init() {}
    
    public struct Constants {
        static let success = (200, "")
        static let badNet = (400, "加载失败，请检查网络")
        static let errorData = (400, "网络不给力")
        static let badNetRetry = (404, "网络不给力，请检查后再试")
        static let badNetError = (404, "网络不给力")
        static let sessionError = (419, "登录超时，请重新登录")
        static let errorSalt = (600, "")
    }
    
    public var isSucess : Bool {
        get {
            return self.code == Constants.success.0
        }
    }
    
    public static func badNetData() -> BaseNetData {
        let badNet = BaseNetData()
        badNet.code = Constants.badNet.0
        badNet.message = Constants.badNet.1
        return badNet
    }

    public static func errorData() -> BaseNetData {
        let badNet = BaseNetData()
        badNet.code = Constants.errorData.0
        badNet.message = Constants.errorData.1
        return badNet
    }

    public static func saltError() -> BaseNetData {
        let badNet = BaseNetData()
        badNet.code = Constants.errorData.0
        badNet.message = Constants.errorData.1
        return badNet
    }

    public static func sessionError() -> BaseNetData {
        let badNet = BaseNetData()
        badNet.code = Constants.errorSalt.0
        badNet.message = Constants.errorSalt.1
        return badNet
    }

    public func mapping(mapper: HelpingMapper) {
        mapper <<< self.message <-- "msg"
    }
}

extension BaseNetData {
    public func encodeBizModel<T: HandyJSON>(type:T.Type = T.self) {
        if let data = self.data as? [Any] {
            if let historyList = JSONDeserializer<T>.deserializeModelArrayFrom(array: data) {
                self.bizModel = historyList
            }
        } else if let data = self.data as? [String:Any] {
            if let historyModel = JSONDeserializer<T>.deserializeFrom(dict: data) {
                self.bizModel = historyModel
            }
        }
    }
}

public class BaseNetRawData:HandyJSON {
    required public init() {}
}
